#!/usr/bin/env bash

zfs list -t snapshot -o name -S creation | /usr/bin/grep "^jellyfish@autosnap" | /usr/bin/tail -n +12 | xargs -n 1 zfs destroy -r
