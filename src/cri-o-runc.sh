#!/bin/bash

set -ex

name=cri-o
version=v1.30.1
mkdir -p ${BUILD_ROOT}/.tmp
if [ ! -d ${BUILD_ROOT}/.tmp/${name}-${version} ]; then
  git config --global http.proxy 'socks5://www.ali.wodcloud.com:1283'
  git clone -b ${version} https://github.com/cri-o/cri-o ${BUILD_ROOT}/.tmp/${name}-${version}
fi

cd ${BUILD_ROOT}/.tmp/${name}-${version}
mkdir -p ${BUILD_ROOT}/.dist/${BUILD_ARCH}
export DESTDIR="${BUILD_ROOT}/.dist/${BUILD_ARCH}"
make BUILDTAGS="libseccomp"
make install
