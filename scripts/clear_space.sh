#!/usr/bin/env bash

sudo journalctl --vacuum-size=1G
yay -Scc
