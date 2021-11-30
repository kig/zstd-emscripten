#!/bin/bash

for suffix in '' _min _compress _decompress
do
	exported_functions=../exported_functions${suffix}.exp
	clang --target=wasm32 -nostdlib -Wl,--no-entry \
		-Wl,--export,malloc -Wl,--export,calloc -Wl,--export,free -Wl,--export,setHeapPtr, \
		-Wl,--export,memcpy -Wl,--export,memmove -Wl,--export,memset \
		-Wl,--allow-undefined -Wl,--no-gc-sections -I../zstd/lib -L../build/lib \
		-Wl,-z,stack-size=$[8 * 1024 * 1024] -Wl,--lto-O2 -flto -O2 memory.c \
		-lzstd${suffix} `sed -e 's/^/-Wl,--export,/g' < ${exported_functions}` \
		-o zstd${suffix}-raw.wasm &&
	wasm-opt -Oz zstd${suffix}-raw.wasm -o zstd${suffix}.wasm &&
	rm zstd${suffix}-raw.wasm
done
