#!/bin/bash

set -e

if [ -e ${PR}/logs/gcc-cross.done ]; then
	exit 0
fi

mkdir -p ${PR}/build/gcc-cross
pushd ${PR}/build/gcc-cross

pushd ../../source/${GCC}

[ -d ${MPFR} ] || cp -R ../${MPFR} .
[ -d ${GMP} ] || cp -R ../${GMP} .
[ -d ${MPC} ] || cp -R ../${MPC} .

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

sed -e "/m64=/s/lib64/lib/" -i.orig gcc/config/i386/t-linux64

popd

../../source/${GCC}/configure \
    --target=${TARGET} \
    --prefix=${HROOT} \
    --with-sysroot=${TROOT} \
    --with-newlib \
    --without-headers \
    --with-local-prefix=${HROOT} \
    --with-native-system-header-dir=${HROOT}/include \
    --disable-nls                                  \
    --disable-shared                               \
    --disable-multilib                             \
    --disable-decimal-float                        \
    --disable-threads                              \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libmpx                               \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++

make -j 4 #all-gcc
make install #install-gcc

#    --target=${TARGET}

popd

touch ${PR}/logs/gcc-cross.done
