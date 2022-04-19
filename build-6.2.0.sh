#!/bin/bash
bash ./clean.sh
wget https://download.qemu.org/qemu-6.2.0.tar.xz
tar xfv qemu-6.2.0.tar.xz
rm -rfv qemu-6.2.0.tar.xz
cd qemu-6.2.0
rsync -r ../qemu-0/hw/3dfx ./hw/
rsync -r ../qemu-1/hw/mesa ./hw/
patch -p0 -i ../00-qemu620-mesa-glide.patch
bash ../scripts/sign_commit
rm -rfv ../build && mkdir ../build && cd ../build
../qemu-6.2.0/configure --target-list=i386-softmmu && make -j