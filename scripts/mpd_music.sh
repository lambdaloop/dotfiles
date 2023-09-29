#!/usr/bin/env bash

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

nchars=80
paused=`timeout 0.5 python3 ~/scripts/media.py get-paused`

if [  "$paused" = "False"  ]; then
    title=`timeout 0.5 python3 ~/scripts/media.py get-title $nchars`

    # echo "<fn=1></fn>  $title" # music icon
    echo "▶ $title" # music icon

    # icon="<fn=1></fn>" # play circle
    # icon="<fn=1></fn>" # play 

    # icon="<fn=1></fn>" # pause circle
    # icon="<fn=1> </fn>" # pause
else
    echo ""
fi

