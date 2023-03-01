# Ubuntu Touch device tree for the OnePlus 8 (instantnoodle)

This is based on Halium 11.0

[Install](#install) section.


## How to build

To manually build this project, follow these steps:

```bash
sudo chmod +x build.sh && sudo chmod +x build/*
```

```bash
export HOSTCC=gcc-9  # the build breaks with gcc-11
sudo ./build.sh -b instantnoodle  # instantnoodle is the name of the build directory
sudo ./build/prepare-fake-ota.sh out/device_instantnoodle.tar.xz ota
sudo ./build/system-image-from-ota.sh ota/ubuntu_command out

# If built successfully your system imgs will be in 'out/'
```




## Install


After the build process has successfully completed, run


```bash
# Preparing your device.
adb reboot fastboot
fastboot reboot fastboot

# Verify our device is in fastbootd.
fastboot devices
# If your device is listed while on stock recovery then proceed to the next steps.

# If you have issues with the device connecting 
# Check device manager and installing the USB drivers.
# https://github.com/IllSaft/OP8-USBDRV

# In order to flash our system.img we need to make room for it.
fastboot delete-logical-partition product_b
fastboot delete-logical-partition system_ext_b

# Flash boot & system with your built boot.img & system.img.
fastboot flash boot out/boot.img
fastboot flash dtbo out/dtbo.img
fastboot flash system out/system.img

# Flash recovery with TWRP
fastboot flash recovery out/twrp-3.7.0-instantnoodle.img
```
Step 1.

Volume Down --> Volume Down --> Power (English) --> Power (Advanced) --> Power (Reboot to fastboot) --> Power (Reboot to fastboot) 
--> Volume Down --> Volume Down --> Power (Recovery Mode) | You Should now be inside TWRP, congrats! give it a minute as it takes a while.

Step 2.

Wipe --> Advnaced Wipe --> ☑️Data --> Repair or Change File System --> Change File System --> EXT4 --> Swipe to Change 

Head back to the menu

Mount --> Data --> Mount USB Storage

```bash
# Flash recovery with TWRP
adb push out/rootfs.img /data/
```

Unmount --> Back --> Reboot --> Fastboot --> Swipe to reboot.

```bash

fastboot create-logical-partition product_b 0x6000000
fastboot flash product_b out/product_b.img
fastboot create-logical-partition system_ext_b 0x6000000
fastboot flash system_ext_b out/system_ext_b.img

# Untested (Will verify soon)
fastboot --disable-verification --disable-verity flash vbmeta vbmeta.img

```


## Splash screen

If you'd like to change the splash screen, run

```
./splash/generate.sh out
fastboot flash splash out/splash.img
```