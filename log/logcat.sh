#!/bin/zsh

# https://stackoverflow.com/questions/2882253/how-do-i-get-the-logfile-from-an-android-device

export ADB=~/Library/Android/sdk/platform-tools/adb

if [ ! -f ${ADB} ]; then
    echo "adb not found. Please install Android SDK and set the path to adb in this script."
    exit 1
fi

${ADB} shell logcat --pid=$(${ADB} shell pidof dev.lttl.wyatt) | tee wyatt.log