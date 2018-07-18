#!/usr/bin/env bash

state=`amixer -c 1 get Master | grep -Eo '\\[(on|off)\\]'`

# if [ $state = '[on]' ]; then
#     icon='<icon=/home/pierre/.xmonad/icons/sm4tik/xbm/spkr_01.xbm/>'
# else
#     icon='<icon=/home/pierre/.xmonad/icons/sm4tik/xbm/spkr_02.xbm/>'
# fi

if [ $state = '[on]' ]; then
    icon='<fn=1></fn>'
else
    icon='<fn=1></fn>'
fi

vol=`amixer -c 1 get Master | grep -Eo '[0-9]+%'`

echo "  $icon $vol" > /tmp/xmonad.music

