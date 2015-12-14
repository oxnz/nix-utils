#!/usr/bin/env python
#-*- coding: utf-8 -*-

''' A simple resource download tool'''

import urllib
import urllib2
import re
import sys
import os
import threading

class Downloader(threading.Thread):
    def __init__(self, url, path, fname):
        super(Downloader, self).__init__()
        self.url = url
        self.path = path
        self._fname = fname
        self.fpath = os.path.join(path, fname)

    @property
    def fname(self):
        return self._fname

    def run(self):
        try:
            if not os.path.exists(self.path):
                os.makedirs(self.path)
        except OSError, e:
            if e.errno == 17:
                pass
            else:
                raise e
        urllib.urlretrieve(self.url, self.fpath)

def downpics(url, pattern):
    html = urllib2.urlopen(url).read()
    fname = url[url.rindex('/')+1:]
    with open(fname, 'w') as f:
        f.write(html)
    taskq = []
    for (url, pdname, dname, fname) in pattern.findall(html):
        taskq.append(Downloader(url, os.path.join(pdname, dname), fname))
        sys.stdout.write('+ {}\n'.format(fname))
    for task in taskq:
        task.start()
    for task in taskq:
        task.join()
        sys.stdout.write('- {}\n'.format(task.fname))
        sys.stdout.flush()

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print 'Usage: {} <pattern> <url>'.format(sys.argv[0])
        sys.exit(1)
    pattern = re.compile('(http.*?(\d{6})/(\d+)/(\d+\.jpg))')
    #pattern = re.compile(sys.argv[1])
    for url in sys.argv[2:]:
        try:
            downpics(url, pattern)
        except Exception, e:
            print e
