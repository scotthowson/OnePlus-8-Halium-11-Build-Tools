# Ubuntu Touch device tree for the OnePlus 8 (instantnoodle)

This is based on Halium 11.0

[Install](#install) section.


## How to build

To manually build this project, follow these steps:

```bash
sudo chmod +x build.sh
sudo chmod +x build/*
```

```bash
export HOSTCC=gcc-9  # the build breaks with gcc-11
./build.sh -b instantnoodle  # instantnoodle is the name of the build directory
./build/prepare-fake-ota.sh out/device_violet.tar.xz ota
./build/system-image-from-ota.sh ota/ubuntu_command out
```


## Install

After the build process has successfully completed, run

```bash
fastboot delete-logical-partition product_b
fastboot delete-logical-partition system_ext_b

fastboot flash boot out/boot.img
fastboot flash system out/system.img

fastoot flash recovery out/twrp-3.7.0-instantnoodle.img
```

Mount --> Data --> Mount USB Storage

```bash
adb push out/rootfs.img /data/
```

Unmount Storage -- Back
Reboot --> Fastboot

```bash

fastboot create-logical-partition product_b 0x6000000
fastoot flash product_b out/product_b.img
fastboot create-logical-partition system_ext_b 0x6000000
fastoot flash system_ext_b out/system_ext_b.img




fastboot --disable-verification --disable-verity flash vbmeta vbmeta.img

```



## Splash screen

If you'd like to change the splash screen, run

```
./splash/generate.sh out
fastboot flash splash out/splash.img
```