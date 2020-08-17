#!/bin/bash
set -e
gcc=gcc10
$gcc -o test-fma-freebsd-gcc test-fma.c -lm
$gcc -o test-fma-freebsd-gcc-mfma -O2 -mfma test-fma.c -lm
$gcc -o contract-freebsd-gcc -O2 -mfma contract.c -lm
resultfile=result-freebsd-gcc.txt
$gcc --version > $resultfile
echo "---" >> $resultfile
echo "FreeBSD gcc default" >> $resultfile
./test-fma-freebsd-gcc >> $resultfile
echo "---" >> $resultfile
echo "FreeBSD gcc -O2 -mfma" >> $resultfile
(./test-fma-freebsd-gcc-mfma || true) >> $resultfile 2>&1
echo "---" >> $resultfile
echo "#pragma STDC FP_CONTRACT" >> $resultfile
./contract-freebsd-gcc >> $resultfile
