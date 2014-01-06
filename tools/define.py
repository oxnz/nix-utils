#! /usr/bin/python
#-*- coding: utf-8 -*-
#-*- author: Oxnz -*-
#-*- mail: yunxinyi@gmail.com -*-

import re;
import urllib;
import urllib2;
import sys;
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

def translate(words, verbose=False):
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

def main(argv):
    verbose = False
    if len(argv) <= 0 or (argv[0] == '-v' and len(argv) == 1):
        usage(True, 1)
    if argv[0] == '-v':
        verbose = True
        del argv[0]
    try:
        translate(" ".join(argv), verbose)
    except Exception as e:
        print e

if __name__ == "__main__":
    main(sys.argv[1:])
