#!/bin/bash

set -ex

name=containers-common
version=v0.58.3
mkdir -p ${BUILD_ROOT}/.tmp
if [ ! -d ${BUILD_ROOT}/.tmp/${name}-${version} ]; then
  git config --global http.proxy 'socks5://www.ali.wodcloud.com:1283'
  git clone -b ${version} https://github.com/containers/common ${BUILD_ROOT}/.tmp/${name}-${version}
fi

cd ${BUILD_ROOT}/.tmp/${name}-${version}
mkdir -p ${BUILD_ROOT}/.dist/${BUILD_ARCH}
export DESTDIR="${BUILD_ROOT}/.dist/${BUILD_ARCH}"

make
make install
