#!/bin/bash

ls /github/workspace

mkdir -p /root/grasp_ws/src
cd /root/grasp_ws/src
apt-get update && apt-get install -y ros-dashing-object-msgs
git clone https://github.com/intel/ros2_openvino_toolkit
git clone https://github.com/intel/ros2_grasp_library
cd /root/grasp_ws
source /opt/ros/dashing/setup.sh
colcon build --symlink-install --packages-skip vino_param_lib dynamic_vino_lib dynamic_vino_sample
