#!/bin/bash
set -e
export sde=$HOME/sde-external-8.56.0-2020-07-05-lin/sde64
gcc -o test-fma-linux-glibc test-fma.c -lm
gcc -o test-fma-linux-glibc-mfma -O2 -mfma test-fma.c -lm
resultfile=result-linux-glibc.txt
echo "Linux glibc default / Ivy Bridge" > $resultfile
$sde -ivb -- ./test-fma-linux-glibc >> $resultfile
echo "---" >> $resultfile
echo "Linux glibc default / Haswell" >> $resultfile
$sde -hsw -- ./test-fma-linux-glibc >> $resultfile
echo "---" >> $resultfile
echo "Linux glibc -O2 -mfma / Ivy Bridge" >> $resultfile
($sde -ivb -- ./test-fma-linux-glibc-mfma || true) >> $resultfile 2>&1
echo "---" >> $resultfile
echo "Linux glibc -O2 -mfma / Haswell" >> $resultfile
$sde -hsw -- ./test-fma-linux-glibc-mfma >> $resultfile
