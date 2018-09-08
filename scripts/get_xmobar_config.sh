#!/usr/bin/env bash

screenWidth=`xrandr | sed -rn 's/.*current\s+([0-9]+).*$/\1/p'`

#outputs different stuff depending on large or small screen
function two-modes
{
    if [ "$screenWidth" = '2560' ]; then
        echo "$1" #left screen
        #echo "left"
    else
        # echo "two"
        echo "$2" #two screens
    fi
}

fname=`two-modes xmobarrc_1 xmobarrc_2`
echo ~/.xmonad/xmobar/$fname
