#!/usr/bin/env bash

radios=$(ls ~/Music/radios/ | cut -d '_' -f 1 | sort | uniq)

# radio=$(echo "$radios" | dmenu -nb "#2d2d2d" -sb "#37526e" -i -l 25 -b -fn "DejaVu Sans-12")
radio=$(echo "$radios" | rofi -dmenu -nb "#2d2d2d" -sb "#37526e" -i -l 15 -font "DejaVu Sans 30")

if [ -n "$radio" ]; then
    bash ~/scripts/play_radio.sh ~/Music/radios/$radio*
fi
