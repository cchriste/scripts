#!/bin/sh
#
#****************************************************
#** ViSUS Visualization Project                    **
#** Copyright (c) 2012 University of Utah          **
#** Scientific Computing and Imaging Institute     **
#** 72 S Central Campus Drive, Room 3750           **
#** Salt Lake City, UT 84112                       **
#**                                                **
#** For information about this project see:        **
#** http://www.pascucci.org/visus/                 **
#**                                                **
#**      or contact: pascucci@sci.utah.edu         **
#**                                                **
#****************************************************
#
# hdf2idx_par.sh
#
# Convert image stack to IDX volume (parallel version)
#
# IMPORTANT:
#  o all files in source path of given type will be converted
#  o images must have same xy dimensions (z dimension will be number of images)
#
# USAGE:
#   hdf2idx.sh <source_path> <dest_name>
#   example: hdf2idx.sh /path/to/my/images /path/to/my_idx_volume
#

# Images per write (must fit in system memory)
IMAGES_PER_WRITE=128

# Threads
NUM_THREADS=4

# Field name
FIELD=data

# Use compression?
COMPRESSION="compressed"

# Cast data
CAST=""
#CAST="--cast uint8"

# Find visusconvert
CONVERT=`which visusconvert`
if [ "${CONVERT}" = "" ]; then CONVERT="/path/to/visusconvert"; fi

#                         #
# Parameters              #
#                         #

if [[ $# -ne 2 ]]; then echo "Usage: hdf2idx.sh <source_path> <dest_name>"; exit; fi
SRCPATH=$1
IDXNAME=$2.idx
IMGTYPE="hdf"
NDTYPE=1
DTYPE="float32"
date
echo "Creating ${IDXNAME} from all ${IMGTYPE} images in ${SRCPATH}..."


#                         #
# Convert the image stack #
#                         #

# Filelist
FILES=(`ls ${SRCPATH}/*.${IMGTYPE}`)

# Get image dimensions from first image
`visusconvert --import ${FILES[0]} | awk '/ARRAY_PLUGIN.*dims/ { print $0; }' | sed 's/.*dims(\([0-9]*\) \([0-9]*\).*)$/export xres=\1 export yres=\2/'`
echo "There are ${#FILES[*]} images of dimensions ${xres} by ${yres}."

# Dimensions
dimsxy="0 $(($xres-1)) 0 $(($yres-1))"
dimsz="0 $((${#FILES[*]}-1))"
dims="${dimsxy} ${dimsz}"

echo "Creating idx, dims=${dims}, fields=${FIELD} ${NDTYPE}*${DTYPE} ${COMPRESSION}..."
cmd="${CONVERT} --create ${IDXNAME} --box \"${dims}\" --fields \"${FIELD} ${NDTYPE}*${DTYPE} ${COMPRESSION}\""
echo ${cmd}
eval ${cmd} 

# Use write lock
if [[ $NUM_THREADS -gt 1 ]]; then
    WRITELOCK="--use-write-lock"; 
else
    WRITELOCK=""; 
fi

## Write
cnt=0; numimports=0; startcnt=0;
numjobs=0; maxjobs=$NUM_THREADS;
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
    if [[ $numjobs -ge $maxjobs ]]; then echo "waiting..."; wait; numjobs=0; fi;
    cmd="${CONVERT} --read /dev/null --dtype ${DTYPE} --ndtype ${NDTYPE} --dims \"${current_dims}\" $importlist ${CAST} --write ${IDXNAME} ${WRITELOCK} --field ${FIELD} --box \"${current_box}\"";
    { echo ${cmd}; eval ${cmd} & };
    numjobs=$(($numjobs+1))
    numimports=0;
    startcnt=$cnt;
    importlist="";
done; 
# write remainder
if [ "${importlist}" != "" ]; then
    if [[ $numjobs -ge $maxjobs ]]; then echo "waiting..."; wait; numjobs=0; fi;
    cmd="${CONVERT} --read /dev/null --dtype ${DTYPE} --ndtype ${NDTYPE} --dims \"${current_dims}\" $importlist ${CAST} --write ${IDXNAME} ${WRITELOCK} --field ${FIELD} --box \"${current_box}\" &";
    { echo ${cmd}; eval ${cmd} & };
fi;

wait
date



