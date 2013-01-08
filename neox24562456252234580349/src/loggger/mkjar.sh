#!/bin/bash
mv Loggger.class Loggger.class.OLD && \
javac Loggger.java && \
jar cf Loggger.jar Loggger.class && \
echo "compiled"
