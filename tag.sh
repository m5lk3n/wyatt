#!/bin/bash

which yq > /dev/null || { echo "yq not found, please install it."; exit 1; }

cd "$(dirname "$0")"
TAG_NAME=v$(yq '.version' pubspec.yaml)
echo ${TAG_NAME}

# git tag ${TAG_NAME}
# git push origin tag ${TAG_NAME}