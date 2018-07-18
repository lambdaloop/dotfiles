#!/usr/bin/env bash

DVORAK_TEST=`setxkbmap -print | grep dvorak`
if [ -n "$DVORAK_TEST" ]
then
    #dvorak - should switch to us
    setxkbmap us
else
    #us - should switch to dvorak
    setxkbmap dvorak
fi

xmodmap ~/.xmodmap
xkbset r m
