#!/bin/bash

for t in `seq 1 192`; do
  taskset -c `expr $t - 1` ./run_for_thread.sh $t &
done
