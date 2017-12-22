#!/bin/bash

for scenario in `ls /home/pviroul/replay_tool/scenarii/idchire/bandwidth`; do
  /home/pviroul/replay_tool/build/src/tool /home/pviroul/replay_tool/scenarii/idchire/bandwidth/$scenario >> all_data_bandwidth_assign_opt.dat
  sleep 0.5
done
