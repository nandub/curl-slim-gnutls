#!/bin/sh
# build on CentOS 6.9 (64 bit)
# https://github.com/probonopd/AppImages/issues/187
# https://launchpad.net/~djcj/+archive/ubuntu/libcurl-slim
set -e
set -x

# https://github.com/mxe/mxe/blob/master/src/curl.mk
version=$(wget -q -O- 'https://curl.haxx.se/download/?C=M;O=D' | \
  sed -n 's,.*curl-\([0-9][^"]*\)\.tar.*,\1,p' | head -1)

wget -c "https://curl.haxx.se/download/curl-${version}.tar.bz2"

rm -rf curl-${version}
tar xf curl-${version}.tar.bz2
cd curl-${version}

sed -i 's|FLAVOUR@4|FLAVOUR@3|' lib/libcurl.vers.in

CFLAGS="-O2 -fstack-protector" LDFLAGS="-Wl,--as-needed -Wl,-z,relro" \
  ./configure --enable-optimize --disable-debug --enable-shared --disable-static
make -j`nproc`
libcurl=$(readlink lib/.libs/libcurl.so)
cp src/.libs/curl ../curl.x86_64
cp lib/.libs/$libcurl ../${libcurl}.x86_64
make distclean

CFLAGS="-m32 -O2 -fstack-protector" LDFLAGS="-m32 -Wl,--as-needed -Wl,-z,relro" \
  ./configure --enable-optimize --disable-debug --enable-shared --disable-static --host=i686-pc-linux-gnu
make -j`nproc`
cp src/.libs/curl ../curl.i686
cp lib/.libs/$libcurl ../${libcurl}.i686
cd ..

strip libcurl.so.* curl.i686 curl.x86_64

set +x

file curl.i686
file curl.x86_64
file ${libcurl}.i686
file ${libcurl}.x86_64

for bin in curl.i686 curl.x86_64 ${libcurl}.i686 ${libcurl}.x86_64 ; do
  glibc=$(objdump -t $bin | sed -n 's/.*@@GLIBC_//p' | grep -e '^[0-9]' | cut -d ' ' -f1 | tr -d ')' | sort -uV | tail -1)
  if [ -z "$glibc" ]; then
    glibc=$(objdump -T $bin | sed -n 's/.*GLIBC_//p' | grep -e '^[0-9]' | cut -d ' ' -f1 | tr -d ')' | sort -uV | tail -1)
  fi
  echo "$bin: GLIBC $glibc"
done

