egrep -o '^ZSTDLIB_API .* (ZSTD[^ \(]* *\()' zstd/lib/zstd.h | egrep -o '(ZSTD[^ \(]* *\()' | egrep -o 'ZSTD[^ \(]*' | grep -iv thread | sed -e 's/^/_/g'
