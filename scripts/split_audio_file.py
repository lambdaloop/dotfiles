#!/usr/bin/env ipython

import subprocess
import sys
import re

fname = sys.argv[1]
vidname = sys.argv[2]
# fname = '/home/lili/tmp/chage_aska_greatest.txt'
# vidname = '/home/lili/Downloads/チャゲ & 飛鳥 メドレー ღ チャゲ & 飛鳥 人気曲 ღ Chage & Aska Greatest Hits 2019 [HEOq5b23NH4].webm'

times = []
names = []

with open(fname, 'r') as f:
    while True:
        line = f.readline()
        if line == '': break
        result = re.split('\s+', line, maxsplit=1)
        if len(result) < 2:
            continue
        times.append(result[0])
        names.append(result[1].strip())

index = 1
for start, end, name in zip(times, times[1:], names):
    print(start, end, name)
    outname = '{:03d} - {}.mp3'.format(index, name)
    subprocess.run(['ffmpeg', '-y', '-i', vidname,
                    '-v', 'warning', '-stats',
                    '-ss', start, '-to', end,
                    outname])
    index += 1

name = names[-1]
start = times[-1]
outname = '{:03d} - {}.mp3'.format(index, name)
print(start, name)
subprocess.run(['ffmpeg', '-y', '-i', vidname,
                '-v', 'warning', '-stats',
                '-ss', start, outname])
