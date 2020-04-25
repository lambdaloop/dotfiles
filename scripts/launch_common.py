#!/usr/bin/env python3

from rofi import Rofi
import subprocess
import shlex

def get_dpi():
    x = subprocess.run(['xfconf-query', '-c', 'xsettings', '-p', '/Xft/DPI'],
                       capture_output=True)
    return float(x.stdout)

dpi = get_dpi()
fontsize = dpi * (12 / 90.0)
fontsize = int(round(fontsize))

r = Rofi(rofi_args=['-font', 'Noto Sans ' + str(fontsize), '-i', '-width', '75'], lines=1)

apps = [
    ('c', 'Calibre', 'calibre'),
    ('f', 'Firefox', 'firefox'),
    ('r', 'Anki', 'anki'),
    ('g', 'gsimplecal', 'gsimplecal'),
    ('m', 'Cantata', 'cantata'),
    ('n', 'Thunar', 'thunar'),
    ('s', 'Spotify', 'spotify'),
    ('x', 'Spotify (2x)', 'spotify --force-device-scale-factor=2'),
    ('t', 'kteatime', 'kteatime'),
    ('z', 'Zotero', 'zotero')
]

keys = dict([('key'+str(i), (x[0], x[1]))
             for i, x in enumerate(apps, start=1)])

_, index = r.select('Launch', [], **keys)

# print(index)
if index > 0:
    app = apps[index-1]
    print(app[2])
    args = shlex.split(app[2])
    p = subprocess.Popen(args)
    p.wait()

