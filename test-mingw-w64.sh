#!/bin/bash
set -e
sde=$(which sde)
gcc -o test-fma-mingw-w64.exe test-fma.c
gcc -o test-fma-mingw-w64-mfma.exe -O2 -mfma test-fma.c
gcc -o contract-mingw-w64.exe -O2 -mfma contract.c
resultfile=result-mingw-w64.txt
gcc --version > $resultfile
echo "---" >> $resultfile
echo "mingw-w64 default / Ivy Bridge" >> $resultfile
$sde -ivb -- test-fma-mingw-w64.exe >> $resultfile
echo "---" >> $resultfile
echo "mingw-w64 default / Haswell" >> $resultfile
$sde -hsw -- test-fma-mingw-w64.exe >> $resultfile
echo "---" >> $resultfile
echo "mingw-w64 -O2 -mfma / Ivy Bridge" >> $resultfile
($sde -ivb -- test-fma-mingw-w64-mfma.exe || true) >> $resultfile 2>&1
echo "---" >> $resultfile
echo "mingw-w64 -O2 -mfma / Haswell" >> $resultfile
$sde -hsw -- test-fma-mingw-w64-mfma.exe >> $resultfile
echo "---" >> $resultfile
echo "#pragma STDC FP_CONTRACT" >> $resultfile
$sde -hsw -- contract-mingw-w64.exe >> $resultfile
