#!/usr/bin/env bash

set -xe

docker run --rm -it --name build_curl_slim:latest -v$(pwd)/debian:/debian -v$(pwd)/files:/files $LOGNAME/build_curl_slim
docker run --rm -it --name deb_curl_slim:latest -v$(pwd)/debian:/debian -v$(pwd)/files:/files $LOGNAME/deb_curl_slim
docker run --rm -it --name deb_curl_slim_i386:latest -v$(pwd)/debian:/debian -v$(pwd)/files:/files $LOGNAME/deb_curl_slim_i386
