#!/bin/bash

cd "$(dirname "$0")"

if [ ! -f "wyatt/index.html" ]; then
    echo "wyatt/index.html not found. Did you run generate.sh?"
    exit 1
fi

scp -r wyatt/* root@lttl.dev:/usr/share/caddy/wyatt.lttl.dev
