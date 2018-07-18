#!/usr/bin/env bash


if [ "`pidof rhythmbox`" ]; then
    out=`rhythmbox-client --print-playing-format %st`;
    if [ -z "$out" ]; then
        out=`rhythmbox-client --print-playing-format "%ta - %tt"`;
    fi
    if [ -n "$1" ]; then
        echo $out
    elif [ "$out" != " - " ]; then
        out=`echo $out | cut -c 1-40`
        echo "| <fc=cyan>$out</fc>"
    fi
fi
