#!/usr/bin/env bash

CURRENT_DATE=`/usr/bin/date +%Y-%m-%d--%H-%M-%S`
zfs snap jellyfish@autosnap-$CURRENT_DATE
