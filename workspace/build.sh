#!/bin/bash

# RUN source /opt/ros/noetic/setup.bash && \
cd /workspace/src && \
    wstool init && \
    wstool merge vslam2/vslam2.rosinstall   && \
    wstool update

cd /workspace && \
    catkin build -j2 catkin_simple && \ 
    catkin build -j2 dbow2_catkin && \ 
    catkin build -j2 g2o_catkin 

cd /workspace/src/vslam2/ORB_SLAM3  && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_EXAMPLES=OFF .. && \
    make -j2

cd /workspace && \
    catkin build -j2
