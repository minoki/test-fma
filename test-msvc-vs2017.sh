#!/bin/bash
set -e
ver=msvc-vs2017
vsver=VS2017
sde=$HOME/sde-external-8.56.0-2020-07-05-win/sde.exe
cl -Fe:test-fma-$ver-static.exe -Fa:test-fma-$ver-static.asm -MT test-fma.c
cl -Fe:test-fma-$ver-dynamic.exe -Fa:test-fma-$ver-dynamic.asm -MD test-fma.c
cl -Fe:test-fma-$ver-avx.exe -Fa:test-fma-$ver-avx.asm -O2 -arch:AVX test-fma.c
cl -Fe:test-fma-$ver-avx2.exe -Fa:test-fma-$ver-avx2.asm -O2 -arch:AVX2 test-fma.c
resultfile=result-$ver.txt
echo "Visual C++ ($vsver) default static / Ivy Bridge" > $resultfile
$sde -ivb -- test-fma-$ver-static.exe >> $resultfile
echo "---" >> $resultfile
echo "Visual C++ ($vsver) default static / Haswell" >> $resultfile
$sde -hsw -- test-fma-$ver-static.exe >> $resultfile
echo "---" >> $resultfile
echo "Visual C++ ($vsver) default dynamic / Ivy Bridge" >> $resultfile
$sde -ivb -- test-fma-$ver-dynamic.exe >> $resultfile
echo "---" >> $resultfile
echo "Visual C++ ($vsver) default dynamic / Haswell" >> $resultfile
$sde -hsw -- test-fma-$ver-dynamic.exe >> $resultfile
echo "---" >> $resultfile
echo "Visual C++ ($vsver) /O2 /arch:AVX / Ivy Bridge" >> $resultfile
($sde -ivb -- test-fma-$ver-avx.exe || true) >> $resultfile 2>&1
echo "---" >> $resultfile
echo "Visual C++ ($vsver) /O2 /arch:AVX / Haswell" >> $resultfile
$sde -hsw -- test-fma-$ver-avx.exe >> $resultfile 2>&1
echo "---" >> $resultfile
echo "Visual C++ ($vsver) /O2 /arch:AVX2 / Ivy Bridge" >> $resultfile
($sde -ivb -- test-fma-$ver-avx2.exe || true) >> $resultfile 2>&1
echo "---" >> $resultfile
echo "Visual C++ ($vsver) /O2 /arch:AVX2 / Haswell" >> $resultfile
$sde -hsw -- test-fma-$ver-avx2.exe >> $resultfile 2>&1
echo "---" >> $resultfile
