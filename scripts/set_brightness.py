#!/usr/bin/env python3
import sys
import os
import math

COMMANDS = ['inc', 'dec', 'set', 'get']

if len(sys.argv) < 2:
    exit()

cmd = sys.argv[1]
if cmd not in COMMANDS:
    exit()

root_folder = '/sys/class/backlight/intel_backlight'
brightness_fname = os.path.join(root_folder, 'brightness')
maxb_fname = os.path.join(root_folder, 'max_brightness')

def get_current_brightness():
    with open(brightness_fname, 'r') as f:
        x = f.read().strip()
    return int(x)

def get_max_brightness():
    with open(maxb_fname, 'r') as f:
        x = f.read().strip()
    return int(x)

def set_brightness(value):
    with open(brightness_fname, 'w') as f:
        f.write(str(value))

def get_proper_step():
    cur = get_current_brightness()
    cur = 500
    maxi = get_max_brightness()
    ratio = cur / float(maxi)
    step = 1 + (math.exp(10*ratio)-1) * (0.3 / math.e)
    return int(round(step))
        
if cmd == 'set':
    value = int(sys.argv[2])
    set_brightness(value)
elif cmd == 'get':
    value = get_current_brightness()
    print(value)
elif cmd == 'inc':
    if len(sys.argv) >= 3:
        step = int(sys.argv[2])
    else:
        step = get_proper_step()
    cur = get_current_brightness()
    maxi = get_max_brightness()
    setval = cur + step
    setval = min(setval, maxi)
    set_brightness(setval)
elif cmd == 'dec':
    if len(sys.argv) >= 3:
        step = int(sys.argv[2])
    else:
        step = get_proper_step()
    cur = get_current_brightness()
    setval = cur - step
    setval = max(setval, 0)
    set_brightness(setval)
