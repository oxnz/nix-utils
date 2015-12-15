#!/usr/bin/env python
#-*- coding: utf-8 -*-

''' A simple web resource download tool'''

import urllib
import urllib2
import re
import sys
import os
import threading

def getfname(url):
    index = url.rfind('/')
    if index == -1:
        raise RuntimeError('malformed url: [{}]'.format(url))
    name = index[index+1:]
    if len(name) == 0:
        return getfname(url[:-1])
    return name

class Task(threading.Thread):
    def __init__(self, url, path):
        super(Task, self).__init__()
        self.url = url
        self.path = path
        self._fname = getfname(url)
        self.fpath = os.path.join(path, self._fname)

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

def download(url, pattern):
    html = urllib2.urlopen(url).read()
    fname = getfname(url)
    with open(fname, 'w') as f:
        f.write(html)
    taskq = []
    for (url, pdname, dname) in pattern.findall(html):
        taskq.append(Task(url, os.path.join(pdname, dname)))
        sys.stdout.write('+ {}\n'.format(task.fname))
    for task in taskq:
        task.start()
    for task in taskq:
        task.join()
        sys.stdout.write('- {}\n'.format(task.fname))
        sys.stdout.flush()

if __name__ == '__main__':
    # TODO: add optparse to support option parse
    # -C specify destination folder
    # It's good to use re to setup the parent dir and dir
    # cause there's no easy way to setup them ignore the
    # original url, so it's ok to use the last two path segment
    # as pdir and dir
    if len(sys.argv) < 3:
        print 'Usage: {} <pattern> <url>'.format(sys.argv[0])
        sys.exit(1)
    pattern = re.compile('(http.*?(\d{6})/(\d+)/\d+\.jpg)')
    #pattern = re.compile(sys.argv[1])
    for url in sys.argv[2:]:
        try:
            download(url, pattern)
        except Exception, e:
            print e
