#!/usr/bin/env bash
docker run -it --privileged=true \
  --cap-add=SYS_ADMIN \
  --security-opt seccomp=unconfined \
  -m 8192m -h bootcamp1.docker \
  --name bigbox -p 2222:22 -p 9530:9530 \
  bigbox /bin/bash


