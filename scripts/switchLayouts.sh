#!/usr/bin/env bash

# DVORAK_TEST=`setxkbmap -print | grep dvorak`
DVORAK_TEST=`setxkbmap -print | grep dv`
if [ -n "$DVORAK_TEST" ]
then
    #dvorak - should switch to us
    setxkbmap us
else
    #us - should switch to dvorak
    setxkbmap dvorak
    # setxkbmap -layout us -variant dvp #programmer dvorak
fi

xmodmap ~/.xmodmap
xkbset r m
