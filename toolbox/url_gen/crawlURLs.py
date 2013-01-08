#!/usr/bin/env python

import sys
import time
import urllib
import urllib2

urls = []
sengines = [ 


'http://www.google.com/search?hl=en&as_epq=&as_oq=&as_eq=&num=100&lr=&as_filetype=&ft=i&as_sitesearch=&as_qdr=all&as_rights=&as_occt=any&cr=&as_nlo=&as_nhi=&safe=images&as_q=' ]

'''
,'http://search.yahoo.com/search?n=100&p=',
'http://www.bing.com/search?q=',
'http://www.altavista.com/web/results?itag=ody&pg=aq&aqmode=s&aqp=&aqo=&aqn=&kgs=1&kls=0&dt=tmperiod&d2=0&dfr[d]=1&dfr[m]=1&dfr[y]=1980&dto[d]=4&dto[m]=6&dto[y]=2009&filetype=&rc=dmn&swd=&lh=&nbq=50&aqa=',
'http://search.lycos.com/?dfi=&region=&adf=on&submit.x=26&submit.y=16&submit=image&query=',
'http://www.alltheweb.com/search?advanced=1&cat=web&jsact=&_stype=norm&type=all&itag=crv&l=en&ics=utf-8&cs=iso88591&wf[n]=3&wf[0][r]=%2B&wf[0][q]=&wf[0][w]=&wf[1][r]=%2B&wf[1][q]=&wf[1][w]=&wf[2][r]=-&wf[2][q]=&wf[2][w]=&dincl=&dexcl=&geo=&doctype=&dfr[d]=1&dfr[m]=1&dfr[y]=1980&dto[d]=4&dto[m]=6&dto[y]=2009&hits=100&q='
]
'''


# wordlist sources:
# http://www.google.com/insights/search/#cmpt=q
# http://www.google.com/trends/hottrends
# http://searchenginewatch.com/2156041
# http://hotsearches.aol.com/search/hotsearch.jsp
# http://about.ask.com/en/docs/iq/iq.shtml
# http://www.dogpile.com/info.dogpl/searchspy/
# 
wordlist = [ 
 'obama' ] #,'merkel','memorial','britney','pamela','terror','love','sex','porno',
#'youtube','facebook','myspace','hotmail','yahoo','google','free','car','ipod']

def altavista(lines):
	for line in lines:
		while True:
			
			# stop if no more links
			if line.find('ngrn')<0: break


			# get link
			start = line.find('ngrn')+5
			line = line[start:]
			end = line.find('<')
			link = line[:end]

			link = link.replace('\\','')

			# filter: !=,js,css,
			if link.find('=')<0 and link[len(link)-2:]!='js' and link[len(link)-3:]!='css':
				if link not in urls:
					urls.append(link)

			# next one, please
			line = line[end:]

def yahoo_alltheweb(lines):
	for line in lines:
		while True:
			
			# stop if no more links
			if line.find('http')<0: break

			# get link
			start = line.find('**http')+2
			line = line[start:]
			end = line.find('"')
			link = line[:end]

			link = link.replace('\\','')
			link = link.replace('%3a',':')

			# filter: !http,js,css,
			if link.find('=')<0 and link[:4]=='http' and link[len(link)-2:]!='js' and link[len(link)-3:]!='css':
				if link not in urls:
					urls.append(link)

			# next one, please
			line = line[end:]

def bing_lycos_google(lines):
	for line in lines:
		while True:
			
			# stop if no more links
			if line.find('http')<0: break

			# get link
			start = line.find('http')
			line = line[start:]
			end = line.find('"')
			link = line[:end]

			link = link.replace('\\','')

			# filter: !http,js,css,
			if link.find('=')<0 and link[:4]=='http' and link[len(link)-2:]!='js' and link[len(link)-3:]!='css':
				if link not in urls:
					urls.append(link)

			# next one, please
			line = line[end:]

# Main #

for engine in sengines:

	for word in wordlist:
		
		url = engine+word
		print "checking " +url

		user_agent = 'Mozilla/5.0 (X11; U; Linux i686; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.205 Safari/534.16'
		headers = { 'User-Agent' : user_agent }
		values = {'name' : 'Harry Potter', 'location' : 'London', 'language' : '' }
		data = urllib.urlencode(values)
		req = urllib2.Request(url,None,headers)

		try:
			response = urllib2.urlopen(req)
		except urllib2.HTTPError, e:
			print "Error HTTP",e.code
			continue
		except urllib2.URLError, e:
			print "Error URL",e.reason
			continue
		except:
			print "error urllib"
			continue

		lines = response.readlines()

		if url.find('altavista')>0:
			altavista(lines)

		if url.find('bing')>0 or url.find('lycos')>0 or url.find('google')>0:
			bing_lycos_google(lines)

		if url.find('yahoo')>0 or url.find('alltheweb')>0:
			yahoo_alltheweb(lines)

		time.sleep(3)


file = open('linklist','w');
for url in urls:
	print url
	file.write(url+'\n')
file.close()
