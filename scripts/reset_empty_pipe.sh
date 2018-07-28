#!/usr/bin/env bash

rm -f /tmp/xmonad.music
mkfifo /tmp/xmonad.music

rm -f /tmp/xmonad.empty
mkfifo /tmp/xmonad.empty

# rm -f /tmp/xmonad.empty2
# mkfifo /tmp/xmonad.empty2

rm -f /tmp/xmobar.ws
mkfifo /tmp/xmobar.ws

echo "" > /tmp/xmonad.empty &
echo "" > /tmp/xmonad.ws &
# echo "" > /tmp/xmonad.empty2 &


