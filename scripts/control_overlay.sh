#!/usr/bin/env bash

pipe=/tmp/overlay_control.ws

trap "rm -f $pipe" EXIT

if [[ ! -p $pipe ]]; then
    mkfifo $pipe
fi

while true; do
    if read line <$pipe; then
        dbus-send \
            --session \
            --dest=org.Xmobar.Control \
            --type=method_call \
            --print-reply \
            '/org/Xmobar/Control' \
            org.Xmobar.Control.SendSignal \
            "string:Reveal 0";

        sleep 1;

        dbus-send \
            --session \
            --dest=org.Xmobar.Control \
            --type=method_call \
            --print-reply \
            '/org/Xmobar/Control' \
            org.Xmobar.Control.SendSignal \
            "string:Hide 0"
    fi
done



