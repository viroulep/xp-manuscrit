#!/bin/bash

for scenario in `ls /home/pviroule/replay_tool/scenarii/brunch/bandwidth/load`; do
    /home/pviroule/replay_tool/build-openblas/src/tool /home/pviroule/replay_tool/scenarii/brunch/bandwidth/load/$scenario >> all_data_bandwidth_load.dat
    sleep 0.5
done
