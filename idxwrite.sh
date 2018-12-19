#!/bin/sh

#
# idxwrite.sh
#
# Template to create an idx volume from a set of images.
#

date

convert="/Users/cam/code/nvisus/build/visuscpp/Release/visusconvert.app/Contents/MacOS/visusconvert"
DTYPE=uint8
NDTYPE=1
echo $#
while (( $#>0 )); do
    echo ${1}
    if [[ "${1}" == "-simulate" ]]; then echo "Simulating..."; READONLY=1; shift; continue; fi
    if [[ "${1}" == "-dtype" ]]; then shift; DTYPE=${1}; echo "DTYPE=${DTYPE}"; shift; continue; fi # example: -dtype float32
    if [[ "${1}" == "-ndtype" ]]; then shift; NDTYPE=${1}; echo "NDTYPE=${NDTYPE}"; shift; continue; fi # example: -dtype float32
    if [[ "${1}" == "-dst" ]]; then shift; IDXDIR=${1}; echo "DST=${IDXDIR}"; shift; continue; fi  # destination
    if [[ "${1}" == "-fields" ]]; then shift; FIELDS=${1}; echo "FIELDS=${FIELDS}"; shift; continue; fi  # example: "C01 1*uint8 compressed + C02 1*uint8 compressed"
    if [[ "${1}" == "-files" ]]; then shift; echo "Waiting for files..."; break; shift; continue; fi
    shift
done
if [[ "${FIELDS}" == "" ]]; then echo "setting default fields string..."; FIELDS="DATA ${NDTYPE}*${DTYPE} compressed"; fi
VBASE=${IDXDIR}/ntdata
VFILE=${VBASE}.idx
WRITELOCK="--use-write-lock"

cmd="mkdir ${IDXDIR}"
echo ${cmd}
if [[ ${READONLY} -ne 1 ]]; then eval ${cmd}; fi

# get resolution of first file (sets xres, yres) and num slices
firstfile=${1}; echo ${firstfile}
`identify ${firstfile} | awk '{ split($3, sz, '/x/'); print "export xres=" sz[1]; print "export yres=" sz[2]; }'`
numslices=$(($#-i))
dimsxy="0 $(($xres-1)) 0 $(($yres-1))"
dimsz="0 $(($numslices-1))"
dims="${dimsxy} ${dimsz}"

cmd="${convert} --create ${VFILE} --box \"${dimsxy} ${dimsz}\" --fields \"${FIELDS}\""
echo ${cmd}
if [[ ${READONLY} -ne 1 ]]; then eval ${cmd}; fi

maximports=15

## Write
cnt=0; numimports=0; startcnt=0;
importlist=""
while (( $#>0 )); do 
    importlist="${importlist} --import ${1} --inplace \"${dimsxy} ${numimports} ${numimports}\"";
    shift
    cnt=$(($cnt+1));
    numimports=$(($numimports+1));
    current_box="${dimsxy} ${startcnt} $(($startcnt+$numimports-1))"
    current_dims="$xres $yres $numimports"
    if [ $numimports -lt $maximports ]; then 
        continue;
    fi;
    cmd="$convert --read /dev/null --dtype ${DTYPE} --ndtype ${NDTYPE} --dims \"${current_dims}\" $importlist --write $VFILE ${WRITELOCK} --field DATA --box \"${current_box}\"";
    echo ${cmd}
    if [[ ${READONLY} -ne 1 ]]; then eval ${cmd}; fi
    numimports=0;
    startcnt=$cnt;
    importlist="";
done;
# write remainder
if [ "${importlist}" != "" ]; then
    cmd="$convert --read /dev/null --dtype ${DTYPE} --ndtype ${NDTYPE} --dims \"${current_dims}\" $importlist --write $VFILE ${WRITELOCK} --field DATA --box \"${current_box}\"";
    echo ${cmd} 
    if [[ ${READONLY} -ne 1 ]]; then eval ${cmd}; fi
fi

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
