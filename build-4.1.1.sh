#!/bin/bash
bash ./clean.sh
wget https://download.qemu.org/qemu-4.1.1.tar.xz
tar xfv qemu-4.1.1.tar.xz
rm -rfv qemu-4.1.1.tar.xz
cd qemu-4.1.1
rsync -r ../qemu-0/hw/3dfx ./hw/
rsync -r ../qemu-1/hw/mesa ./hw/
patch -p0 -i ../02-qemu411-mesa-glide.patch
bash ../scripts/sign_commit
rm -rfv ../build && mkdir ../build && cd ../build
../qemu-4.1.1/configure && make -j