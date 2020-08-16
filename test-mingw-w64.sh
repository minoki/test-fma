#!/bin/bash
set -e
export sde=$HOME/sde-external-8.56.0-2020-07-05-win/sde.exe
gcc -o test-fma-mingw-w64.exe test-fma.c
gcc -o test-fma-mingw-w64-mfma.exe -O2 -mfma test-fma.c
resultfile=result-mingw-w64.txt
echo "mingw-w64 default / Ivy Bridge" > result-mingw-w64.txt
$sde -ivb -- test-fma-mingw-w64.exe >> result-mingw-w64.txt
echo "---" >> result-mingw-w64.txt
echo "mingw-w64 default / Haswell" >> result-mingw-w64.txt
$sde -hsw -- test-fma-mingw-w64.exe >> result-mingw-w64.txt
echo "---" >> result-mingw-w64.txt
echo "mingw-w64 -O2 -mfma / Ivy Bridge" >> result-mingw-w64.txt
($sde -ivb -- test-fma-mingw-w64-mfma.exe || true) >> result-mingw-w64.txt 2>&1
echo "---" >> result-mingw-w64.txt
echo "mingw-w64 -O2 -mfma / Haswell" >> result-mingw-w64.txt
$sde -hsw -- test-fma-mingw-w64-mfma.exe >> result-mingw-w64.txt
