#!/usr/bin/python

urllist = open('/home/ck/urllist').readlines()
for url in urllist:
	print url.rstrip()