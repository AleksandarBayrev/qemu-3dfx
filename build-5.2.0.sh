#!/bin/bash
bash ./clean.sh
wget --no-check-certificate https://download.qemu.org/qemu-5.2.0.tar.xz
tar xfv qemu-5.2.0.tar.xz
rm -rfv qemu-5.2.0.tar.xz
cd qemu-5.2.0
rsync -r ../qemu-0/hw/3dfx ./hw/
rsync -r ../qemu-1/hw/mesa ./hw/
patch -p0 -i ../02-qemu520-mesa-glide.patch
bash ../scripts/sign_commit
rm -rfv ../build && mkdir ../build && cd ../build
../qemu-5.2.0/configure --target-list=i386-softmmu && make -j
bash ./after-build-cleanup.sh
