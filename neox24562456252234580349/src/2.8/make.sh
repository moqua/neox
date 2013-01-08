#!/bin/bash
CLASSPATH="loggger/loggger.jar"
cd loggger && ./make.sh && \
cd .. && \
cd core-js && ./make.sh && \
cd .. && \
cd htmlunit-2.8 && ./make.sh && \
echo done
