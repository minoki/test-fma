#!/bin/bash
set -e
sde=$(which sde64 || which sde)
clang -o test-fma-linux-glibc-clang test-fma.c -lm
clang -o test-fma-linux-glibc-clang-mfma -O2 -mfma test-fma.c -lm
clang -o contract-linux-glibc-clang -O2 -mfma contract.c -lm
resultfile=result-linux-glibc-clang.txt
clang --version > $resultfile
echo "---" >> $resultfile
echo "Linux glibc + clang default / Ivy Bridge" >> $resultfile
$sde -ivb -- ./test-fma-linux-glibc-clang >> $resultfile
echo "---" >> $resultfile
echo "Linux glibc + clang default / Haswell" >> $resultfile
$sde -hsw -- ./test-fma-linux-glibc-clang >> $resultfile
echo "---" >> $resultfile
echo "Linux glibc + clang -O2 -mfma / Ivy Bridge" >> $resultfile
($sde -ivb -- ./test-fma-linux-glibc-clang-mfma || true) >> $resultfile 2>&1
echo "---" >> $resultfile
echo "Linux glibc + clang -O2 -mfma / Haswell" >> $resultfile
$sde -hsw -- ./test-fma-linux-glibc-clang-mfma >> $resultfile
echo "---" >> $resultfile
echo "#pragma STDC FP_CONTRACT" >> $resultfile
$sde -hsw -- ./contract-linux-glibc-clang >> $resultfile
