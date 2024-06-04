#!/bin/bash
set -ex

name=conmon
version=v2.1.12

if [ ! -d ${BUILD_ROOT}/.tmp/${name}-${version} ]; then
  git config --global http.proxy 'socks5://www.ali.wodcloud.com:1283'
  git clone -b ${version} https://github.com/containers/conmon ${BUILD_ROOT}/.tmp/${name}-${version}
fi


cd ${BUILD_ROOT}/.tmp/${name}-${version}

nix --print-build-logs --option cores 8 --option max-jobs 8 build --file nix/default-${BUILD_ARCH}.nix

cp -r result/bin ${BUILD_ROOT}/.dist/${BUILD_ARCH}
