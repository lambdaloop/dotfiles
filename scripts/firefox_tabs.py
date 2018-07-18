#!/usr/bin/python

import json

dirpath = '/home/pierre/.mozilla/firefox/2d1i3ojd.default/'
filepath = dirpath + "sessionstore.js"

f = open(filepath, "r")
jdata = json.loads(f.read())
f.close()
for win in jdata.get("windows"):
    for tab in win.get("tabs"):
        i = tab.get("index") - 1
        print(tab.get("entries")[i].get("title"))
