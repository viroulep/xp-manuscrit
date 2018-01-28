#!/bin/bash

runtimes="clang gcc"
progs="kastors kastors-init-seq"
#runtimes="libkomp"
#blocksizes="576 640 704"
#blocksizes="144 160 176 192 512"
#blocksizes="200 208 216 224 232 248 264 272 288 304 64 80 320 336 352 400 88 104 112 120 136 448"
#blocksizes="200 208 216 224 232 248 264 272 288 304 320 336 352 400 88 104 112 120 136 448"

for r in $runtimes; do
  for p in $progs; do
    prog="/home/pviroul/kastors-noaff/${p}/build-${r}-openblas/plasma/"
    output="all_data_${r}_${p}.dat"
    prefix="OMP_NUM_THREADS=\"192\" OMP_PLACES=\"{0}:192\""
    ld_path=""
    if [ "$r" == "clang" ]; then
      ld_path="LD_LIBRARY_PATH=/home/pviroul/install-libomp-original/lib:$LD_LIBRARY_PATH"
    fi
    echo "$r" >> xp.log
    eval "$ld_path $prefix $prog/dpotrf_taskdep -n 32768 -b 512 -i 3 >> $output"
    if [ "$p" == "kastors-init-seq" ]; then
      output="all_data_${r}_${p}_numactl.dat"
      eval "$ld_path $prefix numactl -i all $prog/dpotrf_taskdep -n 32768 -b 512 -i 3 >> $output"
    fi
  done
done
