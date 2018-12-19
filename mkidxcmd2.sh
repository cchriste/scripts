# Construct the series of commands to write idx volumes
#
# Instructions: set the following parameters and run this script from the iris volume directory.
# 
# Results:      it will create a command line to create the idx volumes
#
#--------------------------------
# User, set these parameters:
#--------------------------------

#xy resolution
xres=8517
yres=9240

#padding
padl=1500
padt=650
padr=0
padb=2500

#actual indices of start and end slices (careful now!)
startidx[1]=3
startidx[2]=4
startidx[3]=4
startidx[4]=1
startidx[5]=3
endidx[1]=18
endidx[2]=16
endidx[3]=17
endidx[4]=11
endidx[5]=15

#--------------------------------

dimsxy="${xres} ${yres}"
boundsxy="0 $(($xres-1)) 0 $(($yres-1))"

#create the idx volumes
echo "mkdir idx"
for ((i=1;i<=5;i++)); do
    cmd="python /Users/cam/code/ir/trunk/bin/Scripts/createidx.py --visus /Users/cam/code/ir/trunk/bin/visus/osx/visusconvert --dims \"${dimsxy} $((${endidx[$i]}-${startidx[$i]}+1))\" --name \"idx/000${i}-ntdata.idx\" --fields \"DAPI BEN VAS OXY\" --dtype uint8"
    echo ${cmd}
done

#collect image dirs for command line
for ((c=1;c<=4;c++)); do
    for ((k=1;k<=5;k++)); do
        K=$k; while [ ${#K} -lt 4  ]; do K="0${K}"; done;
        slice[$k]=" $(($k-1)) "
        for ((x=${startidx[$k]};x<=${endidx[$k]};x++)); do
            S=$x; while [ ${#S} -lt 4  ]; do S="0${S}"; done;
            slice[$k]="${slice[$k]}${K}-${S}/C0${c}/001"
            if [[ ${x} -ne ${endidx[$k]} ]]; then slice[$k]="${slice[$k]},"; fi
        done;
    done;

    cmd="ir-stom -remap -base-mask -pad ${padl} ${padt} ${padr} ${padb} -load mytweak0002_0001_brute.stos mytweak0003_0002_brute.stos mytweak0004_0003_brute.stos mytweak0005_0004_brute.stos -slice_dirs 0001/ 0002/ 0003/ 0004/ 0005/ -image_dirs ${slice[1]} ${slice[2]} ${slice[3]} ${slice[4]} ${slice[5]} -save ./idx/0001-ntdata ./idx/0002-ntdata ./idx/0003-ntdata ./idx/0004-ntdata ./idx/0005-ntdata -extension .idx -channel $((${c}-1))"
    echo ${cmd}
done
