# Ubuntu Touch device tree for the OnePlus 8 (instantnoodle)

This is based on Halium 11.0

[Setting up your build device](#Setting) section.

[How to build](#How) section.

[Install](#install) section.

[Splash screen](#Splash) section.


## Setting up your build device

Ubuntu (20.04 or newer)

If you are on the amd64 architecture (commonly referred to as 64 bit), enable the usage of the i386 architecture:

```bash
sudo dpkg --add-architecture i386
```

Update your package lists to take advantage of the new architecture:

```bash
sudo apt update
```

Install the required dependencies:

```bash
sudo apt install git gnupg flex bison gperf build-essential \
  zip bzr curl libc6-dev libncurses5-dev:i386 x11proto-core-dev \
  libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386 \
  libgl1-mesa-dev g++-multilib mingw-w64-i686-dev tofrodos \
  python-markdown libxml2-utils xsltproc zlib1g-dev:i386 schedtool \
  liblz4-tool bc lzop imagemagick libncurses5 rsync \
  python-is-python3
```

Run the following commands to download the repo script and ensure it is executable:

```bash
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+rx ~/bin/repo
```



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
<ol>
<li>
Step 1.
</li>
Volume Down --> Volume Down --> Power (English) --> Power (Advanced) --> Power (Reboot to fastboot) --> Power (Reboot to fastboot) 
--> Volume Down --> Volume Down --> Power (Recovery Mode) | You Should now be inside TWRP, congrats! give it a minute as it takes a while.

Step 2.

Wipe --> Advnaced Wipe --> ☑️Data --> Repair or Change File System --> Change File System --> EXT4 --> Swipe to Change 

Head back to the menu

Mount --> Data --> Mount USB Storage
<ol>

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