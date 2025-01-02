#!/bin/zsh

# inspired by https://stackoverflow.com/questions/28217333/how-to-record-android-devices-screen-on-android-version-below-4-4-kitkat

export ADB=~/Library/Android/sdk/platform-tools/adb
export FILENAME=screenrecording.mp4
export DEVICE_FOLDER=/storage/emulated/0/Android/data/dev.lttl.wyatt/files/

if [ ! -f ${ADB} ]; then
    echo "adb not found. Please install Android SDK and set the path to adb in this script."
    exit 1
fi

if [ $# -ne 1 ]; then
    echo "Usage: $0 [do|get]"
    echo "  do: record screen"
    echo "  get: get screen recording from device"
    exit 1
fi

vared -p 'Android device plugged in and unlocked? Press Y/y to continue: ' -c REPLY

if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    if [[ "$1" == "do" ]]; then
        echo "Recording screen..."
        echo "(press Control + C to stop recording)"
        ${ADB} shell screenrecord --verbose ${DEVICE_FOLDER}${FILENAME}
    fi
    if [[ "$1" == "get" ]]; then
        echo "Moving screenrecording from device to local machine..."
        ${ADB} pull ${DEVICE_FOLDER}${FILENAME}
        ${ADB} shell rm ${DEVICE_FOLDER}${FILENAME}
        echo "Android device screenrecord saved as: ./${FILENAME}"    
    fi
fi