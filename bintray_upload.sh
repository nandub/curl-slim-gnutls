#!/usr/bin/env bash
set -e
[ -n "$DEBUG" ] && set -x

THIS=$(pwd)
wget -q https://raw.githubusercontent.com/nandub/bintray.sh/master/bintray.sh -O ${THIS}/bintray.sh
wget -q https://raw.githubusercontent.com/nandub/bintray.sh/master/bintray-tidy.sh -O ${THIS}/bintray-tidy.sh

chmod 755 ${THIS}/bintray.sh
chmod 755 ${THIS}/bintray-tidy.sh

export BINTRAY_USER="nandub"
export BINTRAY_API_KEY=${BINTRAY_API_KEY}
export BINTRAY_REPO="OSS"
export BINTRAY_REPO_OWNER="haruka" # owner and user not always the same
export BINTRAY_PARAMETERS="deb_distribution=trusty;deb_component=main;deb_architecture=i386,amd64"
export WEBSITE_URL="https://github.com/nandub/curl-slim-gnutls"
export ISSUE_TRACKER_URL="https://github.com/nandub/curl-slim-gnutls/issues"
export VCS_URL="https://github.com/nandub/curl-slim-gnutls.git"
export LICENSES=MIT
export LABELS=trusty,curl,libcurl,gnutls

files_to_upload=$1
files=$(ls -1 $files_to_upload/*.deb)
for file in $files
do
    bash ${THIS}/bintray.sh $file
done
