#!/usr/bin/env bash

rm -f /tmp/xmonad.music
mkfifo /tmp/xmonad.music

rm -f /tmp/xmonad.empty
mkfifo /tmp/xmonad.empty

rm -f /tmp/xmobar.ws
mkfifo /tmp/xmobar.ws

echo "" > /tmp/xmonad.empty &
echo "" > /tmp/xmonad.ws &


