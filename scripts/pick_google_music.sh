#!/usr/bin/env bash

# mpc stop

## remove any previous curl
ps -ef | grep curl | grep localhost:9999 | cut -d ' ' -f 4 | xargs kill

stations=$(curl "http://localhost:9999/get_all_stations?format=text")
# station=$(echo "$stations" | tac | cut -d '|' -f 1 | dmenu -nb "#2d2d2d" -sb "#37526e" -i -l 10 -b -fn "Noto Sans CJK KR-12")
station=$(echo "$stations" | tac | cut -d '|' -f 1 | rofi -dmenu -i -font "Noto Sans 24")
station_url=$(echo "$stations" | grep "^$station|" | cut -d '|' -f 2)

song_urls=$(curl -s $station_url | grep -Po 'http.*')

if [ -n "$song_urls" ]; then
    mpc clear
    echo "$song_urls" | xargs mpc add
    mpc play
fi
