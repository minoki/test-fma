#!/bin/bash
set -e
sde=$(which sde)
clang -o test-fma-mingw-w64-clang.exe test-fma.c
clang -o test-fma-mingw-w64-clang-mfma.exe -O2 -mfma test-fma.c
clang -o contract-mingw-w64-clang.exe -O2 -mfma contract.c
resultfile=result-mingw-w64-clang.txt
clang --version > $resultfile
echo "---" >> $resultfile
echo "mingw-w64 default / Ivy Bridge" >> $resultfile
$sde -ivb -- test-fma-mingw-w64-clang.exe >> $resultfile
echo "---" >> $resultfile
echo "mingw-w64 default / Haswell" >> $resultfile
$sde -hsw -- test-fma-mingw-w64-clang.exe >> $resultfile
echo "---" >> $resultfile
echo "mingw-w64 -O2 -mfma / Ivy Bridge" >> $resultfile
($sde -ivb -- test-fma-mingw-w64-clang-mfma.exe || true) >> $resultfile 2>&1
echo "---" >> $resultfile
echo "mingw-w64 -O2 -mfma / Haswell" >> $resultfile
$sde -hsw -- test-fma-mingw-w64-clang-mfma.exe >> $resultfile
echo "---" >> $resultfile
echo "#pragma STDC FP_CONTRACT" >> $resultfile
$sde -hsw -- contract-mingw-w64-clang.exe >> $resultfile
