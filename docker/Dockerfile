ARG BASE_IMG

FROM ${BASE_IMG}
SHELL ["/bin/bash", "-c"]

# Timezone Configuration
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y git \
                                cmake \
                                clang \
                                python3 \
                                python3-dev \
                                python3-pip \
                                python3-distutils \
                                libpython3-dev \
                                libeigen3-dev 

RUN apt install -y vim nano

# Python package install
RUN pip3 install --upgrade pip
RUN pip3 install numpy scipy matplotlib

RUN apt update && apt install -y curl gnupg lsb-release wget
RUN apt update
RUN apt upgrade -y
RUN apt install -y software-properties-common

RUN apt install -y minizip ffmpeg

# ROS1 Install
ENV ROS1_DISTRO=noetic
RUN echo "deb http://packages.ros.org/ros/ubuntu focal main" | tee /etc/apt/sources.list.d/ros-focal.list
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | apt-key add -
RUN apt update
RUN apt install -y ros-$ROS1_DISTRO-ros-base
RUN echo "source /opt/ros/$ROS1_DISTRO/setup.bash">> ~/.bashrc
RUN apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
RUN apt install -y python3-rosdep
RUN rosdep init && rosdep update

# Install ROS1 Dependency
RUN sh \
    -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" \
        > /etc/apt/sources.list.d/ros-latest.list'
RUN wget http://packages.ros.org/ros.key -O - | apt-key add -
RUN apt update
RUN apt install -y python3-catkin-tools
RUN apt install -y ros-$ROS1_DISTRO-tf
RUN apt install -y ros-$ROS1_DISTRO-pcl-conversions ros-$ROS1_DISTRO-pcl-ros ros-$ROS1_DISTRO-grid-map
RUN apt install -y ros-$ROS1_DISTRO-cv-bridge ros-$ROS1_DISTRO-costmap-2d 
RUN apt install -y ros-$ROS1_DISTRO-filters ros-$ROS1_DISTRO-octomap ros-$ROS1_DISTRO-octomap-msgs
RUN apt install -y ros-$ROS1_DISTRO-rviz ros-$ROS1_DISTRO-xacro
RUN apt install -y ros-$ROS1_DISTRO-joy ros-$ROS1_DISTRO-robot-state-publisher
RUN apt install -y ros-$ROS1_DISTRO-rqt ros-$ROS1_DISTRO-rqt-reconfigure
RUN apt install -y ros-$ROS1_DISTRO-joint-state-publisher-gui


RUN apt-get update && apt-get install -y apt-utils \
    lsb-release \
    mesa-utils \
    gnupg2 \
    net-tools \
    build-essential \
    wget \
    unzip \
    curl \
    git \
    mc \
    vim

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

RUN apt-get update && apt-get install -y \
    cmake \
    libatlas-base-dev \
    libeigen3-dev \
    libgoogle-glog-dev \
    libsuitesparse-dev \  
    xvfb libfmt-dev \
    ros-noetic-image-geometry \
    ros-noetic-pcl-ros \
    ros-noetic-image-proc \
    ros-noetic-tf-conversions \
    ros-noetic-sophus \
    ros-noetic-cv-bridge \
    ros-noetic-tf2-geometry-msgs && \
    # System dependencies
    apt-get install -y git \
    build-essential unzip pkg-config autoconf \
    libboost-all-dev \
    libjpeg-dev libpng-dev libtiff-dev \
    libvtk6-dev libgtk-3-dev \
    libatlas-base-dev gfortran \
    libparmetis-dev \
    libgl1-mesa-dev libglew-dev \
    python3-wstool python3-catkin-tools && \
    rm -rf /var/lib/apt/lists/*

RUN rosdep update

RUN apt-get update && apt-get install -y 

RUN cd /root/ && \
    git clone https://github.com/stevenlovegrove/Pangolin.git && \
    cd Pangolin && \
    git fetch && \
    git checkout tags/v0.6 && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_EXAMPLES=OFF .. && \
    make -j2 && \
    rm -rf Pangolin

RUN cd /var/tmp && \
    git clone https://github.com/strasdat/Sophus.git && \
    cd Sophus && \
    mkdir build && \
    cd build && \
    cmake -D CMAKE_BUILD_TYPE=Release \
    -D SOPHUS_INSTALL=ON .. && \
    make install -j2 && \
    rm -rf Sophus

RUN source /opt/ros/noetic/setup.bash
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
RUN echo "source /workspace/devel/setup.bash" >> ~/.bashrc
RUN echo "export CATKIN_WS=/workspace" >> ~/.bashrc
