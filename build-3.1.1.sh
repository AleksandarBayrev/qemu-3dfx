#!/bin/bash
bash ./clean.sh
wget https://download.qemu.org/qemu-3.1.1.tar.xz
tar xfv qemu-3.1.1.tar.xz
rm -rfv qemu-3.1.1.tar.xz
cd qemu-3.1.1
rsync -r ../qemu-0/hw/3dfx ./hw/
rsync -r ../qemu-1/hw/mesa ./hw/
patch -p0 -i ../03-qemu311-mesa-glide.patch
bash ../scripts/sign_commit
rm -rfv ../build && mkdir ../build && cd ../build
../qemu-3.1.1/configure && make -j