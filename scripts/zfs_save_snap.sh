#!/usr/bin/env bash

CURRENT_DATE=`/usr/bin/date +%Y-%m-%d--%H-%M-%S`
zfs snap $1@autosnap-$CURRENT_DATE

