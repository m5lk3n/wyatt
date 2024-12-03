#!/bin/bash

export files=$(git status -s | cut -d ' ' -f 3)

for f in $files
do

if [ -f "$f" ] # skips deleted files
then
    touch $f
    d=$(date -r $f)
    echo $d: $f
fi

done