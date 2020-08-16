#!/bin/bash
set -e
sde=$(which sde64 || which sde)
(cd rust && env RUSTFLAGS="--emit asm -C target-feature=-fma" cargo build --release && cp target/release/test-fma test-rust)
(cd rust && env RUSTFLAGS="--emit asm -C target-feature=+fma" cargo build --release && cp target/release/test-fma test-rust-with-fma)
resultfile=result-rust.txt
echo "Rust default / Ivy Bridge" > $resultfile
($sde -ivb -- rust/test-rust || true) >> $resultfile 2>&1
echo "---" >> $resultfile
echo "Rust default / Haswell" >> $resultfile
$sde -hsw -- rust/test-rust >> $resultfile
echo "---" >> $resultfile
echo "Rust target-feature=+fma / Ivy Bridge" >> $resultfile
($sde -ivb -- rust//test-rust-with-fma || true) >> $resultfile 2>&1
echo "---" >> $resultfile
echo "Rust target-feature=+fma / Haswell" >> $resultfile
$sde -hsw -- rust//test-rust-with-fma >> $resultfile
