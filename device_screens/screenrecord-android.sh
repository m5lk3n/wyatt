#!/bin/zsh

# inspired by
# - https://github.com/lana-20/adb-shell-screenrecord
# - https://stackoverflow.com/questions/28217333/how-to-record-android-devices-screen-on-android-version-below-4-4-kitkat

scriptname=$(basename "$0")

usage() {
    echo "Usage: $scriptname [do|get|convert]"
    echo "  do: record screen (as .mp4) on device"
    echo "  get: get screen recording from device"
    echo "  convert: convert local screen recording from .mp4 to animated gif"
    exit 1
}

case "$1" in
    "do"|"get"|"convert")
        ;;
    *)
        usage
        ;;
esac

export MP4_FILENAME=screenrecording.mp4
export GIF_FILENAME=screenrecording.gif

if [[ "$1" == "convert" ]]; then
    if ! [ -x "$(command -v ffmpeg)" ]; then
        echo "ffmpeg not found. Please install ffmpeg."
        exit 1
    fi
    if [ ! -f ${MP4_FILENAME} ]; then
        echo "No screenrecording found. Please 'do' record screen on Android device first and 'get' it."
        echo
        usage
    fi

    # https://trac.ffmpeg.org/wiki/Encode/H.264
    echo "Converting screenrecording to animated gif..."
    ffmpeg -i ${MP4_FILENAME} ${GIF_FILENAME} # -s 270x585 -c:v libx264 -preset slow -crf 22
    echo "Screenrecording converted to: ./${GIF_FILENAME}"
    exit 0
fi

export ADB=~/Library/Android/sdk/platform-tools/adb
export DEVICE_FOLDER=/storage/emulated/0/Android/data/dev.lttl.wyatt/files/
if [ ! -f ${ADB} ]; then
    echo "adb not found. Please install Android SDK and set the path to adb in this script."
    exit 1
fi

vared -p 'Android device plugged in and unlocked? Press Y/y to continue: ' -c REPLY
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    case "$1" in
        "do")
            echo "Recording screen..."
            echo "(press Control + C to stop recording)"
            ${ADB} shell screenrecord ${DEVICE_FOLDER}${MP4_FILENAME}
            ;;
        "get")
            echo "Moving screenrecording from device to local machine..."
            ${ADB} pull ${DEVICE_FOLDER}${MP4_FILENAME}
            ${ADB} shell rm ${DEVICE_FOLDER}${MP4_FILENAME}
            echo "Android device screenrecord saved as: ./${MP4_FILENAME}"
            ;;
    esac
fi