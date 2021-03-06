#monkeymri_writeidx_docast.sh

export CONVERT=/Users/cam/code/nvisus/build/visuscpp/Debug/visusconvert.app/Contents/MacOS/visusconvert

VFILE=/usr/sci/brain/processed/M09-01_MRI_images_rb/ntdata_scalars.idx

$CONVERT --create ${VFILE} --box "0 1677 0 1030 0 390" --fields "data 1*uint8"

#filenames contains spaces!
IFS=$(echo -en "\n\b")

xres=1678
yres=1031
dimsxy="0 $(($xres-1)) 0 $(($yres-1))"
numimports=0
importlist=""
for f in `ls -1`; do 
    importlist="${importlist} --import \"${f}\" --inplace \"${dimsxy} ${numimports} ${numimports}\"";
    numimports=$(($numimports+1));
done
current_box="${dimsxy} 0 $(($numimports-1))"
current_dims="$xres $yres $numimports"
cmd="$CONVERT --read /dev/null --dtype uint8 --ndtype 3 --dims \"${current_dims}\" $importlist --cast 1*uint8 --write $VFILE --field data --box \"${current_box}\"";
echo ${cmd}
eval ${cmd}
