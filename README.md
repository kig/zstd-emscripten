# Zstd Emscripten build

This build is based on facebook/zstd and provides a thin WebAssembly wrapper around the zstd.h API. Please see [index.html](https://kig.github.io/zstd-emscripten/) for a demo and usage example.

This is a size-optimized build (ZSTD_MINIFY_LIB and ZSTD_NO_INLINE build flags). Uncompressed WASM is 263 kB, gzip 90 kB, brotli 73 kB.

Due to the build size optimizations, this build doesn't support dictionary building, legacy and deprecated parts of zstd.

Now tracking upstream as a submodule, rather than as a fork.

Thanks to Fredrick R. Brennan for their awesome work bringing this repo up-to-date with upstream Zstandard and fixing the CMake build files.

Thanks to Ilmari Heikkinen, @kig, for their initial work on the CMake build. 

## To build:

```bash
git clone https://github.com/emscripten-core/emsdk.git && cd emsdk && ./emsdk install latest && source ./emsdk_env.sh && cd .. &&
git clone https://github.com/kig/zstd-emscripten && cd zstd-emscripten && git submodule --init &&
cd build && emcmake cmake ../cmake/ && emmake make -j4 && cd .. &&
serve -p 5000
# open http://localhost:5000/index.html
```

## To use:

See the [test page](index.html) for examples on using the simple API and the streaming compression and decompression API.

## License

(c) 2016–2021 Ilmari Heikkinen, Fredrick R. Brennan. As with Zstd itself, this is dual-licensed under [BSD](LICENSE) and [GPLv2](COPYING).

