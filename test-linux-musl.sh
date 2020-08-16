#!/bin/bash
set -e
export sde=$HOME/sde-external-8.56.0-2020-07-05-lin/sde64
musl-gcc -o test-fma-linux-musl test-fma.c -lm
musl-gcc -o test-fma-linux-musl-mfma -O2 -mfma test-fma.c -lm
resultfile=result-linux-musl.txt
echo "Linux musl default / Ivy Bridge" > $resultfile
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
