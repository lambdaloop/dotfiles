#!/usr/bin/env bash


if [ "`exaile -q | grep playing`" ]; then # used to be "`exaile --current-position`"
    #out="`exaile --get-title` - `exaile --get-album`"
    title=`exaile --get-title | cut -c 1-20`
    album=`exaile --get-album | cut -c 1-20`
    artist=`exaile --get-artist | cut -c 1-20`
    rating=`exaile --get-rating`
    out="<fc=#68e9c9>$title</fc> - <fc=#1cd7de>$album</fc> - <fc=#0dc7ff>$artist</fc>"
    if [ -n "$1" ]; then
        echo "$out"
    elif [ "$out" != " - " ]; then
        #out=`echo "$out" | cut -c 1-35`
        echo "| $out <fc=#de935f>[$rating]</fc>"
    fi
else
    youtube=`python ~/scripts/firefox_tabs.py | grep YouTube`
    if [ "$youtube" ]; then
        youtube=`echo $youtube | cut -c 1-30`
        echo "<fc=#db2660>$youtube</fc>"
    fi
fi
