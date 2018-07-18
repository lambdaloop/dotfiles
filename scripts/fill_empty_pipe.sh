#!/usr/bin/env bash

rm -f /tmp/xmonad.empty
mkfifo /tmp/xmonad.empty

while [ 1 ]; do
    echo "" > /tmp/xmonad.empty
    sleep 5
done
