#!/usr/bin/env bash

amixer set Master on
amixer -c 1 set Master on
amixer -c 1 set Speaker on
amixer -c 1 set 'Bass Speaker' on

amixer -c 1 set Speaker 100%
amixer -c 1 set 'Bass Speaker' 100%
amixer -c 1 set Master 50%

mpc clear
mpc load alarm
mpc shuffle
mpc play
