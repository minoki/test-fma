#!/bin/bash
set -e
sde=$HOME/sde-external-8.56.0-2020-07-05-win/sde.exe
(cd dotnet && dotnet build --output build-output)
resultfile=result-dotnet.txt
echo ".NET Core / Ivy Bridge" > $resultfile
$sde -ivb -- dotnet/build-output/test-fma.exe >> $resultfile
echo "---" >> $resultfile
echo ".NET Core / Haswell" >> $resultfile
$sde -hsw -- dotnet/build-output/test-fma.exe >> $resultfile
