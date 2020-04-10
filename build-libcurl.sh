#!/bin/sh

# Original script created by djcj
# build on CentOS 6.9 (64 bit)
# https://github.com/probonopd/AppImages/issues/187
# https://launchpad.net/~djcj/+archive/ubuntu/libcurl-slim

rm -f /files/*_i686 /files/*_x86_64

set -e

version=$1
if [ "${version}" = "/root/build-libcurl.sh" ]; then
  # https://github.com/mxe/mxe/blob/master/src/curl.mk
  version=$(cat CURL_VERSION)
  #version=$(wget -q -O- 'https://curl.haxx.se/download/?C=M;O=D' | \
  #  sed -n 's,.*curl-\([0-9][^"]*\)\.tar.*,\1,p' | head -1)
fi

wget -c "https://curl.haxx.se/download/curl-${version}.tar.bz2"

rm -rf curl-${version}
tar xf curl-${version}.tar.bz2
cd curl-${version}

if [ -f lib/libcurl.vers.in ]; then
  sed -i 's|FLAVOUR@4|FLAVOUR@3|' lib/libcurl.vers.in
fi

CFLAGS="-O2 -fstack-protector" LDFLAGS="-Wl,--as-needed -Wl,-z,relro" \
  ./configure --enable-optimize --disable-debug --enable-shared --disable-static --without-ssl --with-gnutls --with-ca-bundle=/etc/ssl/certs/ca-certificates.crt
make -j`nproc`
libcurl=$(readlink lib/.libs/libcurl.so)
cp src/.libs/curl /files/curl_x86_64
cp lib/.libs/$libcurl /files/${libcurl}_x86_64

cd ..

rm -rf curl-${version}
tar xf curl-${version}.tar.bz2
cd curl-${version}

CFLAGS="-m32 -O2 -fstack-protector" LDFLAGS="-m32 -Wl,--as-needed -Wl,-z,relro" \
  ./configure --enable-optimize --disable-debug --enable-shared --disable-static --without-ssl --with-gnutls --with-ca-bundle=/etc/ssl/certs/ca-certificates.crt --host=i686-pc-linux-gnu
make -j`nproc`
cp src/.libs/curl /files/curl_i686
cp lib/.libs/$libcurl /files/${libcurl}_i686
cd ..

strip /files/libcurl.so.* /files/curl_i686 /files/curl_x86_64

set +x

file /files/curl_i686
file /files/curl_x86_64
file /files/${libcurl}_i686
file /files/${libcurl}_x86_64

rm -f /debian/curl_* /debian/${libcurl}_*

for bin in /files/curl_i686 /files/curl_x86_64 /files/${libcurl}_i686 /files/${libcurl}_x86_64 ; do
  glibc=$(objdump -t $bin | sed -n 's/.*@@GLIBC_//p' | grep -e '^[0-9]' | cut -d ' ' -f1 | tr -d ')' | sort -uV | tail -1)
  if [ -z "$glibc" ]; then
    glibc=$(objdump -T $bin | sed -n 's/.*GLIBC_//p' | grep -e '^[0-9]' | cut -d ' ' -f1 | tr -d ')' | sort -uV | tail -1)
  fi
  echo "$bin: GLIBC $glibc"
  base64 $bin > /debian/$(basename $bin).centos6.7.b64
done

