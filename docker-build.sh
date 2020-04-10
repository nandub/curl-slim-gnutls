#!/usr/bin/env bash

set -xe

docker build -t $LOGNAME/build_curl_slim:latest -f Dockerfile.centos .
docker build -t $LOGNAME/deb_curl_slim:latest -f Dockerfile.ubuntu .
docker build -t $LOGNAME/deb_curl_slim_i386:latest -f Dockerfile.ubuntu_i386 .
