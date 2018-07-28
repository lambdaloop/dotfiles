#!/usr/bin/env bash

STATUS=`cat /sys/class/power_supply/BAT0/status`

if [ $STATUS = "Charging" ]; then
    echo "<fc=#f0c674><fn=1></fn></fc>"
elif [ $STATUS = "Discharging" ]; then
    echo "<fc=#e86f69><fn=1></fn></fc>"
else
    echo "<fn=1></fn>"
fi
