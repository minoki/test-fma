#!/bin/bash
set -e
sde=$HOME/sde-external-8.56.0-2020-07-05-win/sde.exe
javac TestFMA.java
resultfile=result-java.txt
echo "Java / Ivy Bridge" > $resultfile
$sde -ivb -- java TestFMA >> $resultfile
echo "---" >> $resultfile
echo "Java / Haswell" >> $resultfile
$sde -hsw -- java TestFMA >> $resultfile
