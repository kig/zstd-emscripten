egrep -o '^ZSTDLIB_API [a-zA-Z0-9_ ]* (ZSTD[^ \(]* *\()' zstd/lib/zstd.h | egrep -o '(ZSTD[^ \(]* *\()' | egrep -o 'ZSTD[^ \(]*'
