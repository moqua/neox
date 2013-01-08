#!/bin/bash
mv target/htmlunit-core-js-2.8.jar htmlunit-core-js-2.8.jar.OLD
export JAVA_HOME=/usr/lib/jvm/java-6-sun/
export CLASSPATH=lib/:lib/commons-logging-1.1.1.jar:lib/loggger.jar:.
ant clean && ant compile && ant jar-all

