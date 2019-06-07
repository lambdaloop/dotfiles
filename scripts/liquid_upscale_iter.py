#!/usr/bin/env python3

from subprocess import check_output
import os
import os.path
import sys

from wand.image import Image
from wand.display import display

## calls liquid-rescale iteratively, only 50 pixels at a time, for a better result

fname = sys.argv[1]
out_fname = sys.argv[2]
dims = sys.argv[3]
# fname = 'small/Pelagia_noctiluca_(Sardinia).jpg'
# fname = 'small/92547.jpg'
# out_fname = 'test.png'
# dims = '1600x400'

step = 125

width_out, height_out = dims.split('x')
height_out = int(height_out)
width_out = int(width_out)

img = Image(filename=fname)
width, height = img.size
ratio = min(width_out/width, height_out/height)
img.sample(int(width * ratio), int(height * ratio))


while img.width < width_out or img.height < height_out:
    print(img.size)
    diffw = min(width_out - img.width, step)
    diffh = min(height_out - img.height, step)
    img.liquid_rescale(img.width+diffw, img.height+diffh, delta_x=6)

img.save(filename=out_fname)
