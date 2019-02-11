#!/bin/bash

mkdir rootfs
pushd rootfs

mkdir -pv ./{bin,boot,dev,{etc/,}opt,home,lib/{firmware,modules},lib64,mnt}
mkdir -pv ./{proc,media/{floppy,cdrom},sbin,srv,sys}
mkdir -pv ./var/{lock,log,mail,run,spool}
mkdir -pv ./var/{opt,cache,lib/{misc,locate},local}
install -dv -m 0750 ./root
install -dv -m 1777 .{/var,}/tmp
install -dv ./etc/init.d
mkdir -pv ./usr/{,local/}{bin,include,lib{,64},sbin,src}
mkdir -pv ./usr/{,local/}share/{doc,info,locale,man}
mkdir -pv ./usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv ./usr/{,local/}share/man/man{1,2,3,4,5,6,7,8}

for dir in ./usr{,/local}; do
     ln -sv ./share/{man,doc,info} ${dir}
done

popd
