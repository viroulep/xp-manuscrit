#!/bin/bash

for scenario in `ls /home/pviroul/replay_tool/scenarii/idchire/bandwidth/output_link`; do
  /home/pviroul/replay_tool/build/src/tool /home/pviroul/replay_tool/scenarii/idchire/bandwidth/output_link/$scenario >> all_data_bandwidth_output_link.dat
  sleep 0.5
done
