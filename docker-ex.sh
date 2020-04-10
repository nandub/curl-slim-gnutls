#!/usr/bin/env bash

if [ "x$1" == "xfuse" ]; then
  fuse="--cap-add SYS_ADMIN --cap-add MKNOD --device=/dev/fuse"
  shift
fi
docker run --privileged -it --entrypoint $SHELL $fuse -v$(pwd)/debian:/debian -v$(pwd)/files:/files $1
