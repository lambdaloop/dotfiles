#!/usr/bin/env bash

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

nchars=40
paused=`timeout 0.5 python ~/scripts/media.py get-paused`
# player=`python2 ~/scripts/media.py get-player`

if [  "$paused" = "False"  ]; then
    # title=`python2 ~/scripts/media.py get-title | grep -Pao '[^/]+$' | sed "s/[’\\\`]/'/"  | cut -c 1-$nchars`
    title=`timeout 0.5 python ~/scripts/media.py get-title $nchars`

    echo "<fn=1></fn>  $title" # music icon

    # icon="<fn=1></fn>" # play circle
    # icon="<fn=1></fn>" # play 

    # icon="<fn=1></fn>" # pause circle
    # icon="<fn=1> </fn>" # pause
fi

