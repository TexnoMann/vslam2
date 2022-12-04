#!/bin/bash
docker run \
  -it \
  --rm \
  --net=host \
  vslam \
  /bin/bash