#!/usr/bin/env bash

state=`timeout 0.5 mpc status | grep playing`;

if [ -n "$state" ]; then
    SHUFFLE_ICON="<fn=1></fn>"
    REPEAT_ICON="<fn=1></fn>"
    
    random=`mpc | grep -Eo "random: (off|on)"`
    if [ "$random" = "random: on" ]; then
        rand="$SHUFFLE_ICON"
    else
        rand="<fc=#4d4d4d>$SHUFFLE_ICON</fc>"
    fi

    repeat=`mpc | grep -Eo "repeat: (off|on)"`
    if [ "$repeat" = "repeat: on" ]; then
        rep="$REPEAT_ICON"
    else
        rep="<fc=#4d4d4d>$REPEAT_ICON</fc>"
    fi

    echo "$rand $rep"
    
else
    echo ""
fi


