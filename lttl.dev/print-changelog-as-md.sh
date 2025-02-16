#!/bin/bash

MAX_TAGS=5
i=0

# get tags sorted by tag name in descending order, do not use creation date as this is not reliable when tag messages are edited
for TAG in $(git tag --sort=-"version:refname")
do
    # for each tag, print tag name and date in bold, followed by tag message as a list item
    TAG_DATE=$(git log -1 --pretty=format:'%ad' --date=short ${TAG})
    echo "**${TAG} (${TAG_DATE})**"
    # 1. get tag message, not commit message: git tag -l ${TAG} -n1
    #       example output: v0.2.1          adapt to Flutter 3.29, unified alert dialog style
    # 2. remove tag from message: sed -e "s/^${TAG}//"
    #       example output:         adapt to Flutter 3.29, unified alert dialog style
    # 3. remove leading spaces: xargs
    #       example output: adapt to Flutter 3.29, unified alert dialog style
    TAG_MSG=$(git tag -l ${TAG} -n1 | sed -e "s/^${TAG}//" | xargs)
    echo "- ${TAG_MSG}"
    echo
    i=$((i+1))
    [ $i -eq $MAX_TAGS ] && break
done