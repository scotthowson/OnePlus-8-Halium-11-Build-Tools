#! /bin/sh

OUT_DIR=$1

RESOLUTION="1080x2160"
VENDOR=redmi.png
UBPORTS=bootlogobrand.png
FASTBOOT=fastboot.png
YUMI=yumi.png
BROKEN_YUMI=broken-yumi.png
UB_WIDTH=460

BMP_OPTIONS="-depth 8 -define bmp:format=bmp3"

OUT_DIR="$(realpath "$OUT_DIR" 2>/dev/null || echo 'out')"
SCRIPT="$(dirname "$(realpath "$0")")"

OUT_FILE="$OUT_DIR/splash.img"
TMP=$(mktemp -d)
mkdir -p "$OUT_DIR"

cd $SCRIPT

# Normal boot image
convert -size $RESOLUTION canvas:black \
    \( "$UBPORTS" -resize ${UB_WIDTH}x${UB_WIDTH} \) -gravity South -geometry +0+140 -composite \
    "$VENDOR" -gravity Center -geometry +0-80 -composite \
    $BMP_OPTIONS \
    $TMP/1.bmp

# Fastboot
convert -size $RESOLUTION canvas:black \
    \( "$FASTBOOT" -resize ${UB_WIDTH}x${UB_WIDTH} \) -gravity South -geometry +0+340 -composite \
    "$YUMI" -gravity Center -geometry +0-80 -composite \
    $BMP_OPTIONS \
    $TMP/2.bmp

# Unlocked
# cp 1.bmp 3.bmp

# System destroyed
convert -size $RESOLUTION canvas:black \
    "$BROKEN_YUMI" -gravity Center -geometry +0-80 -composite \
    $BMP_OPTIONS \
    $TMP/4.bmp

xzcat header.img.xz > "$OUT_FILE"
cat $TMP/1.bmp $TMP/2.bmp $TMP/1.bmp $TMP/4.bmp >> "$OUT_FILE"
xzcat end.img.xz >> "$OUT_FILE"

