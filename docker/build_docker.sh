#!/usr/bin/env bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
EXEC_PATH=$PWD
CUDA_VERSION="11.7.1"
NVIDIA_DIST="nvidia/cuda:${CUDA_VERSION}-base-ubuntu20.04"
BASE_DIST="ubuntu:focal"


echo "Start building in: $ROOT_DIR"

cd $ROOT_DIR


docker build -t vslam-img -f $ROOT_DIR/docker/Dockerfile $ROOT_DIR \
                                --network=host \
                                --build-arg BASE_IMG=$NVIDIA_DIST

cd $EXEC_PATH
