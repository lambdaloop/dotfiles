#!/usr/bin/env bash
set -euo pipefail

RS='rsync -azhv --info=progress2'

for folder in notes research learning cs; do
    echo $folder
    $RS  /jellyfish/$folder callisto:/jellyfish
done
