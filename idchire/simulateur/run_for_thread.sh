#!/bin/bash

#models="IdchireAffinity IdchireAffinityMinMax IdchireMin IdchireMax"
models="IdchireMin IdchireMax"
strategies="RandLoc"

nthreads=$1
for m in $models; do
  for s in $strategies; do
    prog="/home/fifi/dev/sim-numa/build/Cholesky"
    model_data="/home/pviroul/simulateur/data/model_data.idchire.dat"
    output="all_data_tmp.dat"
    cmd="$prog -w 32 -b 256 -m $m -s $s -t $nthreads -f /home/fifi/dev/sim-numa/data/model_data.idchire.dat | grep -v \"\#\" >> $output"
    eval $cmd
  done
done
