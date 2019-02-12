#!/bin/bash

set -e

if [ -e ${PR}/logs/libstdcxx.done ]; then
	exit 0
fi

mkdir -p ${PR}/build/libstdcxx
pushd ${PR}/build/libstdcxx

../../source/${GCC}/libstdc++-v3/configure \
    --host=${TARGET} \
    --prefix=${HROOT} \
    --disable-multilib \
    --disable-nls \
    --disable-libstdcxx-threads \
    --disable-libstdcxx-pch \
    --with-gxx-include-dir=${HROOT}/include/c++/7.3.0

make -j 4 #all-gcc
make install #install-gcc

#    --target=${TARGET}

popd

touch ${PR}/logs/libstdcxx.done
