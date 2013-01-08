#!/usr/bin/env python

import sys
import urllib2
from datetime import date


#################
#   get google trands

print '[+] checking google trends..'
trends = []
try:
	response = urllib2.urlopen("http://www.google.com/trends/hottrends")
except:
	print "[-] http://www.google.com/trends/hottrends error"
	sys.exit()

lines = response.readlines()

for line in lines:

	if line.find("trends/hottrends") != -1:

		# cut line until trends/hottrends
		line = line[line.find("trends/hottrends"):]

		# trend begins after <
		line = line[line.find(">")+1:]

		# trend begins after <
		trend = line[:line.find("<")]

		print trend
		trends.append(trend)



#################
#   case 2

#now = date.today()
#date = now.strftime("%Y/%m/%d")
#urlstring = "http://www.malwaredomainlist.com/mdl.php?search="+date

#response = urllib2.urlopen(urlstring)
#lines = response.readlines()

#for line in lines:


#################
#   cleanup

#clean=[]
#for element in array:

#	if element.count("/") <= 2:
#		continue

	# here we are clean, just add sometimes http://
#	else:
		
#		if element.startswith("http"):
#			clean.append(element)

#		elif element.startswith("ftp"):
#			clean.append(element)
		
#		else:
#			element = element.replace("////","//")
#			clean.append("http://"+element)
