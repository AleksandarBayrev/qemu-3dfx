# QEMU MESA GL/3Dfx Glide Pass-Through
Copyright (C) 2018-2022<br>
KJ Liew \<liewkj@yahoo.com\>
## Content
    qemu-0/hw/3dfx      - Overlay for QEMU source tree to add 3Dfx Glide pass-through device model
    qemu-1/hw/mesa      - Overlay for QEMU source tree to add MESA GL pass-through device model
    scripts/sign_commit - Script for stamping commit id
    wrappers/3dfx       - Glide wrappers for supported guest OS/environment (DOS/Windows/DJGPP/Linux)
    wrappers/mesa       - MESA GL wrapper for supported guest OS/environment (Windows)
## Patch
    00-qemu720-mesa-glide.patch - Patch for QEMU version 7.2x (MESA & Glide)
    01-qemu620-mesa-glide.patch - Patch for QEMU version 6.2x (MESA & Glide)
    02-qemu520-mesa-glide.patch - Patch for QEMU version 5.2x (MESA & Glide)
## QEMU Windows Guests Glide/OpenGL/Direct3D Acceleration
Witness, experience and share your thoughts on modern CPU/GPU prowess for retro Windows games on Apple Silicon macOS, Windows 10/11 and modern Linux. Most games can be installed and played in pristine condition without the hassle of hunting down unofficial, fan-made patches to make them work on newer version of Windows.
- YouTube channel (https://www.youtube.com/channel/UCl8InhZs1ixZBcLrMDSWd0A/videos)
- VOGONS forums (https://www.vogons.org)
- Wiki (https://github.com/kjliew/qemu-3dfx/wiki)
## Building QEMU
### Dependencies (build based on Fedora 37 Host)
* `ninja-build`
* `glib2-devel`
* `meson`
* `pixman-devel`
* `SDL2-devel`
* `libXext-devel`
* `libXxf86vm-devel`

### Instructions
Following instructions are based on `MSYS2/mingw-w64` BASH shell environment on Windows 10/11. It is meant to be simple and minor variations are inevitable due to different flavors of Linux distributions.

Simple guide to apply the patch:<br>
(using `00-qemu720-mesa-glide.patch`)

    $ mkdir ~/myqemu && cd ~/myqemu
    $ git clone https://github.com/kjliew/qemu-3dfx.git
    $ cd qemu-3dfx
    $ wget https://download.qemu.org/qemu-7.2.0.tar.xz
    $ tar xf qemu-7.2.0.tar.xz
    $ cd qemu-7.2.0
    $ rsync -r ../qemu-0/hw/3dfx ./hw/
    $ rsync -r ../qemu-1/hw/mesa ./hw/
    $ patch -p0 -i ../00-qemu720-mesa-glide.patch
    $ bash ../scripts/sign_commit
    $ mkdir ../build && cd ../build
    $ ../qemu-7.2.0/configure && make

Or use the predefined scripts for respective versions (it builds the x86 version only).

## Building Guest Wrappers
**Requirements:**
 - `base-devel` (make, sed, xxd)
 - `gendef, shasum`
 - `mingw32` cross toolchain (`binutils, gcc, windres, dlltool`) for WIN32 DLL wrappers
 - `Watcom C/C++ 11.0` for DOS32 OVL wrapper
 - `i686-pc-msdosdjgpp` cross toolchain (`binutils, gcc, dxe3gen`) for DJGPP DXE wrappers
<br>

    $ cd ~/myqemu/qemu-3dfx/wrappers/3dfx
    $ mkdir build && cd build
    $ bash ../../../scripts/conf_wrapper
    $ make && make clean

    $ cd ~/myqemu/qemu-3dfx/wrappers/mesa
    $ mkdir build && cd build
    $ bash ../../../scripts/conf_wrapper
    $ make && make clean

## Installing Guest Wrappers
**For Win9x/ME:**  
 - Copy `FXMEMMAP.VXD` to `C:\WINDOWS\SYSTEM`  
 - Copy `GLIDE.DLL`, `GLIDE2X.DLL` and `GLIDE3X.DLL` to `C:\WINDOWS\SYSTEM`  
 - Copy `GLIDE2X.OVL` to `C:\WINDOWS`  
 - Copy `OPENGL32.DLL` to `Game Installation` folders

**For Win2k/XP:**  
 - Copy `FXPTL.SYS` to `%SystemRoot%\system32\drivers`  
 - Copy `GLIDE.DLL`, `GLIDE2X.DLL` and `GLIDE3X.DLL` to `%SystemRoot%\system32`  
 - Run `INSTDRV.EXE`, require Administrator Priviledge  
 - Copy `OPENGL32.DLL` to `Game Installation` folders

## Using qemu after building
* To create virtual hard drive: `./qemu-img create -f qcow2 win98se.qcw 20000M` (change the value of `20000M` to your HDD size requirements)
* To start installation: `./qemu-system-i386 -nodefaults -rtc base=localtime -M pc,accel=kvm,hpet=off,usb=off -cpu host -display sdl -device VGA -device lsi -device ac97 -netdev user,id=net0 -device pcnet,rombar=0,netdev=net0 -drive id=win98,if=none,file=win98se.qcw -device scsi-hd,drive=win98 -boot d -cdrom win98.iso`
* To start drive: `./qemu-system-i386 -nodefaults -rtc base=localtime -M pc,accel=kvm,hpet=off,usb=off -cpu host -display sdl -device VGA -device lsi -device ac97 -netdev user,id=net0 -device pcnet,rombar=0,netdev=net0 -boot c -drive id=win98,if=none,file=win98se.qcw -device scsi-hd,drive=win98 -cdrom win98.iso`

## Small notes for Windows 98 on modern machines
* To run the OS successfully on modern Hardware (Zen2+/Intel 11th Gen+) you need to use [patcher9x](https://github.com/JHRobotics/patcher9x). Check the repository on how to patch your Windows 98 image.
