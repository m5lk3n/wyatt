#!/bin/zsh

export TS=$(date +%s)
export ADB=~/Library/Android/sdk/platform-tools/adb

if [ ! -f ${ADB} ]; then
    echo "adb not found. Please install Android SDK and set the path to adb in this script."
    exit 1
fi

if ! [ -x "$(command -v magick)" ]; then
    echo "magick not found. Please install imagemagick."
    exit 1
fi

vared -p 'Android device plugged in and unlocked? Press Y/y to screenshot its screen: ' -c REPLY

if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    # https://stackoverflow.com/questions/27766712/using-adb-to-capture-the-screen
    ${ADB} exec-out screencap -p > ${TS}.png
    magick ${TS}.png -resize 50% ${TS}.png
    echo "Android device screenshot saved as: ${TS}.png"
fi