#!/usr/bin/env bash

state=`amixer -c 1 get Master | grep -Eo '\\[(on|off)\\]'`

if [ $state = '[on]' ]; then
    icon='<fn=1></fn>'
else
    icon='<fn=1></fn>'
fi

vol=`amixer -c 1 get Master | grep -Eo '[0-9]+%'`

echo "  $icon $vol" > /tmp/xmonad.music

