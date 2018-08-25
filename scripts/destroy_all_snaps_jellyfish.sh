#!/usr/bin/env bash

zfs list -t snapshot -o name -S creation | /usr/bin/grep "^jellyfish@autosnap" | xargs -n 1 zfs destroy -r
