#! /usr/bin/python
#-*- coding: utf-8 -*-
#-*- author: Oxnz -*-
#-*- mail: yunxinyi@gmail.com -*-
#TODO: add voice choose function

import re;
import os
import anydbm
import urllib;
import argparse
import urllib2;
import sys;
import subprocess
import tempfile
from xml.dom import minidom

def sayit(word, English=False):
    print >> sys.stderr, "sound current not supported"
    return
    type_ = '0'
    if English:
        type_ = '1'
    uri = 'http://dict.youdao.com/dictvoice?audio={}&type={}'.format(
            urllib.quote_plus(word), type_)
    wav = urllib2.urlopen(uri).read()
    file_ = tempfile.NamedTemporaryFile("wb", bufsize = 0, suffix=".wav", \
            delete = True)
    file_.write(wav)
    subprocess.call(['/usr/bin/afplay', file_.name])
    file_.close()

def nodedump(node, skipNodeNames, transNodeNames):
    class Enum(dict):
        def __getattr__(self, name):
            if name in self:
                return self[name]
            raise AttributeError
    Color = Enum({
        'red':  '\033[1;31m',
        'green':'\033[1;32m',
        'blue': '\033[1;34m',
    })
    Format = Enum({
        'normal':   '\033[m',
        'underline':'\033[4m',
        'bold':     '\033[1m',
        'default':  '\033[0;49m',
    })
    if node.nodeName in skipNodeNames:
        pass
    elif node.hasChildNodes():
        #print node.nodeName
        if node.nodeName in transNodeNames:
            print Color.blue + Format.bold + transNodeNames[node.nodeName] \
                    + ':' + Format.normal
            del transNodeNames[node.nodeName]
        for n in node.childNodes:
            nodedump(n, skipNodeNames, transNodeNames)
    elif node.nodeValue:
        if node.nodeValue.startswith('http') and '://' in node.nodeValue:
            print Format.underline + urllib.unquote(node.nodeValue) + Format.normal
        else:
            print node.nodeValue.replace('<b>', Color.red+Format.bold) \
                .replace('</b>', Format.normal).replace('&lt;', '<') \
                .replace('&gt;', '>')

def reqdef(words):
    '''request definition'''
    return urllib2.urlopen("http://dict.yodao.com/search?keyfrom=dict.python&q="
        + urllib.quote_plus(words) + "&xmlDetail=true&doctype=xml").read()

class dbopen(object):
    def __init__(self, dbfile, mode):
        self._dbfile = dbfile
        self._mode = mode
        self._db = None

    def __enter__(self):
        self._db = anydbm.open(self._dbfile, self._mode)
        return self._db

    def __exit__(self, type, value, tb):
        if self._db:
            self._db.close()

def lookup(wordlist, dbfile, verbose, sound):
    if dbfile:
        with dbopen(dbfile, 'c') as db:
            for word in wordlist:
                xml = db.get(word)
                if not xml:
                    xml = reqdef(word)
                    db[word] = xml
                sound and sayit(word)
                translate(xml, verbose)
    else:
        for word in wordlist:
            sound and sayit(word)
            translate(reqdef(word), verbose)

def listdict(listmode, dbfile, verbose):
    with dbopen(dbfile, 'c') as db:
        if listmode == 'name' and verbose < 2:
            def traverse(word):
                print word
        else:
            def traverse(word):
                translate(db.get(word), verbose - 2)
        for word in db:
            try:
                traverse(word)
            except Exception as e:
                print 'error: {}, word: {}'.format(e, word)

def translate(xmldoc, verbose=False):
    dom = minidom.parseString(xmldoc)
    skipNames = ['#text', 'yodao-link', 'sentence-speech']
    if not verbose:
        skipNames += ['example-sentences', 'yodao-web-dict', 'phonetic-symbol',
                'return-phrase', 'sentence', 'sentence-translatoin',
                'similar-words']
    transNames = {
            'key': '关键词',
            #'trans': '翻译',
            'summary': '概括',
            'url': '链接',
            'examples': '例子',
            'similar-words': '相似单词',
            #'translation': '翻译',
            'word-form': '形式',
            'phonetic-symbol': '音标',
            'yodao-web-dict': '有道web词典',
            'example-sentences': '例句',
            'sentence-pair': '语句对',
            'sentence': '句子',
            'sentence-speech': '句子发音',
            'sentence-translation': '句子翻译',
    }
    nodedump(dom.childNodes[0], skipNames, transNames)

def optparse():
    parser = argparse.ArgumentParser(
            formatter_class=argparse.RawDescriptionHelpFormatter,
            description="lookup word definition online")
    parser.add_argument('-v', '--verbose', help='show more verbose contents which could contains example', action='count')
    parser.add_argument('-d', '--db', metavar='db', help='use local cache file to avoid unnecessary network access')
    parser.add_argument('-l', '--list', nargs='?', dest='listmode', const='name', default='name',
            choices=['name', 'normal', 'verbose'],
            help='list all the cached statistics')
    parser.add_argument('-s', '--sound', help='pronouce the specified words or sentence', action='store_true')
    parser.add_argument(metavar='word|sentence', dest='wordlist', nargs='*', help='the word you want to translate')
    parser.epilog = '''
Examples:
    %(prog)s hello
    lookup a summary explaination of word 'hello'
    %(prog)s -v hello
    lookup a more verbose definition of word 'hello' as well as examples
    %(prog)s "what if"
    lookup the explanation of phrase 'what if'
    '''
    parser.set_defaults(db = None, listmode = None, verbose = 0)
    return parser.parse_args()

def main(args):
    if args.listmode:
        listdict(args.listmode, args.db, args.verbose)
    else:
        lookup(args.wordlist, args.db, args.verbose, args.sound)

if __name__ == "__main__":
    try:
        args = optparse()
        main(args)
    except KeyboardInterrupt:
        print "CTRL-C, Canceled"
