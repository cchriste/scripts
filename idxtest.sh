#!/bin/bash

convert=/cam/code/ViSUS/src/nvisusio/convert/convert
DATADIR=/usr/sci/brain/processed/confocal/11x11_40X/mosaics
VBASE=/usr/sci/brain/processed/confocal/11x11_40X/sc_ntdatau
VFILE=${VBASE}.idx
rm -Rf $VBASE $VDIR 

fields="C01 1*uint8 + C02 1*uint8 + C03 1*uint8 + C04 1*uint8"

$convert --create $VFILE --box "0 5580 0 5580 0 139" --fields $fields

## Write
cd $DATADIR
for ((c=1;c<=4;c++)); do cnt=0; for f in `ls -1d *C0${c}*`; do echo "adding $f..."; $convert --import $f --write $VFILE --field C0${c} --box "0 5580 0 5580 ${cnt} ${cnt}"; cnt=$(($cnt+1)); done; done

## Read
READDIR=sc_readtest
rm -rf $READDIR
mkdir $READDIR
for ((c=1;c<=4;c++)); do cnt=0; for f in `ls -1d *C0${c}*`; do echo "reading $f..."; $convert --read $VFILE --field C0${c} --box "0 5580 0 5580 ${cnt} ${cnt}" --export $READDIR/$f; cnt=$(($cnt+1)); done; done

