#!/usr/bin/env bash

export PATH=/home/pierre/.cabal/bin:$PATH
export PATH=/home/pierre/bin:$PATH
export PATH=/home/pierre/.local/bin:$PATH
export PATH=/opt/android-sdk/platform-tools:$PATH

#Xresources
xrdb -merge ~/.Xresources

screentest=`xrandr | grep ' connected' | wc -l`

#does different stuff depending on number of screens
function two-screens
{
    if [ $screentest -eq 1 ]; then
        eval $1 #one screen
    else
        eval $2 #two screens
    fi
}


# two-screens '' 'xrandr --output DP-1 --right-of LVDS-0 --auto --primary; xrandr --output LVDS-0 --pos 0x0'
# two-screens '' 'xrandr --output DP1 --primary --auto --right-of eDP1 --scale 2x2 --panning 3840x2160+2560+0 --auto; xmonad --restart; xinput set-prop \"UC-LOGIC TWA60 Pen\" --type=float \"Coordinate Transformation   Matrix\" 0.4 0 0 0 0.625 0 0 0 1'
two-screens '' 'xrandr --output DP1 --scale 1.8x1.8 --panning 4608x2592+0+0 --primary --auto --output eDP1 --off'

## HiDPI (Retina) settings
export GDK_SCALE=0.5
export GDK_DPI_SCALE=1
export ELM_SCALE=1.5

# export QT_DEVICE_PIXEL_RATIO=2
export QT_AUTO_SCREEN_SCALE_FACTOR=2


#manage backgrounds and trayer
bash ~/scripts/twoScreenStuff.sh

#cheating GNOME =)
#export GNOME_DESKTOP_SESSION_ID=42

#notification daemon thing
dunst /home/pierre/.config/dunst/dunstrc &

xsetroot -cursor_name left_ptr

## IBus
# export GTK_IM_MODULE=ibus
# export XMODIFIERS='@im=ibus'
# export QT_IM_MODULE=ibus
# export GTK_IM_MODULE_FILE=/etc/gtk-2.0/gtk.immodules
# # export GTK_IM_MODULE_FILE=/usr/lib/gtk-3.0/3.0.0/immodules.cache
# ibus-daemon -drx &

## fcitx
# export GTK_IM_MODULE=fcitx
# export QT_IM_MODULE=fcitx
# export XMODIFIERS="@im=fcitx"
# fcitx

## uim
export GTK_IM_MODULE='uim'
export QT_IM_MODULE='uim'
# export GTK_IM_MODULE_FILE=/etc/gtk-2.0/gtk.immodules
# export GTK_IM_MODULE_FILE=/usr/lib/gtk-3.0/3.0.0/immodules.cache
export XMODIFIERS='@im=uim'
export UIM_CANDWIN_PROG="uim-candwin-horizontal-gtk"
uim-xim &
uim-toolbar-gtk3-systray &

export BROWSER=firefox;


#KEYBOARD
setxkbmap dvorak
setxkbmap -option ctrl:nocaps
xmodmap ~/.xmodmap && xkbset m
xset r rate 200 15 # set keyboard repeat and delay
# xcape -e "Control_L=Control_L|C" -t 300

## SCIM
# export XMODIFIERS=@im=SCIM
# # export GTK_IM_MODULE="scim-bridge"
# export GTK_IM_MODULE="xim"
# export QT_IM_MODULE="scim"
# scim -d


#editor
export EDITOR="emacsclient --alternate-editor='' -c"


export XDG_CONFIG_HOME=~/.config

#transparency
# disabled because of the weird transparent xfce4-terminal borders
# I can't find a fix for it, so I'll just disable compositing altogether

# compton -fC -D 3 -I 0.03 -O 0.01 &
# xcompmgr -fC -D 3 -I 0.02 -O 0.02 &
# compton -Cb &
# compton &

# sleep 10 && xscreensaver -no-splash & #screensaver

#little applets

## 37.8717° N, 122.2728° W for Berkeley
## 41.73, -71.30 for Barrington
# redshift-gtk -l 41.73:-71.30  -t 6500:4000 -m vidmode & #color adjustion
redshift-gtk -l 37.8717:-122.2728  -t 6500:3100 -m randr & #color adjustion

# sleep 15 && dropbox &

# killall gnome-keyring-daemon & #helps i think
# gnome-keyring-daemon -s -d &

start-pulseaudio-x11 &

# music daemon
mpd && mpc pause &
# mopidy &
# sleep 1 && mpc pause &

# thunar --daemon & #faster thunar start time

nm-applet &

#BLUETOOTH
#/usr/sbin/bluetoothd --udev &
#python /usr/bin/blueman-applet &
#bluetooth-applet &
# sleep 2 && /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &



emacs --daemon &

# Google music
# sleep 4 && bash ~/scripts/run_gmusicproxy.sh &

# sleep 1 && bash ~/scripts/reset_empty_pipe.sh &
# sleep 2; killall xmobar; bash ~/scripts/run_xmobar.sh &

# exec ck-launch-session dbus-launch --exit-with-session xmonad
# sleep 1 && exec xmonad
# exec dbus-launch --exit-with-session ~/builds/remacs/src/remacs
# exec dbus-launch --exit-with-session /usr/local/bin/emacs
exec dbus-launch --exit-with-session ~/.xmonad/xmonad-x86_64-linux

# exec ~/.xmonad/xmonad-x86_64-linux
# startxfce4
