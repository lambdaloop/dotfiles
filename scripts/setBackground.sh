#!/usr/bin/env bash


xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$1" &
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorHDMI-0/workspace0/last-image -s "$1" &
# xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorDP-1/workspace0/last-image -s "$1" &
# xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitoreDP-1/workspace0/last-image -s "$1" &
# xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorHDMI-2/workspace0/last-image -s "$1" &
# xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorHDMI-0/workspace0/last-image -s "$1" &

# nitrogen --force-setter=xinerama --set-auto "$1"
