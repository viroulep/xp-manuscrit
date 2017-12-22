#!/bin/bash

for scenario in `ls /home/pviroul/replay_tool/scenarii/idchire/bandwidth/load`; do
  /home/pviroul/replay_tool/build/src/tool /home/pviroul/replay_tool/scenarii/idchire/bandwidth/load/$scenario >> all_data_bandwidth_load.dat
  sleep 0.5
done
