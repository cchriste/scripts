#!/bin/bash
#
# idxmirror.sh
#
# Create 8x size idx file consisting of input mirrored across all three axes.
#

date

convert="/Users/cam/code/ViSUS/src/nvisusio/visus+/visus+ --convert"
BASEDIR=/usr/sci/brain/processed/13-section_widefield_test
BASEDIR=${1}
DATADIR=${BASEDIR}/stoms
VBASE=${BASEDIR}/ntdata
INFILE=${VBASE}.idx
OUTFILE=${VBASE}_mtile.idx
#rm -Rf ${VBASE}_mtile $OUTFILE 

xres=${2}
yres=${3}
zres=${4}
fields="C01 1*uint8 compressed + C02 1*uint8 compressed + C03 1*uint8 compressed + C04 1*uint8 compressed"
xtra="0 0 0 0"
orig_dimsxy="0 $(($xres-1)) 0 $(($yres-1))"
orig_dimsz="0 $(($zres-1))"
orig_dims="${orig_dimsxy} ${orig_dimsz} ${xtra}"
xmirror_posxy="$xres $(($xres*2-1)) 0 $(($yres-1))"
ymirror_dimsxy="0 $(($xres*2-1)) 0 $(($yres-1))"
ymirror_posxy="0 $(($xres*2-1)) $yres $(($yres*2-1))"
zmirror_dimsyz="0 $(($yres*2-1)) 0 $(($zres-1))"
zmirror_posyz="0 $(($yres*2-1)) $zres $(($zres*2-1))"
max_dimsxy="0 $(($xres*2-1)) 0 $(($yres*2-1))"
max_dimsz="0 $(($zres*2-1))"
max_dims="${max_dimsxy} ${max_dimsz} ${xtra}"

## all my dims... 
# 0) create new 8x file
# 1) read original file with original dims, write it into new file in original position, and in xmirror position.
# 2) read new file, ymirror_dims (actually a box), write that into ymirror_pos.
# 3) read new file, zmirror_dims, write that into zmirror_pos.
# 4) verify results

## 0) Create the 8x volume.
cmd="${convert} --create ${OUTFILE} --box \"${max_dims}\" --fields \"${fields}\""
echo ${cmd}
eval ${cmd} 

# maximum number of slices in each dimension which can be read/written at once.
# note: this assumes size of each field is 1 byte.
memmax=2000000000
maxz=$(($memmax / ($xres * $yres)))
maxx=$(($memmax / ($zres * $yres*2))) # have to slice along x for flipping z
echo "maxx is ${maxx}"
echo "maxz is ${maxz}"

## 1) read original file with original dims, write it into new file in original position, and in xmirror position.
echo "###############"
echo "# MIRRORING X"
echo "###############"
for ((c=1;c<=4;c++)); do 
    cnt=0; numimports=0; startcnt=0;
    while [ $cnt -lt $zres ]; do
        numimports=$maxz
        cnt=$(($cnt + $numimports))
        if [ $cnt -gt $zres ]; then
            diff=$(($cnt - $zres))
            cnt=$(($cnt - $diff))
            numimports=$(($numimports - $diff))
        fi
        cmd="$convert --read ${INFILE} --field C0${c} --box \"${orig_dimsxy} ${startcnt} $(($startcnt + $numimports-1))\" --write ${OUTFILE} --use-write-lock --field C0${c} --box \"${orig_dimsxy} ${startcnt} $(($startcnt + $numimports-1))\""
        echo ${cmd}
        eval ${cmd}
        cmd="$convert --read ${INFILE} --field C0${c} --box \"${orig_dimsxy} ${startcnt} $(($startcnt + $numimports-1))\" --mirror 0 --write ${OUTFILE} --use-write-lock --field C0${c} --box \"${xmirror_posxy} ${startcnt} $(($startcnt + $numimports-1))\""
        echo ${cmd}
        eval ${cmd}
        startcnt=$cnt;
    done
done

# 2)
echo "###############"
echo "# MIRRORING Y"
echo "###############"
# max num slices at a time decreases since slices are bigger
maxz=$(($maxz / 2))
for ((c=1;c<=4;c++)); do 
    cnt=0; numimports=0; startcnt=0;
    while [ $cnt -lt $zres ]; do
        numimports=$maxz
        cnt=$(($cnt + $numimports))
        if [ $cnt -gt $zres ]; then
            diff=$(($cnt - $zres))
            cnt=$(($cnt - $diff))
            numimports=$(($numimports - $diff))
        fi
        cmd="$convert --read ${OUTFILE} --field C0${c} --box \"${ymirror_dimsxy} ${startcnt} $(($startcnt + $numimports-1))\" --write ${OUTFILE} --use-write-lock --field C0${c} --box \"${ymirror_dimsxy} ${startcnt} $(($startcnt + $numimports-1))\""
        echo ${cmd}
        eval ${cmd}
        cmd="$convert --read ${OUTFILE} --field C0${c} --box \"${ymirror_dimsxy} ${startcnt} $(($startcnt + $numimports-1))\" --mirror 1 --write ${OUTFILE} --use-write-lock --field C0${c} --box \"${ymirror_posxy} ${startcnt} $(($startcnt + $numimports-1))\""
        echo ${cmd}
        eval ${cmd}
        startcnt=$cnt;
    done
done

# 3)
echo "###############"
echo "# MIRRORING Z"
echo "###############"
# have to slice along x for flipping z
for ((c=1;c<=4;c++)); do 
    cnt=0; numimports=0; startcnt=0;
    while [ $cnt -lt $(($xres*2)) ]; do
        numimports=$maxx
        cnt=$(($cnt + $numimports))
        if [ $cnt -gt $(($xres*2)) ]; then
            diff=$(($cnt - $xres*2))
            cnt=$(($cnt - $diff))
            numimports=$(($numimports - $diff))
        fi
        cmd="$convert --read ${OUTFILE} --field C0${c} --box \"${startcnt} $(($startcnt + $numimports-1)) ${zmirror_dimsyz}\" --write ${OUTFILE} --use-write-lock --field C0${c} --box \"${startcnt} $(($startcnt + $numimports-1)) ${zmirror_dimsyz}\""
        echo ${cmd}
        eval ${cmd}
        cmd="$convert --read ${OUTFILE} --field C0${c} --box \"${startcnt} $(($startcnt + $numimports-1)) ${zmirror_dimsyz}\" --mirror 2 --write ${OUTFILE} --use-write-lock --field C0${c} --box \"${startcnt} $(($startcnt + $numimports-1)) ${zmirror_posyz}\""
        echo ${cmd}
        eval ${cmd}
        startcnt=$cnt;
    done
done

date

exit

## Read
echo "###############"
echo "# READING TILE"
echo "###############"
READDIR=${BASEDIR}/sc_readtest
rm -rf $READDIR
mkdir $READDIR
for ((c=1;c<=4;c++)); do 
    for ((i=0;i<$((${zres}*2-1));i++)); do 
        j=${i}; while [ ${#j} -lt 4  ]; do j="0${j}"; done;
        cmd="$convert --read ${OUTFILE} --field C0${c} --box \"${max_dimsxy} ${i} ${i}\" --export $READDIR/C0${c}-${j}.png"
        echo ${cmd}
        eval ${cmd}
     done;
done;

date