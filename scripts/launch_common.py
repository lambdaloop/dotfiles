#!/usr/bin/env python3

from rofi import Rofi
import subprocess
import shlex

r = Rofi(rofi_args=['-font', 'Noto Sans 20', '-i'], lines=1)

apps = [
    ('f', 'Firefox', 'firefox'),
    ('r', 'Anki', 'anki'),
    ('m', 'Cantata', 'cantata'),
    ('n', 'Nautilus', 'nautilus'),
    ('s', 'Spotify', 'spotify --force-device-scale-factor=2'),
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

