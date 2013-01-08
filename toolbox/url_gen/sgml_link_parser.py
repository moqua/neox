#!/usr/bin/python

import time
import sgmllib
import urllib2

class Parser(sgmllib.SGMLParser):
	def __init__(self):
		# inherit from the SGMLParser class
		sgmllib.SGMLParser.__init__(self)

		# create a list this will store all the links found
		self.links = []

	# this function is called once an anchor tag is found
	def start_a(self, attrs):

		# loop through the attributes until the href attribute is found
		for name, value in attrs:

			if name.lower() == 'href':

				# append it to the list
				self.links.append(value)


def main():

	wordlist = [ 'obama' ,'merkel','memorial','britney','pamela','terror','love','sex','porno','gamez','crack','viagra','adult','xxx','resurrection', 'sathya sai baba', 'mahjong games', 'bruins', 'nicki minaj', 'moses', 'william and kate', 'easter sunday', 'easter egg', 'boston bruins', 'papa johns', 'royal wedding guest list', 'disneyland', 'disney world', 'prince william and kate middleton', 'st louis tornado', 'tyler perry', 'free ecards', 'saibaba', 'charlton heston','happyeaster', 'javamusikindo16', 'iamsotiredof', 'Merry+Easter', 'Vrolijk+Pasen', 'Sunrise+Service', 'Frohe+Ostern', 'Buona+Pasqua', 'Purple+Rain', 'Joyeuses+P%C3%A2ques' ]

	engines = [ 
			'http://www.google.com/search?hl=en&as_epq=&as_oq=&as_eq=&num=100&lr=&as_filetype=&ft=i&as_sitesearch=&as_qdr=all&as_rights=&as_occt=any&cr=&as_nlo=&as_nhi=&safe=images&as_q=',
			'http://search.yahoo.com/search?n=100&ei=UTF-8&va_vt=any&vo_vt=any&ve_vt=any&vp_vt=any&vd=all&vst=0&vf=all&vm=p&fl=0&fr=sfp&p=' 
			] 

	for search in wordlist:
		for engine in engines:
			search = search.replace(' ','%20')
			url = engine+search
#			print url

			user_agent = 'Mozilla/5.0 (X11; U; Linux i686; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.205 Safari/534.16'
			headers = { 'User-Agent' : user_agent }
			req = urllib2.Request(url,None,headers)
			page = urllib2.urlopen(req)
	
			parser = Parser()
			parser.feed(page.read())

			# print out links
			for link in parser.links:

					if engine.find('yahoo')>0:
						if link.find('http')==0:
							link = link[link.find('**')+2:].replace('%3a',':')
							if link.find('yahoo')<0 and link.find('search/srpcache')<0:
								print link
					
					if engine.find('google')>0:
						if link.find('google')<0:
							if link.find('http')==0:
								print link

			time.sleep(1)

if __name__ == '__main__':
	main()
