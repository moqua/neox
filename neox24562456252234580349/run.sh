#!/bin/bash
CLASSPATH=htmlunit-2.8/lib/commons-logging-1.1.1.jar jruby -J-Xmx1024m -I htmlunit-2.8/lib/ neox.rb $1 1
exit 0
