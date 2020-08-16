#!/bin/bash
set -e
sde="$(which sde64 || which sde)"
(cd go && go build test-fma.go)
resultfile=result-go.txt
echo "Go / Ivy Bridge" > $resultfile
("$sde" -ivb -- go/test-fma || true) >> $resultfile 2>&1
echo "---" >> $resultfile
echo "Go / Haswell" >> $resultfile
"$sde" -hsw -- go/test-fma >> $resultfile
