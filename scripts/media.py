#!/usr/bin/env python3
import sys
import os
import glob
import json
import re
from kitchen.text.converters import to_bytes, to_unicode


COMMANDS = ['next', 'prev', 'pause', 'play', 'seek-next', 'seek-prev',
            'get-time', 'get-title', 'get-paused', 'get-player', 'get-details']

if len(sys.argv) < 2:
    exit()

cmd = sys.argv[1]
if cmd not in COMMANDS:
    exit()

socks = glob.glob('/tmp/mpsyt-*.sock')

x = os.popen('ps -ef | grep mpsyt').read().strip().split('\n')

if len(socks) >= 1:
#if len(x) > 2:
    ## mpsyt playing
    sock = socks[0]
    player = 'mpsyt'
else:
    player = 'mpc'

def get_property(prop, sock):
    x = os.popen("""echo '{{ "command": ["get_property", "{}"] }}'  | socat - {}""".format(prop, sock)).read()
    x = json.loads(x)
    return x['data']

def format_time(total_seconds):
    minutes = int(total_seconds // 60)
    seconds = int(total_seconds % 60)
    return '{}:{:02d}'.format(minutes, seconds)


if cmd == 'get-player':
    print(player)
    exit()

if player == 'mpsyt':
    if cmd == 'next':
        os.popen("echo 'keypress \">\"' | socat - {}".format(sock))
    elif cmd == 'prev':
        os.popen("echo 'keypress \"<\"' | socat - {}".format(sock))
    elif cmd == 'seek-next':
        os.popen("echo 'seek +10' | socat - {}".format(sock))
    elif cmd == 'seek-prev':
        os.popen("echo 'seek -10' | socat - {}".format(sock))
    elif cmd == 'pause':
        os.popen("echo 'pause' | socat - {}".format(sock))
    elif cmd == 'get-paused':
        x = os.popen("""echo '{{ "command": ["get_property", "pause"] }}'  | socat - {}""".format(sock)).read()
        x = json.loads(x)
        print(x['data'])
    elif cmd == 'get-title' or cmd == 'get-details':

        lines = os.popen('ps -ef | grep mpv').read()
        lines = [y for y in lines.strip().split('\n') if y.split()[7] == 'mpv']
        pid = lines[0].split()[1]

        with open('/proc/{}/cmdline'.format(pid)) as f:
            cmd = f.read()

        L = cmd.split('\x00')
        d = dict(zip(L, L[1:]))
        title = d['--title']
        title = to_unicode(title)

        if len(sys.argv) >= 3:
            num = int(sys.argv[2])
            title = title[:num]

        print(title)

    elif cmd == 'get-time':
        left = get_property('time-remaining', sock)
        cur = get_property('playback-time', sock)
        total = cur + left

        out = '{}/{}'.format(format_time(cur), format_time(total))

        print(out)


elif player == 'mpc':
    if cmd == 'next':
        os.popen('mpc next')
    elif cmd == 'prev':
        os.popen('mpc prev')
    elif cmd == 'pause':
        os.popen('mpc toggle')
    elif cmd == 'seek-prev':
        os.popen('mpc seek -00:00:10')
    elif cmd == 'seek-next':
        os.popen('mpc seek +00:00:10')
    elif cmd == 'get-time':
        x = os.popen("mpc | grep -Po '\\d+:\\d+/\\d+:\\d+'").read()
        print(x)
    elif cmd == 'get-paused':
        x = os.popen('mpc status').read()
        m = re.search(r'\[(paused|playing)\]', x)
        if not m:
            print('dead')
        else:
            status = m.groups()[0]
            print(status == 'paused')
    elif cmd == 'get-title':
        title = os.popen('mpc current -f "[%title%|%file%]"').read()
        title = to_unicode(title)
        if len(sys.argv) >= 3:
            num = int(sys.argv[2])
            title = title[:num]
        print(title)
    elif cmd == 'get-details':
        title = os.popen("mpc current -f '[[%name%-]%artist%[ - %album%]]|???'").read()
        title = to_unicode(title)
        if len(sys.argv) >= 3:
            num = int(sys.argv[2])
            title = title[:num]
        print(title)
