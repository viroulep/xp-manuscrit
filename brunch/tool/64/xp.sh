#!/bin/bash


kernels="dgemm dsyrk dtrsm dpotrf"
data="local"

for kernel in $kernels; do
  for datum in $data; do
    for scenario in `ls /home/pviroule/replay_tool/scenarii/brunch/$kernel/$datum | grep "64_$datum"`; do
      /home/pviroule/replay_tool/build-openblas/src/tool /home/pviroule/replay_tool/scenarii/brunch/$kernel/$datum/$scenario >> all_data_${kernel}_64.dat
      #echo $scenario
      sleep 0.5
    done
  done
done
