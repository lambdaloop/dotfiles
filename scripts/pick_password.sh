#!/usr/bin/env bash

passwords=""

cd ~/.password-store

for dir in `ls ~/.password-store`; do
    if [ -n "$passwords" ]; then
        passwords+="\n"
    fi
    passwords+=$(ls $dir/*)
done

select=$(echo -e "$passwords" | sed 's/.gpg//g' | dmenu -nb "#2d2d2d" -sb "#37526e" -i -b -fn "DejaVu Sans-12")

if [ -n "$select" ]; then
    pass -c $select
fi
