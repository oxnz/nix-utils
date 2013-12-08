#! /usr/bin/python
import re;
import urllib;
import urllib2;
import sys;

def debug():
	xml = open("word.xml").read();
	print get_text(xml);
	print get_elements_by_path(xml, "custom-translation/content");
	#print_translations(xml, False, False);
        
def get_elements_by_path(xml, elem):
	if type(xml) == type(''):
		xml = [xml]
        if type(elem) == type(''):
		elem = elem.split('/')
	if (len(xml) == 0):
		return []
	elif (len(elem) == 0):
		return xml
	elif (len(elem) == 1):
		result = []
		for item in xml:
			result += get_elements(item, elem[0])
		return result
	else:
		subitems = []
		for item in xml:
			subitems += get_elements(item, elem[0])
		return get_elements_by_path(subitems, elem[1:])

textre = re.compile("\!\[CDATA\[(.*?)\]\]", re.DOTALL)
def get_text(xml):
	match = re.search(textre, xml)
	if not match:
		return xml
	return match.group(1)

def get_elements(xml, elem):
	p = re.compile("<" + elem + ">" + "(.*?)</" + elem + ">", re.DOTALL)
	it = p.finditer(xml)
	result = []
	for m in it:
		result.append(m.group(1));
	return result;
GREEN = "\033[1;32m";
BLUE = "\033[1;34m";
DEFAULT = "\033[0;49m";
BOLD = "\033[1m";
UNDERLINE = "\033[4m";
NORMAL = "\033[m";
RED = "\033[1;31m"

def crawl_xml(queryword):
	return urllib2.urlopen("http://dict.yodao.com/search?keyfrom=dict.python&q="
        + urllib.quote_plus(queryword) + "&xmlDetail=true&doctype=xml").read();

def print_translations(xml, with_color, detailed):
        #print xml;
	original_query = get_elements(xml, "original-query");
	queryword = get_text(original_query[0]);
	custom_translations = get_elements(xml, "custom-translation");
	print BOLD + UNDERLINE + queryword + NORMAL;
	translated = False;
	
	for cus in custom_translations:
		source = get_elements_by_path(cus, "source/name");
		
		print NORMAL + "Translations from " + GREEN + source[0] + DEFAULT;
		contents = get_elements_by_path(cus, "translation/content");
		if with_color:
			for content in contents[0:5]:
				print BLUE + get_text(content) + DEFAULT;
		else:
			for content in contents[0:5]:
				print get_text(content);
		translated = True;

	yodao_translations = get_elements(xml, "yodao-web-dict");
	printed = False;
	for trans in yodao_translations:
                webtrans = get_elements(trans, "web-translation");
		for web in webtrans[0:5]:
			if not printed:
				print NORMAL + "Translations from " + GREEN + "yodao:" + DEFAULT;
				printed = True;
	        	keys = get_elements(web, "key");
			values = get_elements_by_path(web, "trans/value");
			summaries = get_elements_by_path(web, "trans/summary");
			key = keys[0].strip();
			value = values[0].strip();
			#summary = summaries[0].strip();
                        #lines = get_elements(summary, "line");
		        if with_color:
			       	print BOLD +  get_text(key) + ":\t" +DEFAULT + BLUE + get_text(value) + NORMAL;
                                #for line in lines:
                                #        print GREEN + get_text(line) + DEFAULT;
				#print get_text(summary) + DEFAULT;
		        else:
				print get_text(value);
				#print get_text(summary);
		        #translated = True;
		        #if not detailed:
			#        break
	
def usage():
	print """usage: dict options [word|"sentence"]
    Options:
        -h  show this message and exit
    Hints:
        word|"sentence": the word you want to translate
        If you want to translate a sentence, use double quote"""

def main(argv):
	if len(argv) <= 0:
		usage()
		#debug()
		sys.exit(1)
	xml = crawl_xml(" ".join(argv))
	print_translations(xml, with_color = True, detailed = True)

if __name__ == "__main__":
	main(sys.argv[1:])
