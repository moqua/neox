#!/bin/bash
mv target/htmlunit-2.9-SNAPSHOT.jar target/htmlunit-2.9-SNAPSHOT.jar.OLD
mvn install:install-file -DgroupId=loggger -DartifactId=loggger -Dversion=0.1 -Dpackaging=jar -Dfile=../loggger/loggger.jar
mvn compile && mvn jar:jar
