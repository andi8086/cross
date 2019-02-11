if [ -e ${PR}/logs/binutils.done ]; then
	exit 0
fi

mkdir -p ${PR}/build/binutils
pushd ${PR}/build/binutils

../../source/${BINUTILS}/configure \
	--target=${TARGET} \
	--prefix=${HROOT} \
	--with-lib-path=${HROOT}/lib \
	--with-sysroot=${TROOT} \
	--disable-nls \
	--disable-werror

make all-{binutils,gas,ld}

if [ ! -d ${HROOT}/lib64 ]; then
	ln -sv lib ${HROOT}/lib64
fi

make install-{binutils,gas,ld}

popd

touch ${PR}/logs/binutils.done
