#!/usr/bin/env bash


# screenWidth=`xrandr | sed -rn '/\*/s/^\s+([0-9]+).*$/\1/p'`
screenWidth=`xrandr | sed -rn 's/.*current\s+([0-9]+).*$/\1/p'`

#outputs different stuff depending on number of screens
function three-modes
{
    if [ "$screenWidth" = '2560' ]; then
        eval "$1" #left screen
        #echo "left"
    elif [ "$screenWidth" = '1920' ]; then
        #right screen
        #echo "right"
        if [ -n "$3" ]; then
            eval "$3"
        else
            eval "$2"
        fi
    else
        # echo "two"
        eval "$2" #two screens
    fi
}


# three-modes 'habak -ms "/home/pierre/Pictures/wallpapers/chosen/small-filled"' \
#             'habak -ms "/home/pierre/Pictures/wallpapers/chosen/wide-filled"' &


habak -ms "/home/pierre/Pictures/wallpapers/chosen/small-filled"
