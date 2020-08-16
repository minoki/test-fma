#!/bin/bash
set -e
sde=$(which sde64 || which sde)
javac TestFMA.java
resultfile=result-java.txt
echo "Java / Ivy Bridge" > $resultfile
$sde -ivb -- java TestFMA >> $resultfile
echo "---" >> $resultfile
echo "Java / Haswell" >> $resultfile
$sde -hsw -- java TestFMA >> $resultfile
