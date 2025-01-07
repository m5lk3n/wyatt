#!/bin/bash

which yq > /dev/null || { echo "yq not found, please install it."; exit 1; }

cd "$(dirname "$0")"
VERSION=$(yq '.version' ../pubspec.yaml)
CHANGELOG=$(./print-changelog-as-md.sh)
m4 -D __VERSION__=${VERSION} -D __CHANGELOG__="${CHANGELOG}" index.template.html > wyatt/index.html