#!/usr/bin/env bash

url="$@"
echo "$url" > ~/tmp/test.log
if [[ $url == http* ]]; then
    mpc clear
    mpc add "$url"
else
    ln -sf "$url" ~/Music/temp
    base=$(basename "$url")
    mpc update
    sleep 1
    mpc clear
    mpc add temp/"$base"
fi

mpc play

