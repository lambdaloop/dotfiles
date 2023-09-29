#!/usr/bin/env ipython

import csv
import re
from glob import glob

fnames = glob('/jellyfish/notes/boox/*/*.txt')

# fname = '/jellyfish/notes/boox/Memory Craft - Lynne Kelly/Memory Craft - Lynne Kelly-annotation-2020-11-08_10_37_58.txt'
fname = '/jellyfish/notes/boox/White Magic - Elissa Washuta/White Magic - Elissa Washuta-annotation-2022-02-21_11_00_14.txt'
#
for fname in fnames:
    print(fname)

    outname = fname.replace('.txt', '.csv')

    title_pat = re.compile("<<(.*)>>")

    with open(fname, 'r') as f:
        header = f.readline()
        author = f.readline()
        rest = f.read()

    title = title_pat.search(header).groups()[0]

    notes_raw = rest.split('-------------------')

    columns = ['Highlight', 'Title', 'Author', 'Note', 'Location', 'Date']
    writer_f = open(outname, 'w')
    writer = csv.DictWriter(writer_f, fieldnames=columns)
    writer.writeheader()

    for ix, raw in enumerate(notes_raw):
        x = raw.split('\n')
        row = {
            'Title': title,
            'Author': author,
            'Highlight': '',
            'Note': '',
            'Date': '',
            'Location': ''
        }
        extra = ''
        in_text = False
        for line in x:
            line = line.strip()
            if '【Original Text】' in line:
                row['Highlight'] = line.replace('【Original Text】', '')
                in_text = True
            elif '【Annotations】' in line:
                row['Note'] = line.replace('【Annotations】', '')
                in_text = False
            elif 'Time：' in line:
                row['Date'] = line.replace('Time：', '')
            elif '【Page Number】' in line:
                row['Location'] = line.replace('【Page Number】', '')
            elif len(line) > 1:
                if in_text:
                    row['Highlight'] += ' ' + line
                else:
                    extra += ' ' + line

        if len(row['Highlight']) < 5:
            continue
        if len(extra.strip()) > 1:
            row['Highlight'] += ' - ' + extra.strip()
        writer.writerow(row)

    # writer.close()
    writer_f.close()
