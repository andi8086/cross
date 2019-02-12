#!/bin/bash

set -e

if [ -e ${PR}/logs/uclibc-cross.done ]; then
	exit 0
fi

mkdir -p ${PR}/build/uclibc-cross
pushd ${PR}/build/uclibc-cross

make -C ../../source/${UCLIBC} O=$(pwd) defconfig

sed \
    -e "s#KERNEL_HEADERS=.*#KERNEL_HEADERS=\"${HROOT}/include\"#g" \
    -e "s#RUNTIME_PREFIX=.*#RUNTIME_PREFIX=\"\"#g" \
    -e "s#DEVEL_PREFIX=.*#DEVEL_PREFIX=\"\"#g" \
    -e "s/HAS_NO_THREADS=n/#HAS_NO_THREADS is not set/g" \
    -e "s#CROSS_COMPILER_PREFIX=.*#CROSS_COMPILER_PREFIX=\"${HROOT}/bin/${TARGET}-\"#g" \
    -e "s#HARDWIRED_ABSPATH=y#HARDWIRED_ABSPATH=n#g" \
    -i .config


echo "UCLIBC_HAS_THREADS=y" >> .config
echo "UCLIBC_HAS_THREADS_NATIVE=y" >> .config
echo "UCLIBC_HAS_WCHAR=y" >> .config
echo "PTHREADS_DEBUG_SUPPORT=n" >> .config

make -j 4 -C ../../source/${UCLIBC} O=$(pwd) PREFIX=${HROOT} install_headers
make -j 4 -C ../../source/${UCLIBC} O=$(pwd) PREFIX=${HROOT} install

popd

touch ${PR}/logs/uclibc-cross.done
