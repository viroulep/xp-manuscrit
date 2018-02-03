#!/bin/bash

models="IdchireAffinity IdchireAffinityMinMax IdchireMin IdchireMax"
strategies="RandLoc Affinity"

nthreads=$1
for m in $models; do
  for s in $strategies; do
    prog="/home/pviroul/simulateur/build/Cholesky"
    model_data="/home/pviroul/simulateur/data/model_data.idchire.dat"
    output="all_data_simulateur.dat"
    cmd="$prog -w 64 -b 512 -f $model_data -m $m -s $s -t $nthreads >> $output"
    eval $cmd
  done
done
