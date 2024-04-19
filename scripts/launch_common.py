#!/usr/bin/env python3

# from rofi import Rofi
import subprocess
import shlex
from subprocess import Popen, PIPE

def get_dpi():
    x = subprocess.run(['xfconf-query', '-c', 'xsettings', '-p', '/Xft/DPI'],
                       stdout=subprocess.PIPE)
    return float(x.stdout)

dpi = get_dpi()
fontsize = dpi * (20 / 90.0)
fontsize = int(round(fontsize))
if fontsize == 0:
    fontsize = 25

# r = Rofi(rofi_args=['-font', 'Noto Sans ' + str(fontsize), '-i', '-width', '75'], lines=1)
rofi_cmd = [ "rofi", "-dmenu",
             "-i", "-auto-select", "-p", "",
             "-font", 'DejaVu Sans Mono ' + str(fontsize),
             "-width", "200", "-height", "100" ]

apps = [
    ('a', '🖥', 'arandr'),
    ('b', '📚', 'calibre'),
    ('c', '📅', 'gnome-calendar'),
    ('f', '🦊', 'firefox'),
    ('g', '📧', 'thunderbird'),
    ('m', '🎵', 'cantata'),
    ('n', '📁', 'thunar'),
    ('r', '🎴', 'anki'),
    ('s', '📻', 'spotify'),
    ('x', '📻🔍', 'spotify --force-device-scale-factor=2'),
    ('t', '🍵', 'kteatime'),
    ('z', '📑', 'zotero')
]

apps_dict = dict()
for app in apps:
    apps_dict[app[0]] = app

lines = '\n'.join(["{0} {1}".format(*row) for row in apps])

output = Popen(rofi_cmd, stdin=PIPE, stdout=PIPE).communicate(lines.encode('utf8'))

sel = output[0]

if len(sel) >= 1:
    char = chr(sel[0])
    if char not in apps_dict: exit()
    app = apps_dict[char]
    print(app[2])
    args = shlex.split(app[2])
    p = subprocess.Popen(args)
    # p.wait()
