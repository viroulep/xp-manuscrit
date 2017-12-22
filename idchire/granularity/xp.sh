#!/bin/bash

runtimes="clang libkomp gcc ompss"
#blocksizes="64 80 96 128 144 160 176 192 208 224 240 256 384 512"
blocksizes="72 88 104 112 120 136 200 208 216 232 248 264 272 288 304 320 336 352 400 448"

for r in $runtimes; do
  prog="/home/pviroul/kastors-noaff/kastors/build-${r}-openblas/plasma/dpotrf_taskdep"
  output="all_data_${r}.dat"
  prefix="OMP_NUM_THREADS=\"64\" OMP_PLACES=\"{0}:64\""
  ld_path=""
  if [ "$r" == "libkomp" ]; then
    ld_path="LD_LIBRARY_PATH=/home/pviroul/install-libomp-affinity/lib:$LD_LIBRARY_PATH"
  elif [ "$r" == "clang" ]; then
    ld_path="LD_LIBRARY_PATH=/home/pviroul/install-libomp-original/lib:$LD_LIBRARY_PATH"
  elif [ "$r" == "ompss" ]; then
    source /home/pviroul/ompss-17.06.1/ompss.env
  fi
  echo "$r" >> xp.log
  for b in $blocksizes; do
    eval "$ld_path $prefix ldd $prog >> xp.log"
    eval "$ld_path $prefix $prog -n 8192 -b $b -i 10 >> $output"
  done
done
