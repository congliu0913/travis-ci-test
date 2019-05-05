#!/bin/bash

set -ex

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # gets the directory of this script
echo "$SCRIPT_DIR"

# setup env
source /opt/intel/computer_vision_sdk/bin/setupvars.sh
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/computer_vision_sdk/deployment_tools/inference_engine/samples/build/intel64/Release/lib
export CPU_EXTENSION_LIB=/opt/intel/computer_vision_sdk/deployment_tools/inference_engine/samples/build/intel64/Release/lib/libcpu_extension.so
export GFLAGS_LIB=/opt/intel/computer_vision_sdk/deployment_tools/inference_engine/samples/build/intel64/Release/lib/libgflags_nothreads.a

# build ros2 openvino toolkit
colcon build --symlink-install --cmake-args  -DCMAKE_BUILD_TYPE=Debug -DCOVERAGE_ENABLED=True

# test
colcon test --base-paths src/ros2_openvino_toolkit
