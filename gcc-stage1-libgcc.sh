#!/bin/bash

set -e

if [ -e ${PR}/logs/gcc-stage1-libgcc.done ]; then
	exit 0
fi

mkdir -p ${PR}/build/gcc-stage1
pushd ${PR}/build/gcc-stage1

make all-target-libgcc
make install-target-libgcc

popd

touch ${PR}/logs/gcc-stage1-libgcc.done
