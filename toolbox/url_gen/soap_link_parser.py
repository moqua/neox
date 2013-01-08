#!/usr/bin/python

from BeautifulSoup import BeautifulSoup as bs
import urllib2

url = 'http://www.google.com/search?hl=en&as_epq=&as_oq=&as_eq=&num=100&lr=&as_filetype=&ft=i&as_sitesearch=&as_qdr=all&as_rights=&as_occt=any&cr=&as_nlo=&as_nhi=&safe=images&as_q=madonna'

user_agent = 'Mozilla/5.0 (X11; U; Linux i686; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.205 Safari/534.16'
headers = { 'User-Agent' : user_agent }
req = urllib2.Request(url,None,headers)
page = urllib2.urlopen(req)
# page = urllib2.urlopen(url) # maybe, I'm going off memory
soup = bs(page)
for link in soup.findAll('a'):
	try:
		# urllib2.urlopen(link.get('href'))
		print link.get('href')
		# print link.get('src') # if http
	except:
		# do something, this link is invalid or no longer exists
		pass
