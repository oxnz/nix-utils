#!/usr/bin/env python
#-*- coding: utf-8 -*-

''' A simple web resource download tool'''

import urllib
import urllib2
import re
import sys
import os
import threading

def get_fname(url):
    index = url.rfind('/')
    if index == -1:
        raise RuntimeError('malformed url: [{}]'.format(url))
    name = url[index+1:]
    if len(name) == 0:
        return get_fname(url[:-1])
    return name

def get_title(html):
    suffix = '</title>'
    end = html.find(suffix)
    title = 'Untitled'
    if end == -1:
        return title
    begin = html.rfind('>', 0, end)
    if begin == -1:
        return title
    begin = begin + 1
    title = html[begin:end]
    title = title.decode('gbk')
    title = title.encode('utf-8')
    return title

def get_nextp(url, html):
    prefix = '/News'
    begin = html.find(prefix)
    if begin == -1:
        return None
    end = html.find('>', begin + len(prefix))
    if end == -1:
        return None
    suffix = html[begin:end]
    begin = url.find(prefix)
    if begin == -1:
        return None
    return url[:begin] + suffix

Q = False

def sig_handler(signo, frame):
    print 'signal caught: {}, quit flag was set'.format(signo)
    global Q
    Q = True

class Task(threading.Thread):
    def __init__(self, url, path):
        super(Task, self).__init__()
        self.url = url
        self.path = path
        self._fname = get_fname(url)
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
    title = get_title(html)
    print '++ {} ++'.format(title)
    fname = get_fname(url)
    with open(fname, 'w') as f:
        f.write(html)
    taskq = []
    for (link, pdname, dname) in pattern.findall(html):
        task = Task(link, os.path.join(pdname, dname))
        taskq.append(task)
        sys.stdout.write('+ {}\n'.format(task.fname))
    for task in taskq:
        task.start()
    for task in taskq:
        task.join()
        sys.stdout.write('- {}\n'.format(task.fname))
        sys.stdout.flush()
    url = get_nextp(url, html)
    global Q
    if not Q and url:
        download(url, pattern)

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
    signal(signal.SIGINT, sig_handler)
    for url in sys.argv[2:]:
        try:
            download(url, pattern)
        except Exception, e:
            print e
