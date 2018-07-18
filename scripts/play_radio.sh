#!/usr/bin/env bash

mpc clear
cat $@ | grep -Po 'http.*'| xargs mpc add
mpc play

