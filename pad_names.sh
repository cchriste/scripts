#!/bin/bash

# pad the names of a group of files with leading zeros

for ((i=0;i<400;i++)); do
    if [[ -e ${i}-1.stos ]]; then
        j=${i}; while [ ${#j} -lt 4  ]; do j="0${j}"; done
        mv ${i}-1.stos ${j}-1.stos
    fi
done
