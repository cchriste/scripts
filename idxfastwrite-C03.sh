#!/bin/bash

#
# idxfastwrite.sh
#
# Template to create an idx volume from a set of images.
#
# Note we are currently creating one idx per section, so this command
# must be executed once per section, with section prefix as the second
# argument.
#

date
# <ctc> be careful of memory!

convert="/Users/cam/code/nvisus/macosx/build/Release/visuscpp.app/Contents/MacOS/visuscpp --convert"
BASEDIR=$1  # example: /usr/sci/brain/processed/rb2_84
PREFIX=$2   # example: 0001-  (use blank to make one big idx)
if [[ "${3}" == "-downcast" ]]; then echo "downcasting 16 to 8 bit..."; DOCAST=1; fi
DTYPE="uint16"
if [[ "${3}" == "-uint8" ]]; then echo "original images are 8 bit..."; DTYPE="uint8"; fi
if [[ "${4}" == "-readonly" ]]; then READONLY=1; fi
DATADIR=${BASEDIR}
IDXDIR=${BASEDIR}/idx
VBASE=${IDXDIR}/${PREFIX}ntdata
VFILE=${VBASE}.idx
#rm -Rf $VBASE $VDIR 
#mkdir ${BASEDIR}/idx

WRITELOCK="--use-write-lock"

INDTYPE=${DTYPE}
if (( ${DOCAST} )); then CAST="--cast uint8"; DTYPE="uint8"; fi

fields="C03 1*${DTYPE} compressed"

# get resolution of first file (sets xres, yres)
`ls -1d ${DATADIR}/${PREFIX}*C03* | head -n 1 | xargs identify | awk '{ split($3, sz, '/x/'); print "export xres=" sz[1]; print "export yres=" sz[2]; }'`

# get number of files (sets numslices)
export numslices=`ls -1d ${DATADIR}/${PREFIX}*C03* | wc -l`

dimsxy="0 $(($xres-1)) 0 $(($yres-1))"
dimsz="0 $(($numslices-1))"
dims="${dimsxy} ${dimsz}"

if [[ ${READONLY} -ne 1 ]]; then
cmd="${convert} --create ${VFILE} --box \"${dimsxy} ${dimsz}\" --fields \"${fields}\""
echo ${cmd}
eval ${cmd} 

maximports=10

## Write
cd $DATADIR
for ((c=3;c<=3;c++)); do 
    cnt=0; numimports=0; startcnt=0;
    importlist="";
    for f in `ls -1d ${DATADIR}/${PREFIX}*C0${c}*`; do 
        importlist="${importlist} --import ${f} --inplace \"${dimsxy} ${numimports} ${numimports}\"";
        cnt=$(($cnt+1));
        numimports=$(($numimports+1));
        current_box="${dimsxy} ${startcnt} $(($startcnt+$numimports-1))"
        current_dims="$xres $yres $numimports"
        if [ $numimports -lt $maximports ]; then 
            continue;
        fi;
        cmd="$convert --read /dev/null --dtype ${INDTYPE} --ndtype 1 --dims \"${current_dims}\" $importlist ${CAST} --write $VFILE ${WRITELOCK} --field C0${c} --box \"${current_box}\"";
        echo ${cmd}
        eval ${cmd}
        numimports=0;
        startcnt=$cnt;
        importlist="";
    done; 
    # write remainder
    if [ "${importlist}" != "" ]; then
        cmd="$convert --read /dev/null --dtype ${INDTYPE} --ndtype 1 --dims \"${current_dims}\" $importlist ${CAST} --write $VFILE ${WRITELOCK} --field C0${c} --box \"${current_box}\"";
        echo ${cmd}
        eval ${cmd}
    fi;
done

fi
date

## Read
READDIR=${BASEDIR}/sc_readtest16
#rm -rf $READDIR
mkdir $READDIR
for ((c=3;c<=3;c++)); do 
    for ((i=0;i<${numslices};i++)); do 
        j=${i}; while [ ${#j} -lt 4  ]; do j="0${j}"; done;
        cmd="$convert --read $VFILE --field C0${c} --box \"${dimsxy} ${i} ${i}\" --export $READDIR/C0${c}-${j}.png"
        echo ${cmd}
        eval ${cmd}
     done;
done;

date