#!/usr/bin/env bash

status=`synclient -l | grep -c "TouchpadOff.*=.*0"`
if [ $status -eq 1 ]
then
    echo '<fc=cyan>T</fc>'
else
    echo '<fc=red>X</fc>'
fi
