#! /usr/bin/python
import re;
import urllib;
import urllib2;
import sys;
from xml.dom import minidom

def usage(exit = True, ecode = 0):
    print """usage: dict options [word|"sentence"]
    Options:
        -h  show this message and exit
        word|"sentence": the word you want to translate
        If you want to translate a sentence, use double quote
    Examples:
        define hello
        lookup the explanation of word 'hello'
        define "what if"
        lookup the explanation of phrase 'what if'
    """
    if exit:
        sys.exit(ecode)

def nodedump(node, skipNodeNames):
    if node.nodeName in skipNodeNames:
        pass
    elif node.hasChildNodes():
        #print node.nodeName
        for n in node.childNodes:
            nodedump(n, skipNodeNames)
    elif node.nodeValue:
        print node.nodeValue

def translate(words, verbose=False):
    xml = urllib2.urlopen("http://dict.yodao.com/search?keyfrom=dict.python&q="
        + urllib.quote_plus(words) + "&xmlDetail=true&doctype=xml").read();
    dom = minidom.parseString(xml)
    skipNames = ['#text', 'yodao-link']
    if not verbose:
        skipNames += ['example-sentences', 'yodao-web-dict', 'phonetic-symbol',
                'return-phrase']
    nodedump(dom.childNodes[0], skipNames)

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
