#!/bin/bash

mkdir -p build && cd build && 

(
mkdir -p lib && cd lib &&

for f in ../../zstd/lib/**/*.c
do
	clang -DZSTD_MINIFY_LIB=1 -DZSTD_NO_INLINE=1 -c --target=wasm32 -nostdlib -I sysroot/include -I../../zstd/lib -o `basename $f`.o $f
done

llvm-ar -r libzstd_compress.a `echo ../../zstd/lib/{common,compress}/*.c | sed -e 's/\.c/.c.o/g' -e 's/[^ ]*\///g'`
llvm-ar -r libzstd_decompress.a `echo ../../zstd/lib/{common,decompress}/*.c | sed -e 's/\.c/.c.o/g' -e 's/[^ ]*\///g'`
llvm-ar -r libzstd.a *.c.o
)

for suffix in '' _min _compress _decompress
do
	exported_functions=../exported_functions${suffix}.exp
	clang --target=wasm32 -nostdlib -Wl,--no-entry \
		-Wl,--export,malloc -Wl,--export,calloc -Wl,--export,free -Wl,--export,setHeapPtr, \
		-Wl,--export,memcpy -Wl,--export,memmove -Wl,--export,memset \
		-Wl,-z,stack-size=$[8 * 1024 * 1024] -Wl,--lto-O2 -flto -O2 \
		-Wl,--allow-undefined -Wl,--no-gc-sections -I../zstd/lib -L./lib \
		../memory.c \
		-lzstd${suffix} `sed -e 's/^/-Wl,--export,/g' < ${exported_functions}` \
		-o zstd${suffix}-raw.wasm &&
	wasm-opt -Oz zstd${suffix}-raw.wasm -o zstd${suffix}.wasm &&
	rm zstd${suffix}-raw.wasm
done
