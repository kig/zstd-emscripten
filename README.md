# Zstd Emscripten build

This build is based on [facebook/zstd](https://github.com/facebook/zstd) and provides a thin WebAssembly wrapper around the zstd.h API. Please see [index.html](https://kig.github.io/zstd-emscripten/) for a demo and usage example.

This is a size-optimized build (ZSTD_MINIFY_LIB and ZSTD_NO_INLINE build flags). The build output is four versions of the binding: full, compress-only, decompress-only, and compress+decompress-only. The brotli-compressed size of the wasm varies from 23 kB decompress-only to 76kB full binding.

This repo tracks the upstream as a submodule. 

The previous forked repo is [archived](https://github.com/kig/zstd-emscripten-archived/).

Thanks to Fredrick R. Brennan for their awesome work bringing the forked repo up-to-date with upstream Zstandard and fixing the CMake build files.

## Build

Skip the first line if you already have Emscripten set up.

```bash
git clone https://github.com/emscripten-core/emsdk.git && cd emsdk && ./emsdk install latest && ./emsdk activate latest && source ./emsdk_env.sh && cd .. &&
git clone https://github.com/kig/zstd-emscripten && cd zstd-emscripten && git submodule update --init &&
mkdir -p build && cd build && emcmake cmake ../cmake/ && emmake make -j4 && cd .. &&
serve -p 5000
# open http://localhost:5000/index.html
```

## Usage

See the [test page](index.html) for examples on using the simple API and the streaming compression and decompression API.

Zstd-emscripten is a 1:1 binding to the ZSTD API in [zstd.h](https://github.com/facebook/zstd/blob/dev/lib/zstd.h), please refer to the [ZSTD docs](http://facebook.github.io/zstd/zstd_manual.html) for further details.

The compress-only and decompress-only versions of the library bind just a few functions, see [exported_functions_compress.txt](exported_functions_compress.txt) and [exported_functions_decompress.txt](exported_functions_decompress.txt) for the exported function lists. The full version function list is in [exported_functions.txt](exported_functions.txt).

## License

(c) 2016–2021 Ilmari Heikkinen, Fredrick R. Brennan. As with Zstd itself, this is dual-licensed under [BSD](LICENSE) and [GPLv2](COPYING).

