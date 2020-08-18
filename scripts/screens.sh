#!/usr/bin/env bash

# PATH=/run/current-system/sw/bin:/home/pierre/.nix-profile/bin:$PATH
export PATH=/usr/local/bin:/usr/bin:/bin:$PATH

# MAX_WAIT=600 #seconds
#MAX_WAIT=1 #seconds
# random number between 0 and MAX_WAIT (inclusive)
# RAND=$(echo `cat /dev/urandom | od -N2 -An -i` % $MAX_WAIT | bc)

# sleep $RAND

export DISPLAY=:0
export XAUTHORITY=/home/pierre/.Xauthority
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

# x=`env DISPLAY=:0 xscreensaver-command -time 2>&1 | grep -P 'non-blanked|no saver status on root window|no screensaver is running'`
x=`xfce4-screensaver-command -q 2>&1 | grep -P 'screensaver is active'`
# x=`ps -A | grep xflock`

if [ -z "$x" ]; then
    echo got it!
    # only take screenshot if xscreensaver is not on
    folder="/jellyfish/screens/`date +%Y-%m-%d`"
    mkdir -p $folder

    cmd=`echo 'mv $f' "$folder"`

    #@ just try both, one will succeed
    env DISPLAY=:0 scrot -e "$cmd"
    # env DISPLAY=:1 scrot -e "$cmd"
    # env DISPLAY=:2 scrot -e "$cmd"
    # env DISPLAY=:3 scrot -e "$cmd"

    file=`ls -t $folder | head -1`

    cd $folder
    pngquant -f --quality 60-70 $file -o test.png

    if [ -e 'test.png' ]; then
        mv 'test.png' $file;
    fi
    
    echo 2 `date` x: "$x" >> /home/pierre/scripts/scripts.log

    # sleep 1 && env DISPLAY=:0 notify-send -t 1000 "Screenshot" "`date`"

fi
