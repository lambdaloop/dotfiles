#!/usr/bin/env bash

# takes small background as first argument, large as second
# output is third argument

convert -size 3200x1080 xc:#2d2d2d /tmp/blank.png
composite "$1" /tmp/blank.png "$3"
composite -geometry +1280+0 "$2" "$3" "$3"
