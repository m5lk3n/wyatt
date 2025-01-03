#!/bin/zsh

# inspired by https://stackoverflow.com/questions/28217333/how-to-record-android-devices-screen-on-android-version-below-4-4-kitkat

export ADB=~/Library/Android/sdk/platform-tools/adb
export MP4_FILENAME=screenrecording.mp4
export GIF_FILENAME=screenrecording.gif
export DEVICE_FOLDER=/storage/emulated/0/Android/data/dev.lttl.wyatt/files/

if [ ! -f ${ADB} ]; then
    echo "adb not found. Please install Android SDK and set the path to adb in this script."
    exit 1
fi
if ! [ -x "$(command -v ffmpeg)" ]; then
    echo "ffmpeg not found. Please install ffmpeg."
    exit 1
fi

if [ $# -ne 1 ]; then
    echo "Usage: $0 [do|get]"
    echo "  do: record screen (as .mp4) on device"
    echo "  get: get screen recording from device"
    echo "  convert: convert local screen recording from .mp4 to animated gif"
    exit 1
fi

if [[ "$1" == "convert" ]]; then
    # https://superuser.com/questions/436056/how-can-i-get-ffmpeg-to-convert-a-mov-to-a-gif
    echo "Converting screenrecording to animated gif..."
    ffmpeg -i ${MP4_FILENAME} ${GIF_FILENAME} # -c:v libx264 -preset ultrafast -crf 0 -s 320x240
    echo "Screenrecording converted to: ./${GIF_FILENAME}"
    exit 0
fi

vared -p 'Android device plugged in and unlocked? Press Y/y to continue: ' -c REPLY
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    case "$1" in
        "do")
            confirm()
            echo "Recording screen..."
            echo "(press Control + C to stop recording)"
            ${ADB} shell screenrecord --verbose ${DEVICE_FOLDER}${MP4_FILENAME}
            ;;
        "get")
            confirm()
            echo "Moving screenrecording from device to local machine..."
            ${ADB} pull ${DEVICE_FOLDER}${MP4_FILENAME}
            ${ADB} shell rm ${DEVICE_FOLDER}${MP4_FILENAME}
            echo "Android device screenrecord saved as: ./${MP4_FILENAME}"
            ;;
        *)
            echo "Invalid option. Usage: $0 [do|get|convert]"
            exit 1
            ;;
    esac
fi