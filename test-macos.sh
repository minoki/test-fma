#!/bin/bash
set -e
sde=sde64
clang -o test-fma-macos test-fma.c -lm
clang -o test-fma-macos-mfma -O2 -mfma test-fma.c -lm
clang -o contract-macos -O2 -mfma contract.c -lm
resultfile=result-macos.txt
clang --version > $resultfile
echo "---" >> $resultfile
echo "macOS default / Ivy Bridge" >> $resultfile
($sde -ivb -- ./test-fma-macos || true) >> $resultfile 2>&1
echo "---" >> $resultfile
echo "macOS default / Haswell" >> $resultfile
$sde -hsw -- ./test-fma-macos >> $resultfile
echo "---" >> $resultfile
echo "macOS -O2 -mfma / Ivy Bridge" >> $resultfile
($sde -ivb -- ./test-fma-macos-mfma || true) >> $resultfile 2>&1
echo "---" >> $resultfile
echo "macOS -O2 -mfma / Haswell" >> $resultfile
$sde -hsw -- ./test-fma-macos-mfma >> $resultfile
echo "---" >> $resultfile
echo "#pragma STDC FP_CONTRACT" >> $resultfile
$sde -hsw -- contract-mingw-w64-clang.exe >> $resultfile
