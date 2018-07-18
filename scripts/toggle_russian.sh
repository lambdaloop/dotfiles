#!/usr/bin/env bash

DVORAK_TEST=`setxkbmap -print | grep dvorak`
if [ -n "$DVORAK_TEST" ]
then
    #dvorak - should switch to ru
    setxkbmap ru
else
    #ru - should switch to dvorak
    setxkbmap dvorak
fi

xmodmap ~/.xmodmap
xkbset r m
