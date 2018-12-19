#!/bin/bash

# converts a series of images to idx (gets executed after converthdf5.sh

date

convert=`which visusconvert`
IDX=$1

numslices=2048
xres=2048
yres=2048
dimsxy="0 $(($xres-1)) 0 $(($yres-1))"
dimsz="0 $(($numslices-1))"

maximports=512

## Write
cnt=0; numimports=0; startcnt=0;
importlist="";
for f in `ls`; do 
    importlist="${importlist} --paste ${f} ${CAST} --destination-box \"${dimsxy} ${numimports} ${numimports}\"";
    cnt=$(($cnt+1));
    numimports=$(($numimports+1));
    current_box="${dimsxy} ${startcnt} $(($startcnt+$numimports-1))"
    current_dims="$xres $yres $numimports"
    if [ $numimports -lt $maximports ]; then 
        continue;
    fi;
    cmd="$convert --import /dev/null --dtype uint8 --ndtype 1 --dims \"${current_dims}\" $importlist --export $IDX --field data --box \"${current_box}\"";
    echo ${cmd}
    eval ${cmd}
    numimports=0;
    startcnt=$cnt;
    importlist="";
done; 

# write remainder
if [ "${importlist}" != "" ]; then
    cmd="$convert --import /dev/null --dtype uint8 --ndtype 1 --dims \"${current_dims}\" $importlist --export $IDX --field data --box \"${current_box}\"";
    echo ${cmd}
    eval ${cmd}
fi;

date

## Read
#READDIR=/tmp/sc_readtest
#rm -rf $READDIR
#mkdir $READDIR
#for ((c=1;c<=4;c++)); do 
#    for ((i=0;i<${numslices};i++)); do 
#        j=${i}; while [ ${#j} -lt 4  ]; do j="0${j}"; done;
#        cmd="$convert --read $VFILE --field C0${c} --box \"${dimsxy} ${i} ${i}\" --export $READDIR/C0${c}-${j}.png"
#        echo ${cmd}
#        eval ${cmd}
#     done;
#done;

date
