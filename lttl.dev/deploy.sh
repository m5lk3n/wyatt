#!/bin/bash

if [ ! -f "wyatt/index.html" ]; then
    echo "wyatt/index.html not found. Did you run generate.sh?"
    exit 1
fi

export TARGET=root@lttl.dev:/var/www/html/wyatt

scp wyatt/favicon.ico $TARGET
scp wyatt/index.html $TARGET
scp wyatt/restrictions.png $TARGET