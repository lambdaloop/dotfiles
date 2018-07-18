#!/usr/bin/env python3

import os, os.path
import sys
from glob import glob
import random
import shutil

source = sys.argv[1]
dest = sys.argv[2]

os.makedirs(dest, exist_ok=True)

for folder in sorted(os.listdir(source)):
    fnames = sorted(glob(os.path.join(source, folder, '*.png')))
    if len(fnames) == 0:
        continue
    ix = random.randrange(len(fnames))
    fname = fnames[ix]
    basename = os.path.basename(fname)
    print(fname)
    shutil.copy(fname, os.path.join(dest, basename))
