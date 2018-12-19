#!/bin/bash

#
# stack2idx.sh
#
# Convert image stack to IDX volume.
#
# IMPORTANT:
#  o all files in source path of given type will be converted
#  o images must have same xy dimensions (z dimension will be number of images)
#
# USAGE:
#   stack2idx.sh <destname.idx> <source_path> <type> <ndtype*dtype>
#   example: stack2idx.sh myvolume.idx /path/to/my/images png 1*float64
#

# Images per write (must fit in system memory)
IMAGES_PER_WRITE=260

# Use compression?
COMPRESSION="compressed"

# Use write lock
WRITELOCK="--use-write-lock"

# Cast data
CAST=""
#CAST="--cast uint8"

# Field name
FIELD=data

# Find visusconvert
CONVERT=`which visusconvert`
if [[ "$CONVERT" -eq "" ]]; then CONVERT="/Users/cam/code/nvisus/build/latest/master/Release/visusconvert.app/Contents/MacOS/visusconvert"; fi

#                         #
# Parameters              #
#                         #

if [[ $# -ne 5 ]]; then echo "Usage: stack2idx.sh <destname.idx> <source_path> <type> <ndtype> <dtype>"; exit; fi
IDXNAME=$1
SRCPATH=$2
IMGTYPE=$3
NDTYPE=$4
DTYPE=$5
date
echo "Creating ${IDXNAME} from all ${IMGTYPE} images of type ${NDTYPE}*${DTYPE} in ${SRCPATH}..."

#                         #
# Convert the image stack #
#                         #

# Filelist
FILES=(`ls ${SRCPATH}/*.${IMGTYPE}`)

# Get image dimensions from first image
`identify ${FILES[0]} | awk '{ split($3, sz, '/x/'); print "export xres=" sz[1]; print "export yres=" sz[2]; }'`
echo "There are ${#FILES[*]} images of dimensions ${xres} by ${yres}."

# Dimensions
dimsxy="0 $(($xres-1)) 0 $(($yres-1))"
dimsz="0 $((${#FILES[*]}-1))"
dims="${dimsxy} ${dimsz}"

echo "Creating idx, dims=${dims}, fields=${FIELD} ${NDTYPE}*${DTYPE} ${COMPRESSION}..."
cmd="${CONVERT} --create ${IDXNAME} --box \"${dims}\" --fields \"${FIELD} ${NDTYPE}*${DTYPE} ${COMPRESSION}\""
echo ${cmd}
eval ${cmd} 

## Write
cnt=0; numimports=0; startcnt=0;
importlist="";
for f in ${FILES[*]}; do 
    importlist="${importlist} --paste ${f} --destination-box \"${dimsxy} ${numimports} ${numimports}\"";
    cnt=$(($cnt+1));
    numimports=$(($numimports+1));
    current_box="${dimsxy} ${startcnt} $(($startcnt+$numimports-1))"
    current_dims="$xres $yres $numimports"
    if [ $numimports -lt $IMAGES_PER_WRITE ]; then 
        continue;
    fi;
    cmd="${CONVERT} --read /dev/null --dtype ${DTYPE} --ndtype ${NDTYPE} --dims \"${current_dims}\" $importlist ${CAST} --write ${IDXNAME} ${WRITELOCK} --field ${FIELD} --box \"${current_box}\"";
    echo ${cmd}
    eval ${cmd}
    numimports=0;
    startcnt=$cnt;
    importlist="";
done; 
# write remainder
if [ "${importlist}" != "" ]; then
    cmd="${CONVERT} --read /dev/null --dtype ${DTYPE} --ndtype ${NDTYPE} --dims \"${current_dims}\" $importlist ${CAST} --write ${IDXNAME} ${WRITELOCK} --field ${FIELD} --box \"${current_box}\"";
    echo ${cmd}
    eval ${cmd}
fi;

date



