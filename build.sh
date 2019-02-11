#!/bin/bash

export PR=$(pwd)

source ${PR}/version.sh

mkdir -p ${PR}/logs
if [ ! -e ${PR}/logs/rootfs.done ]; then
	source ${PR}/createrootfs.sh
	touch ${PR}/logs/rootfs.done
fi

# build host-binutils

unset CFLAGS
unset CXXFLAGS

export LC_ALL=POSIX

export TARGET=x86_64-andi-linux-gnu
export TROOT=${PR}/rootfs
export HROOT=${PR}/host

# install binutils into host tools
./binutils.sh

# install gcc-cross into host tools
./gcc-cross.sh

# install kernel headers into host tools
./kernelheaders.sh

# install uclibc-headers into target rootfs
./uclibc-cross.sh

