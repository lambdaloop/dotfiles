#!/usr/bin/env bash

df $1 -h | awk -F ' ' 'FNR==2 {print $4}'
