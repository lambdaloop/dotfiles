#!/usr/bin/env python3

import pafy
import sys
from tqdm import tqdm, trange

fname = sys.argv[1]
fname_out = sys.argv[2]

reader = open(fname, 'r')
writer = open(fname_out, 'w')

for line in tqdm(reader.readlines()):
    if 'http' in line:
        url = line.strip()
        # print(url)
        try:
            video = pafy.new(url)
            newline = video.getbestaudio().url
            line = newline + '\n'
        except:
            pass
    writer.write(line)
    writer.flush()
writer.close()
