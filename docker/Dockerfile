# This dockerfile expects proxies to be set via --build-arg if needed
# Example build command:
# export http_proxy=http://my.proxy.com:80
# export CMAKE_BUILD_TYPE=Debug
FROM osrf/ros2:nightly

# setup keys
ARG http_proxy
RUN if [ "$http_proxy" != "" ]; \
    then \
      apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
      --keyserver-options http-proxy=$http_proxy \
      --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116; \
    fi

#setup OPENVINO
RUN echo "===================Installing OpenVINO Toolkit...======================="
RUN wget -c -q http://registrationcenter-download.intel.com/akdlm/irc_nas/15078/l_openvino_toolkit_p_2018.5.455.tgz
#COPY l_openvino_toolkit_p_2018.5.455.tgz ./
RUN tar -xvf l_openvino_toolkit_p_2018.5.455.tgz
WORKDIR l_openvino_toolkit_p_2018.5.455
RUN pwd && ls -lha && cat install_cv_sdk_dependencies.sh
RUN apt update && apt install -y libcairo2-dev libpango1.0-dev libglib2.0-dev libgtk2.0-dev libswscale-dev libavcodec-dev libavformat-dev \
                           libgstreamer1.0-0 gstreamer1.0-plugins-base \
                           build-essential cmake libusb-1.0-0-dev libdrm-dev
RUN apt-get install -y libpng-dev cpio
RUN sed -i 's/ACCEPT_EULA=decline/ACCEPT_EULA=accept/' silent.cfg
RUN ./install.sh --silent silent.cfg
RUN echo "==== END install OpenVINO Toolkit ===="

# install opencv
#RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
RUN sh -c 'echo "deb http://security.ubuntu.com/ubuntu xenial-security main" >> /etc/apt/sources.list.d/ros2-latest.list'
RUN apt update
RUN apt-get install -y build-essential
RUN apt-get install -y cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
RUN apt-get install -y python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
WORKDIR /home/robot/code
RUN git clone https://github.com/opencv/opencv.git -b 3.4.2
RUN git clone https://github.com/opencv/opencv_contrib.git -b 3.4.2
WORKDIR /home/robot/code/opencv
RUN mkdir build
WORKDIR /home/robot/code/opencv/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -D OPENCV_EXTRA_MODULES_PATH=/home/robot/code/opencv_contrib/modules/ .. 
RUN make -j8
RUN make install

# install librealsense
RUN apt-get install -y git libssl-dev libusb-1.0-0-dev pkg-config libgtk-3-dev libglfw3-dev
WORKDIR /home/robot/code
RUN git clone https://github.com/IntelRealSense/librealsense.git -b v2.17.1
WORKDIR /home/robot/code/librealsense
RUN mkdir build &&cd build
WORKDIR /home/robot/code/librealsense/build
RUN cmake ../ -DBUILD_EXAMPLES=true
RUN make uninstall && make clean && make -j8 && make install
RUN mkdir -p /etc/udev/rules.d
RUN cd ../ && cp config/99-realsense-libusb.rules /etc/udev/rules.d/
RUN ldconfig

# install opencl
WORKDIR /tmp
RUN wget -q http://registrationcenter-download.intel.com/akdlm/irc_nas/11396/SRB5.0_linux64.zip
RUN apt-get install -y zip
RUN unzip SRB5.0_linux64.zip -d SRB5.0_linux64
WORKDIR /tmp/SRB5.0_linux64
RUN apt-get install -y xz-utils
RUN mkdir intel-opencl
RUN tar -C intel-opencl -Jxf intel-opencl-r5.0-63503.x86_64.tar.xz
RUN tar -C intel-opencl -Jxf intel-opencl-devel-r5.0-63503.x86_64.tar.xz
RUN tar -C intel-opencl -Jxf intel-opencl-cpu-r5.0-63503.x86_64.tar.xz
RUN cp -R intel-opencl/* /
RUN ldconfig

RUN apt-get install -y --no-install-recommends libboost-all-dev
RUN apt install -y libboost-python1.62.0
WORKDIR /opt/intel/computer_vision_sdk/install_dependencies
RUN ./install_NEO_OCL_driver.sh
RUN useradd --create-home --no-log-init --shell /bin/bash --password robot robot
RUN apt-get install -y sudo 
RUN mkdir -p /home/robot/code/openvino_binart_example/build
WORKDIR /home/robot/code/openvino_binart_example/build
RUN  . /opt/intel/computer_vision_sdk/bin/setupvars.sh &&cmake /opt/intel/computer_vision_sdk/deployment_tools/inference_engine/samples/ && make
WORKDIR /home/robot/code/openvino_binart_example
RUN /bin/cp -rf build /opt/intel/computer_vision_sdk/deployment_tools/inference_engine/samples/

WORKDIR /home/robot
RUN mkdir -p ros2_ws/src
WORKDIR ros2_ws/src
RUN git clone https://github.com/congliu0913/ros2_openvino_toolkit -b codecov
RUN git clone https://github.com/intel/ros2_object_msgs 
RUN git clone https://github.com/ros-perception/vision_opencv -b ros2
WORKDIR /home/robot/ros2_ws
COPY scripts/ ./scripts
RUN pwd && ls -lh
