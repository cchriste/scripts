#!/bin/sh

pushd $1
for f in `ls -d *.app`; do echo $f; sudo ln -s $f/Contents/MacOS/${f%.app} .; done
popd
