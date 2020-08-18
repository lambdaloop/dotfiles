#!/usr/bin/env bash
set -euo pipefail

RS='rsync -azh --info=progress2'

for folder in Dropbox research learning cs; do
    echo $folder
    $RS --delete callisto:$folder ~
done
