#!/usr/bin/env bash

cd debian/
ls -1 libcurl.so.* | head -1 | awk -F'_' '{print $1}'
