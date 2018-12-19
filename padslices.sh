#! /bin/bash

#
# padslices.sh
#
# pads slices dirs by creating symbolic links so that ir-stom will work.
#
# outputs a nice list which can be used to delete extraneous slices afterwards.
#

numsections=$1
numslices=$2

for ((s=1;s<=${numsections};s++))
do
    # create padded section num (first part).
    ss=${s}; while [ ${#ss} -lt 4 ]; do ss="0${ss}"; done;
    
    for ((n=1;n<=${numslices};n++))
    do
        # create padded slice num (second part).
        nn=${n}; while [ ${#nn} -lt 4  ]; do nn="0${nn}"; done;
        
        ls -d ${ss}-${nn} > /dev/null 2>&1
        if (( $? ))
        then
            echo ${ss}-${nn}
            ln -s ${ss}-0001 ${ss}-${nn}
        fi
    done
done

