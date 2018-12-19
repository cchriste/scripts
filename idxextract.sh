#!/bin/bash

# extract a (xy) region from an idx volume
# assumes the destination exists and is big enough
# usage: idxextract.sh src.idx dest.idx src_field_name dst_field_name "startx endx starty endy"
#    ex: idxamass.sh ./src.idx /usr/sci/brain/processed/confocal/arc.idx C02 VAS "0 3247 0 1237"

if [[ "" == "${VISUSCONVERT}" ]]; then
    #TODO: add this script to ir-tools as well as build of visusconvert.
    VISUSCONVERT=/Users/cam/code/nvisus/build/visuscpp/Release/visusconvert.app/Contents/MacOS/visusconvert
fi

boxxy=$5
src=$3
dst=$4
f=$1
echo $f
`idxreaddims.sh ${src}`
ez=${zres}
`idxreaddims.sh ${dst}`
cmd="$VISUSCONVERT --read $f --box \"${boxxy} 0 ${ez}\" --field ${src} --write $2 --use-write-lock --field ${dst} --box \"0 ${xres} 0 ${yres} 0 ${zres}\""
{ echo ${cmd}; eval ${cmd} & };

wait
echo "Setting volume world readable..."
chmod -R a+r ${2%.idx}
echo "Done."
