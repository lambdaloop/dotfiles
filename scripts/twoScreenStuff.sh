#!/usr/bin/env bash

# screenWidth=`xrandr | sed -rn '/\*/s/^\s+([0-9]+).*$/\1/p'`
screenWidth=`xrandr | sed -rn 's/.*current\s+([0-9]+).*$/\1/p'`

#outputs different stuff depending on number of screens
function three-modes
{
    if [ "$screenWidth" = '2560' ]; then
        echo "$1" #left screen
        #echo "left"
    elif [ "$screenWidth" = '1920' ]; then
        #right screen
        #echo "right"
        if [ -n "$3" ]; then
            echo "$3"
        else
            echo "$2"
        fi
    else
        # echo "two"
        echo "$2" #two screens
    fi
}

function three-modes-eval
{
    eval `three-modes $1 $2 $3`
}


bash ~/scripts/changeBackground.sh &

trayerOpts="--edge top --align right --SetDockType true --SetPartialStrut true --expand true --height 42 --transparent true --tint 0x2D3743 --alpha 0 --padding 0 --widthtype pixel"

percent=`three-modes 16 8`

# width=`three-modes 2560 1920 1920`
# trayerWidth=`echo "scale=4; $percent/100 * $width" | bc` #find trayer width, in pixels
# trayerWidth=`printf %0.f $trayerWidth` #round up trayer width
trayerWidth=`three-modes 205 308`

echo $trayerWidth
killall trayer
trayer --width $trayerWidth $trayerOpts &

#three-modes-eval 'trayer --width $width1 $trayerOpts' \
#    'trayer --width $width2 $trayerOpts' \
#    'trayer --width $width3 $trayerOpts' &

# trayer $trayerOpts &

