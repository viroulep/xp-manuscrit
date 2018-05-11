#!/bin/bash

for t in `seq 1 192`; do
  ./run_for_thread.sh $t
done
