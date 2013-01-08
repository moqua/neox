#!/bin/bash
javac loggger/HtmlunitLoggger.java && echo 'HtmlunitLoggger.java OK'
javac loggger/HtmlunitActiveXLoggger.java && echo 'HtmlunitActiveXLoggger.java OK'
javac loggger/CoreJSLoggger.java && echo 'CoreJSLoggger.java OK'

jar cf loggger.jar loggger/*.class && echo 'loggger.jar OK'
