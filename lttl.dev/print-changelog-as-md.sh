#!/bin/bash

for TAG in $(git tag --sort=-creatordate)
do
    TAG_DATE=$(git log -1 --pretty=format:'%ad' --date=short ${TAG})
    echo "**${TAG} (${TAG_DATE})**"
    TAG_COMMIT_MSG=$(git log -1 ${TAG} --pretty=format:'%s' --no-merges --no-color)
    echo "- ${TAG_COMMIT_MSG}"
    echo
done