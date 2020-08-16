#!/bin/bash
set -e
export sde=$HOME/Downloads/sde-external-8.56.0-2020-07-05-mac/sde64
clang -o test-fma-macos test-fma.c -lm
clang -o test-fma-macos-mfma -O2 -mfma test-fma.c -lm
resultfile=result-macos.txt
echo "macOS default / Ivy Bridge" > $resultfile
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
