########################################################
# Dockerfile to setup base container image for coverity and protex scan
# Based on Ubuntu 16.04
########################################################

# Set the base image to Ubuntu 16.04
FROM ubuntu:xenial

# File Author
MAINTAINER Liu Cong "congx.liu@intel.com"


################## BEGIN INSTALLATION ##################
# Copy blackduck client to container
# Set proxy

# Install third party tools and dependence
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y sudo \
	vim \
	wget \
	git \
	python \
	python3 \
	python-pip \
	python3-pip 
WORKDIR /tmp/
################### END INSTALLATION ###################
#Create user 'robot' for login IP scan server https://scipscn03.intel.com
RUN useradd --create-home --no-log-init --shell /bin/bash robot
RUN adduser robot sudoRUN echo 'robot:123456' | chpasswd
RUN mkdir /etc/udev/rules.d/
RUN apt-get install -y cpio
RUN apt-get install -y python-skimage
RUN apt-get install -y python-protobuf
