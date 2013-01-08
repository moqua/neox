#!/usr/bin/python

import os,sys
import time
from threading import Thread

class worker(Thread):
	def __init__ (self,element,tid):
		Thread.__init__(self)
		self.element = element
		self.status = -1
	def run(self):
		print "[+] "+str(tid)+" "+self.element+" launched.. @ " + time.ctime()
		output = os.popen("./run.sh "+self.element+" 0  2>&1 &>/dev/null").readlines()
		logfile = open('out/log','a')
		logfile.write('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n')
		for line in output:
			logfile.write(line)
		logfile.close()

TOP = 36
RECENT=''
MAX_PARALLEL = 0 # 0-15

threadlist = []

print time.ctime()
		
urllist = open('/home/ck/urllist2').readlines()

tid = 0
for url in urllist:
	tid += 1
	current = worker(url.rstrip(),tid)
	threadlist.append(current)
	current.start()

	waitfor = 0
	if len(threadlist) > MAX_PARALLEL: waitfor = 1
	if RECENT == TOP: waitfor = len(threadlist)

	for dummy in range(waitfor):
		thread = threadlist[0]
		threadlist = threadlist[1:]
		thread.join()

print time.ctime()
