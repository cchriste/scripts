#! /bin/sh
# idx_write_uda_field.sh: (see work.log for details)

v=$1
dtype=$2
ndtype=$3
cnt=0
for f in `ls $RAW_DIR/$v/*.raw`
do
  cmd="${VISUSCONVERT} --read ${f} --dtype ${dtype} --ndtype ${ndtype} --dims \"${idx_dims}\" --write ${IDX_DIR}/${DST_NAME}.idx --use-write-lock --field ${v} --box \"${idx_box}\" --time ${cnt}"
  echo $cmd
  eval $cmd
  cnt=$(($cnt+1)); 
done
