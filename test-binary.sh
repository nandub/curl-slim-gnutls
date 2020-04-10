#!/usr/bin/env bash

test_cmd()
{
    pushd /files; ln -sf libcurl.so.4.4.0.`uname -m` libcurl.so.4; ls -la; popd
    export CFLAGS="-I/files"
    export LDFLAGS="-L/files"
    export LD_LIBRARY_PATH="/files:/lib/i386-linux-gnui:/lib/x86_64-linux-gnui:/lib:/lib64"
    "$@"
}
test_cmd /files/curl.`uname -m` $@
