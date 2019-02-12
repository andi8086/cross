if [ -e ${PR}/logs/binutils-stage2.done ]; then
	exit 0
fi

mkdir -p ${PR}/build/binutils-stage2
pushd ${PR}/build/binutils-stage2

CC=${HROOT}/bin/${TARGET}-gcc
AR=${HROOT}/bin/${TARGET}-gcc
RANLIB=${HROOT}/bin/${TARGET}-ranlib
CFLAGS=-B${HROOT}/lib

../../source/${BINUTILS}/configure \
	--prefix=${HROOT} \
	--with-lib-path=${HROOT}/lib \
	--with-sysroot=${TROOT} \
	--disable-nls \
	--disable-werror

make 

make install


popd

touch ${PR}/logs/binutils-stage2.done
