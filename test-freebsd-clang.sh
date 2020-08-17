#!/bin/bash
set -e
cc=clang
$cc -o test-fma-freebsd-clang test-fma.c -lm
$cc -o test-fma-freebsd-clang-mfma -O2 -mfma test-fma.c -lm
$cc -o contract-freebsd-clang -O2 -mfma contract.c -lm
resultfile=result-freebsd-clang.txt
$cc --version > $resultfile
echo "---" >> $resultfile
echo "FreeBSD clang default" >> $resultfile
./test-fma-freebsd-clang >> $resultfile
echo "---" >> $resultfile
echo "FreeBSD clang -O2 -mfma" >> $resultfile
(./test-fma-freebsd-clang-mfma || true) >> $resultfile 2>&1
echo "---" >> $resultfile
echo "#pragma STDC FP_CONTRACT" >> $resultfile
./contract-freebsd-clang >> $resultfile
