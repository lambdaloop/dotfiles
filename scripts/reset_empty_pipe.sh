#!/usr/bin/env bash

rm -f /tmp/xmonad.music
mkfifo /tmp/xmonad.music

rm -f /tmp/xmonad.empty
mkfifo /tmp/xmonad.empty


rm -f /tmp/xmonad.empty2
mkfifo /tmp/xmonad.empty2

echo "" > /tmp/xmonad.empty &
echo "" > /tmp/xmonad.empty2 &

