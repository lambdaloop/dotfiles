#!/usr/bin/env bash

# state=`amixer -c 1 get Master | grep -Eo '\\[(on|off)\\]'`
state=`pulseaudio-ctl full-status | cut -d' ' -f 2`

# if [ $state = '[on]' ]; then
if [ $state = 'no' ]; then
    icon='<fn=1></fn>'
else
    icon='<fn=1></fn>'
fi

# vol=`amixer -c 1 get Master | grep -Eo '[0-9]+%'`
vol=`pulseaudio-ctl full-status | cut -d' ' -f 1`

echo "  $icon $vol%" > /tmp/xmonad.music

