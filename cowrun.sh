#! /bin/bash

maxjobs=8
numjobs=0
count=1

src=/usr/sci/visus2/data/Climate/sean
dst=/usr/sci/visus2/data/Climate/sean_merge_trees

for f in `ls ${src}/UVEL*`
do 
    #echo $f
    #echo ${f/UVEL/VVEL}

    # pad output name
    oname=${count}; while [ ${#oname} -lt 2  ]; do oname="0${oname}"; done; 

    # restrict number of simultaneous jobs
    if (( $numjobs >= $maxjobs )); then echo "waiting for previous jobs to complete..."; wait; numjobs=0; fi

    echo "starting computation of $f...";
    {
        python /Users/cam/code/dar/topology/StreamingGrids/trunk/tools/OkuboWeissTest.py /usr/sci/visus2/data/Climate/sean/UVEL.t.t0.1_42l_oilspill12c.00020321.nc /usr/sci/visus2/data/Climate/sean/VVEL.t.t0.1_42l_oilspill12c.00020321.nc /usr/sci/visus2/data/Climate/sean/GRID.nc 42 0 > ${dst}/${oname}.mesh &
    };

    numjobs=$(($numjobs+1));
    count=$(($count+1));
done

