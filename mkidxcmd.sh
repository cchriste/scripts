# construct the series of commands to write idx volumes

startidx[0]=4
startidx[1]=4
startidx[2]=6
startidx[3]=2
startidx[4]=5
endidx[0]=20
endidx[1]=19
endidx[2]=20
endidx[3]=18
endidx[4]=21
dimsxy="0 6229 0 9890"
dimsz[0]="0 16"
dimsz[1]="0 15"
dimsz[2]="0 14"
dimsz[3]="0 16"
dimsz[4]="0 16"

for ((c=1;c<=4;c++)); do
    for ((k=0;k<5;k++)); do
        K=$(($k+1)); while [ ${#K} -lt 4  ]; do K="0${K}"; done;
        slice[$k]=" ${k} "
        for ((x=${startidx[$k]};x<=${endidx[$k]};x++)); do
            S=$x; while [ ${#S} -lt 4  ]; do S="0${S}"; done;
            slice[$k]="${slice[$k]}${K}-${S}/C0${c}/001"
            if [[ ${x} -ne ${endidx[$k]} ]]; then slice[$k]="${slice[$k]},"; fi
        done;
    done;

    cmd="ir-stom -remap -base-mask -pad 50 50 50 50 -load 0002_0001_brute.stos 0003_0002_brute.stos 0004_0003_brute.stos 0005_0004_brute.stos -slice_dirs 0001/ 0002/ 0003/ 0004/ 0005/ -image_dirs ${slice[0]} ${slice[1]} ${slice[2]} ${slice[3]} ${slice[4]} -save ./idx/0001-ntdata ./idx/0002-ntdata ./idx/0003-ntdata ./idx/0004-ntdata ./idx/0005-ntdata -extension .idx -channel $((${c}-1))"
    echo ${cmd}
done
