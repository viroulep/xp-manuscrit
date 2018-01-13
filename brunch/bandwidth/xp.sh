#!/bin/bash

for scenario in `ls /home/pviroule/replay_tool/scenarii/brunch/bandwidth`; do
    /home/pviroule/replay_tool/build-openblas/src/tool /home/pviroule/replay_tool/scenarii/brunch/bandwidth/$scenario >> all_data_bandwidth_brunch.dat
    sleep 0.5
done
