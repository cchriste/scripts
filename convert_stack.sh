#! /bin/bash

#############
# CONFIGURE #
# (also see input image stacks section below)
#############

CONVERT="c:/path/to/visusconvert.exe"

#############
# ARGUMENTS #
#############

if [[ $# -ne 3 ]]; then
    echo "Usage: convert_stack.sh <dirname> <num_stacks> <num_slices>"
    exit -1
fi

STACK_DIR=$1
NUM_STACKS=$2
NUM_SLICES=$3
if [ ! -d "${STACK_DIR}" ]; then
    echo "error: directory ${STACK_DIR} not found."
    exit 404
fi
echo "Converting z stacks from ${STACK_DIR} containing ${NUM_STACKS} stacks of ${NUM_SLICES} slices each..."

#/////////////////////////////////////////
# output volume
#/////////////////////////////////////////

mkdir ./dst
IDXBASE=./dst/${STACK_DIR}

#/////////////////////////////////////////
# input image stacks
#/////////////////////////////////////////

X_SCALE=0.534690555843583
Y_SCALE=0.534690555843583
Z_SCALE=2
STACKBOX_XY="0 1023 0 1023"
STACKBOX_Z=$((${NUM_SLICES}-1))
STACKBOX_XPOS=0
STACKBOX_YPOS=0
STACKBOX_ZPOS=0
STACKBOX_PATH='${STACK_DIR}/${STACK_DIR}_Cycle00${S}_CurrentSettings_Ch2_${Z}.tif'

###########
# CONVERT #
###########

#/////////////////////////////////////////
# converting source data -> idx (todo: adding an extra byte for the filter)
#/////////////////////////////////////////

FIELDS="data uint16[1]"
for ((s=0;s<${NUM_STACKS};s++)); do

    # zero pad stack index
    S=$(($s+1)); while [ ${#S} -lt 3 ]; do S="0${S}"; done;

    # create IDX
    IDXFILE="${IDXBASE}-${S}.idx"
    STACKBOX="${STACKBOX_XY} 0 ${STACKBOX_Z}"
    $CONVERT --create $IDXFILE --box "$STACKBOX" --logic_to_physic "${X_SCALE} 0 0 ${STACKBOX_XPOS} 0 ${Y_SCALE} 0 ${STACKBOX_YPOS} 0 0 ${Z_SCALE} ${STACKBOX_ZPOS} 0 0 0 1" --fields "$FIELDS"

    # import slices
    IMPORTS=""
    for ((z=0;z<${NUM_SLICES};z++)); do 

        # zero pad slice index
        Z=$(($z+1)); while [ ${#Z} -lt 6 ]; do Z="0${Z}"; done;

        SLICE_BOX="${STACKBOX_XY} $z $z"
        eval "slicepath=\"${STACKBOX_PATH}\""
        IMPORTS="${IMPORTS} --paste ${slicepath} --destination-box \"${SLICE_BOX}\""
    done
    cmd="${CONVERT} --import /dev/null --dtype 1*uint16 --dims \"1024 1024 ${NUM_SLICES}\" ${IMPORTS} --export $IDXFILE --box \"${STACKBOX}\" --field data"
    echo $cmd
    eval $cmd
done
