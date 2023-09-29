#!/usr/bin/env python2

import random
from bs4 import BeautifulSoup
import requests
import subprocess

max_page = 40

url = 'https://archive.org/details/GratefulDead?sort=-downloads&and[]=subject%3A%22Soundboard%22&page={}'

page = random.randint(1, max_page)

body = requests.get(url.format(page)).text
soup = BeautifulSoup(body, 'lxml')

items = soup.find_all(class_ = 'item-ttl')

item = random.choice(items)

href = item.find('a').attrs['href']
href = href.replace('/details/', '')

title = item.find('a').attrs['title']
# views = item.parent.findNextSibling(class_ = 'stat').find('nobr').text

playlist_file = "http://archive.org/download/{0}/{0}_vbr.m3u".format(href)

# message = '{}\nViews: {}\nPage: {}'.format(title, views, page)
message = '{}\nPage: {}'.format(title, page)
print(message)
subprocess.call(['notify-send', '-t', '3000', message])

subprocess.call(['mpc', 'clear'])
subprocess.call(['mpc', 'load', playlist_file])
subprocess.call(['mpc', 'play'])

