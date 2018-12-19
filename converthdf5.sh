#!/bin/bash

cd Sam03
for f in `ls *.hdf`; do
    echo $f
    h5fromh4 -v -o ../Sam03_converted/hdf5/${f%hdf}h5 $f
done

cd ../Sam03_converted/hdf5
for f in `ls *.h5`; do
    echo $f
    h5topng -o ../png_rgb/${f%h5}png $f
done

cd ../png_rgb
for f in `ls *.png`; do
    echo $f
    convert $f -channel Red -separate ../png_intensity/$f
done
