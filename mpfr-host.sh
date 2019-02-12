#!/bin/bash

set -e

if [ -e ${PR}/logs/mpfr-host.done ]; then
	exit 0
fi

mkdir -p ${PR}/build/mpfr-host
pushd ${PR}/build/mpfr-host

export CC=${HROOT}/bin/${TARGET}-gcc
export CFLAGS=-B${HROOT}/lib
export AS=${HROOT}/bin/${TARGET}-as
export LD=${HROOT}/bin/${TARGET}-ld
export CXX=${HROOT}/bin/${TARGET}-g++

../../source/${MPFR}/configure \
    --host=${TARGET} \
    --prefix=${HROOT} \


make -j 4 #all-gcc
make install #install-gcc

popd

touch ${PR}/logs/mpfr-host.done
