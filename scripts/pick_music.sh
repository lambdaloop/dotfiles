#!/usr/bin/env bash

# song=$(mpc -f "%position% - [%title%|%file%|%track%] - %artist%[ - %album%]" playlist |
#            dmenu -nb "#2d2d2d" -sb "#37526e" -i -l 25 -b  -fn "Noto Sans CJK KR-8")
song=$(mpc -f "%position% - [%title%|%file%|%track%] - %artist%[ - %album%]" playlist |
           rofi -dmenu -i -l 25 -font "Noto Sans 20")

if [ -n "$song" ]; then
    id=$(echo $song | cut -d '-' -f 1)
    mpc play $id
fi

