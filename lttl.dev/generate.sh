#!/bin/bash

which yq > /dev/null || { echo "yq not found, please install it."; exit 1; }

cd "$(dirname "$0")"
VERSION=$(yq '.version' ../pubspec.yaml)
m4 -D __VERSION__=${VERSION} index.html.template > wyatt/index.html