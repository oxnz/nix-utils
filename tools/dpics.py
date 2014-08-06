#!/usr/bin/env python
#-*- coding: utf-8 -*-

import urllib
import urllib2
import re
import sys
import os
import threading

pattern = re.compile('(http.*?(\d{6})/(\d+)/(\d+)\.jpg)')

class Downloader(threading.Thread):
    def __init__(self, url, path, fname):
        super(Downloader, self).__init__()
        self.url = url
        self.path = path
        self.fpath = os.path.join(path, fname)

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

def downpics(url):
    html = urllib2.urlopen(url).read()
    taskq = []
    for (url, pdname, dname, fname) in pattern.findall(html):
        taskq.append(Downloader(url,
            os.path.join(pdname, dname), fname + '.jpg'))
    for task in taskq:
        task.start()
    for task in taskq:
        task.join()
        sys.stdout.write('-')
        sys.stdout.flush()
    sys.stdout.write('\n')

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print 'Usage: \n\t', sys.argv[0], '<url>'
        sys.exit(1)
    for url in sys.argv[1:]:
        try:
            downpics(url)
        except Exception, e:
            print e
