#!/bin/bash

# make a stos command for the rabbit assembly

#start at this slice
start=$1
if [[ "${start}" == "" ]]; then start=0; fi
total=$2
if [[ "${total}" == "" ]]; then total=400; fi

IR_STOM="/home/sci/cam/code/ir/bin/ir-tools/ir-stom"
STOS_DIR="/usr/sci/cedmav/data/marclab/FixedStos"
DIRS_DIR="/usr/sci/cedmav/data/marclab/RABBIT_DIRS"

num=0
load_stos="-load "
for stos in `ls ${STOS_DIR}/*.stos`; do
    if [[ $(($num+1)) -gt start ]]; then
        load_stos="${load_stos}${stos} "
    fi
    num=$(($num+1))
    if [[ $(($num-$start)) -ge $total ]]; then 
        break; 
    fi
done

num=0
slice_dirs="-slice_dirs "
image_dirs="-image_dirs "
idx=0
for dir in `ls ${DIRS_DIR}`; do
    if [[ "${dir}" == "0000" || "${dir}" == "0001" ]]; then
        continue; #there is no 1-0 or 2-1 transform, so skip these and use 0002 as base
    fi
    if [[ $num -ge start ]]; then
        slice_dirs="${slice_dirs}${DIRS_DIR}/${dir} "
        image_dirs="${image_dirs}${idx} ${DIRS_DIR}/${dir}/8-bit/001 "
        idx=$((${idx}+1))
    fi
    num=$(($num+1))
    if [[ $(($num-$start)) -gt $total ]]; then 
        break; 
    fi
done

stos_cmd="time $IR_STOM -preadded -save /usr/sci/cedmav/data/marclab/IDX/rabbit -extension .idx -channel 0 -time-idx -start-slice $(($start+2)) -region -4096 -4096 124711 120628 ${load_stos} ${image_dirs} ${slice_dirs}"
echo ${stos_cmd}