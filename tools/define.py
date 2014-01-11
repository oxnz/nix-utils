#! /usr/bin/python
#-*- coding: utf-8 -*-
#-*- author: Oxnz -*-
#-*- mail: yunxinyi@gmail.com -*-
#TODO: add voice choose function

import re;
import urllib;
import urllib2;
import sys;
import subprocess
import tempfile
from xml.dom import minidom

def usage(exit = True, ecode = 0):
    print """usage: dict options [word|"sentence"]
    Options:
        -h  show this message and exit
        -v  show more verbose contents which could contains example
        sentences and similar words, etc.
        word|"sentence": the word you want to translate
        If you want to translate a sentence, use double quote
    Examples:
        define hello
        lookup a summary explaination of word 'hello'
        define -v hello
        lookup a more verbose definition of word 'hello' as well as examples
        define "what if"
        lookup the explanation of phrase 'what if'"""
    if exit:
        sys.exit(ecode)

def sayit(words, English=False):
    type_ = '0'
    if English:
        type_ = '1'
    wav = urllib2.urlopen("http://dict.youdao.com/dictvoice?audio="
            + urllib.quote_plus(words) + "&type=" + type_).read()
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
            print Format.underline + urllib.unquote(node.nodeValue.encode('utf-8')).decode('utf-8') + Format.normal
        else:
            print node.nodeValue.replace('<b>', Color.red+Format.bold) \
                .replace('</b>', Format.normal)


def translate(words, verbose=False, sayit_=False):
    xml = urllib2.urlopen("http://dict.yodao.com/search?keyfrom=dict.python&q="
        + urllib.quote_plus(words) + "&xmlDetail=true&doctype=xml").read();
    dom = minidom.parseString(xml)
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
    if sayit_:
        sayit(words)

def main(argv):
    verbose = False
    sayit = False
    for arg in argv:
        if arg.startswith('-'):
            if 'h' in arg:
                usage(True, 0)
            if 'v' in arg:
                verbose = True
            if 's' in arg:
                sayit = True
            if len(arg.replace('v', '').replace('s', '')) > 1:
                print 'unrecognized option: ', arg
                sys.exit(1)
    #argv[:] = filter(lambda arg: not '-' in arg, argv)
    argv[:] = filter(lambda arg: not arg.startswith('-'), argv)
    if len(argv) <= 0:
        usage(True, 1)
    try:
        translate(" ".join(argv), verbose, sayit)
    except Exception as e:
        print e

if __name__ == "__main__":
    try:
        main(sys.argv[1:])
    except KeyboardInterrupt:
        print "CTRL-C, Canceled"
