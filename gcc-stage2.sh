#!/bin/bash

set -e

if [ -e ${PR}/logs/gcc-stage2.done ]; then
	exit 0
fi

pushd ${PR}/source

rm -rf ${GCC}
tar xf ${GCC}.tar.xz

cd ${GCC}
cp -R ../${MPC} ./mpc
cp -R ../${MPFR} ./mpfr
cp -R ../${GMP} ./gmp

cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $(${HROOT}/bin/${TARGET}-gcc -print-libgcc-file-name)`/include-fixed/limits.h

for file in gcc/config/{linux,i386/linux{,64}}.h
do
  cp -uv $file{,.orig}
  sed -e "s@/lib\(64\)\?\(32\)\?/ld@${HROOT}&@g" \
      -e "s@/usr@${HROOT}@g" $file.orig > $file
  echo "
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 \"${HROOT}/lib/\"
#define STANDARD_STARTFILE_PREFIX_2 \"\"" >> $file
  touch $file.orig
done

sed -e '/m64=/s/lib64/lib/' \
    -i.orig gcc/config/i386/t-linux64

popd

mkdir -p ${PR}/build/gcc-stage2
pushd ${PR}/build/gcc-stage2

CC=${HROOT}/bin/${TARGET}-gcc
CFLAGS=-B${HROOT}/lib
AR=${HROOT}/bin/${TARGET}-ar
RANLIB=${HROOT}/bin/${TARGET}-ranlib
AS=${HROOT}/bin/${TARGET}-as
LD=${HROOT}/bin/${TARGET}-ld
CXX=${HROOT}/bin/${TARGET}-g++
CPP=${HROOT}/lib/cpp
NM=${HROOT}/bin/${TARGET}-nm

../../source/${GCC}/configure \
    --prefix=${HROOT} \
    --with-local-prefix=${HROOT} \
    --with-native-system-header-dir=${HROOT}/include \
    --with-sysroot=${TROOT} \
    --enable-languages=c,c++ \
    --disable-libstdcxx-pch \
    --disable-multilib \
    --disable-threads \
    --disable-bootstrap \
    --disable-libgomp                              

make -j 12 #all-gcc
make install #install-gcc

ln -s gcc ${HROOT}/bin/cc

#    --target=${TARGET}

popd

touch ${PR}/logs/gcc-stage2.done
