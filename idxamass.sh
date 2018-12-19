#!/bin/bash

# amass a bunch of idx volumes into one
# assumes the destination exists and is big enough
# usage: idxamass.sh filelist.txt dest.idx src_field_name dst_field_name startz
#    ex: idxamass.sh ~/bin/filelist.txt /usr/sci/brain/processed/confocal/arc.idx C02 VAS 13

if [[ "" == "${VISUSCONVERT}" ]]; then
    #TODO: add this script to ir-tools as well as build of visusconvert.
    VISUSCONVERT=/Users/cam/code/nvisus/build/visuscpp/Release/visusconvert.app/Contents/MacOS/visusconvert
fi

#current x,y,z
cz=$5
src=$3
dst=$4
numjobs=0
maxjobs=1
for f in `cat $1`
do
    if ((numjobs>=maxjobs)); then echo "waiting..."; wait; numjobs=0; fi;
    echo $f
    `idxreaddims.sh $f`
    zdst=$(($cz+$zres))
    cmd="$VISUSCONVERT --read $f --box \"0 ${xres} 0 ${yres} 0 ${zres}\" --field ${src} --write $2 --use-write-lock --field ${dst} --box \"0 ${xres} 0 ${yres} ${cz} ${zdst}\""
    { echo ${cmd}; eval ${cmd} & };
    cz=$((${zdst}+1))
    numjobs=$(($numjobs+1))
done

wait
echo "Setting volume world readable..."
chmod -R a+r ${2%.idx}
echo "Done."
