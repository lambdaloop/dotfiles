#!/usr/bin/env bash

#Xresources
xrdb -merge ~/.Xresources

#Network
#wicd-client -t &

#screentest=`xrandr | grep 'minimum 320 x 175'`
screentest=`disper -l | wc -l`

#does different stuff depending on number of screens
function two-screens
{
    if [ $screentest -eq 2 ]; then
        eval $1 #one screen
    else
        eval $2 #two screens
    fi
}

#nv-control-dpy --add-metamode "DFP-0: 1280x800 @1280x800 +0+0"
nv-control-dpy --add-metamode "DFP-0: nvidia-auto-select @1280x800 +0+0, DFP-2: nvidia-auto-select @1920x1080 +1280+0"
nv-control-dpy --add-metamode "DFP-2: nvidia-auto-select @1920x1080 +0+0"

# oneID=`nv-control-dpy --print-metamodes | grep 'nv-control.*1280x800 @'`
# oneID=`expr "$oneID" : ".*id=\([0-9]*\)"`
# twoID=`nv-control-dpy --print-metamodes | grep '+0+630'`
# twoID=`expr "$twoID" : ".*id=\([0-9]*\)"`
oneID=50
twoID=51

#two-screens 'xrandr -s 0' ''
id=`two-screens "echo $oneID" "echo $twoID"`
#two-screens '' "nvidia-settings -a 'CurrentMetaModeID=55'"
#nvidia-settings -a "CurrentMetaModeID=$id"
#nvidia-settings -a "XineramaInfoOrder=DFP-2, DFP-0"

two-screens '' 'xrandr --output DP-1 --right-of LVDS-0 --auto --primary; xrandr --output LVDS-0 --pos 0x0'

#KEYBOARD
setxkbmap -option ctrl:nocaps
xmodmap ~/.xmodmap && xkbset m

#manage backgrounds and trayer
bash ~/scripts/twoScreenStuff.sh

#cheating GNOME =)
#export GNOME_DESKTOP_SESSION_ID=42

#notification daemon thing
dunst /home/pierre/.config/dunst/dunstrc &
``
# twmnd &


## IBus
# export GTK_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
# export QT_IM_MODULE=ibus
# export GTK_IM_MODULE_FILE=/etc/gtk-2.0/gtk.immodules
# # export GTK_IM_MODULE_FILE=/usr/lib/gtk-3.0/3.0.0/immodules.cache
# ibus-daemon -drx

## fcitx
# export GTK_IM_MODULE=fcitx
# export QT_IM_MODULE=fcitx
# export XMODIFIERS="@im=fcitx"
# fcitx

export BROWSER=firefox;

setxkbmap dvorak
# setxkbmap -layout us -variant dvp
xmodmap ~/.xmodmap

## SCIM
export XMODIFIERS=@im=SCIM
# export GTK_IM_MODULE="scim-bridge"
export GTK_IM_MODULE="xim"
export QT_IM_MODULE="scim"
scim -d


#editor
export EDITOR="emacsclient --alternate-editor='emacs' -c"

#alsactl restore #sound!

#transparency
# disabled because of the weird transparent xfce4-terminal borders
# I can't find a fix for it, so I'll just disable compositing altogether

#compton -fC -D 3 -I 0.03 -O 0.01 &
#xcompmgr -fC -D 3 -I 0.02 -O 0.02 &
# compton -Cb &
# compton &

sleep 10 && xscreensaver -no-splash & #screensaver

#little applets

## 37.8717° N, 122.2728° W for Berkeley
## 41.73, -71.30 for Barrington
# redshift-gtk -l 41.73:-71.30  -t 6500:4000 -m vidmode & #color adjustion
redshift-gtk -l 37.8717:-122.2728  -t 6500:4000 -m vidmode & #color adjustion

# sleep 30 && dropbox start -i &

killall gnome-keyring-daemon & #helps i think
gnome-keyring-daemon -s -d &

#cgmailservice &

# music daemon
mpd &

env LC_CTYPE=zh_CN.UTF-8 emacs --daemon & #emacs daemon, helps emacs start faster
#thunar --daemon & #faster thunar start time

nm-applet &


# will mute exaile when SKY FM ads come up
# bash ~/scripts/exaile_radio_ads_mute.sh &

#BLUETOOTH
#/usr/sbin/bluetoothd --udev &
#python /usr/bin/blueman-applet &
#bluetooth-applet &
sleep 2 && /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

exec ck-launch-session dbus-launch --exit-with-session xmonad
