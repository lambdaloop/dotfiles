#!/usr/bin/bash

while [ 1 -lt 2 ]; do
    if [ -n "`exaile --get-title | grep SKY`" ]
    then
        exaile --decrease-vol=100
    else
        exaile --increase-vol=100
    fi
    sleep 1
done
