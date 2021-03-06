#!/bin/sh -e

die() {
    echo "$@" 1>&2
    exit 1
}

roundTripTest() {
    if [ -n "$3" ]; then
        local c="$3"
        local p="$2"
    else
        local c="$2"
    fi

    rm -f tmp1 tmp2
    echo "roundTripTest: ./datagen $1 $p | $ZSTD -v$c | $ZSTD -d"
    ./datagen $1 $p | md5sum > tmp1
    ./datagen $1 $p | $ZSTD -v$c | $ZSTD -d  | md5sum > tmp2
    diff -q tmp1 tmp2
}

[ -n "$ZSTD" ] || die "ZSTD variable must be defined!"

printf "\n**** frame concatenation **** "

echo "hello " > hello.tmp
echo "world!" > world.tmp
cat hello.tmp world.tmp > helloworld.tmp
$ZSTD hello.tmp > hello.zstd
$ZSTD world.tmp > world.zstd
cat hello.zstd world.zstd > helloworld.zstd
$ZSTD -df helloworld.zstd > result.tmp
cat result.tmp
sdiff helloworld.tmp result.tmp
rm ./*.tmp ./*.zstd

echo frame concatenation test completed

echo "**** flush write error test **** "

echo "echo foo | $ZSTD > /dev/full"
echo foo | $ZSTD > /dev/full && die "write error not detected!"
echo "echo foo | $ZSTD | $ZSTD -d > /dev/full"
echo foo | $ZSTD | $ZSTD -d > /dev/full && die "write error not detected!"


echo "*** dictionary tests *** "

./datagen > tmpDict
./datagen -g1M | md5sum > tmp1
./datagen -g1M | $ZSTD -D tmpDict | $ZSTD -D tmpDict -dv | md5sum > tmp2
diff -q tmp1 tmp2

echo "*** multiple files tests *** "

./datagen -s1        > tmp1 2> /dev/null
./datagen -s2 -g100K > tmp2 2> /dev/null
./datagen -s3 -g1M   > tmp3 2> /dev/null
$ZSTD -f -m tmp*
ls -ls tmp*
rm tmp1 tmp2 tmp3
$ZSTD -df -m *.zst
ls -ls tmp*
$ZSTD -f -m tmp1 notHere tmp2 && die "missing file not detected!"
rm tmp*

echo "**** zstd round-trip tests **** "

roundTripTest
roundTripTest '' 6

if [ "$1" != "--test-large-data" ]; then
    echo "Skipping large data tests"
    exit 0
fi

roundTripTest -g270000000 1
roundTripTest -g270000000 2
roundTripTest -g270000000 3

roundTripTest -g140000000 -P60 4
roundTripTest -g140000000 -P60 5
roundTripTest -g140000000 -P60 6

roundTripTest -g70000000 -P70 7
roundTripTest -g70000000 -P70 8
roundTripTest -g70000000 -P70 9

roundTripTest -g35000000 -P75 10
roundTripTest -g35000000 -P75 11
roundTripTest -g35000000 -P75 12

roundTripTest -g18000000 -P80 13
roundTripTest -g18000000 -P80 14
roundTripTest -g18000000 -P80 15
roundTripTest -g18000000 -P80 16
roundTripTest -g18000000 -P80 17

roundTripTest -g50000000 -P94 18
roundTripTest -g50000000 -P94 19

roundTripTest -g99000000 -P99 20
roundTripTest -g6000000000 -P99 q
