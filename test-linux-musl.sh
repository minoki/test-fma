#!/bin/bash
set -e
sde=$(which sde64 || which sde)
musl-gcc -o test-fma-linux-musl test-fma.c -lm
musl-gcc -o test-fma-linux-musl-mfma -O2 -mfma test-fma.c -lm
musl-gcc -o contract-linux-musl -O2 -mfma contract.c -lm
resultfile=result-linux-musl.txt
musl-gcc --version > $resultfile
echo "---" >> $resultfile
echo "Linux musl default / Ivy Bridge" >> $resultfile
$sde -ivb -- ./test-fma-linux-musl >> $resultfile
echo "---" >> $resultfile
echo "Linux musl default / Haswell" >> $resultfile
$sde -hsw -- ./test-fma-linux-musl >> $resultfile
echo "---" >> $resultfile
echo "Linux musl -O2 -mfma / Ivy Bridge" >> $resultfile
($sde -ivb -- ./test-fma-linux-musl-mfma || true) >> $resultfile 2>&1
echo "---" >> $resultfile
echo "Linux musl -O2 -mfma / Haswell" >> $resultfile
$sde -hsw -- ./test-fma-linux-musl-mfma >> $resultfile
echo "---" >> $resultfile
echo "#pragma STDC FP_CONTRACT" >> $resultfile
$sde -hsw -- ./contract-linux-musl >> $resultfile
