#!/bin/bash
set -e
sde=$(which sde64 || which sde)
gcc -o test-fma-linux-glibc test-fma.c -lm
gcc -o test-fma-linux-glibc-mfma -O2 -mfma test-fma.c -lm
gcc -o contract-linux-glibc -O2 -mfma contract.c -lm
resultfile=result-linux-glibc.txt
gcc --version > $resultfile
echo "---" >> $resultfile
echo "Linux glibc default / Ivy Bridge" >> $resultfile
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
echo "---" >> $resultfile
echo "#pragma STDC FP_CONTRACT" >> $resultfile
$sde -hsw -- ./contract-linux-glibc >> $resultfile
