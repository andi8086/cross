#!/bin/bash

set -e

if [ -e ${PR}/logs/kernelheaders.done ]; then
	exit 0
fi

mkdir -p ${PR}/build/kernelheaders
pushd ${PR}/build/kernelheaders

make -C ../../source/${KERNEL} O=$(pwd) INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* ${HROOT}/include

popd

touch ${PR}/logs/kernelheaders.done
