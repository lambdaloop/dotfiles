#!/usr/bin/env bash

STATUS=`cat /sys/class/power_supply/BAT0/status`

if [ $STATUS = "Charging" ]; then
    # echo "<fc=#f0c674>ϟ</fc>"
    # echo "<icon=.xmonad/icons/fancy/battery-charging.xpm/>"
    # echo "<icon=.xmonad/icons/sm4tik/xbm/ac_01.xbm/>"
    # echo "<fc=#f0c674><icon=/home/pierre/.xmonad/icons/sm4tik/xbm/ac_01.xbm/></fc>"
    
    echo "<fc=#f0c674><fn=1></fn></fc>"
elif [ $STATUS = "Discharging" ]; then
    # echo "<fc=#ff3333>d</fc>"
    # echo "<icon=.xmonad/icons/fancy/battery-discharging.xpm/>"
    # echo "<fc=#e86f69><icon=/home/pierre/.xmonad/icons/sm4tik/xbm/bat_low_01.xbm/></fc>"

    echo "<fc=#e86f69><fn=1></fn></fc>"
else
    # echo "?"
    # echo "<icon=.xmonad/icons/sm4tik/xbm/ac_01.xbm/>"
    # echo "<icon=.xmonad/icons/fancy/battery-charged.xpm/>"
    # echo "<fc=#f0c674><icon=/home/pierre/.xmonad/icons/sm4tik/xbm/ac_01.xbm/></fc>"
    # echo "<icon=/home/pierre/.xmonad/icons/sm4tik/xbm/bat_full_01.xbm/>"

    echo "<fn=1></fn>"
fi
