#!/usr/bin/env bash

set -ex

dpkg-checkbuilddeps
dpkg-buildpackage -b -us -uc

cp ../*.deb ../*.changes /files
