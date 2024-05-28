#!/bin/bash

apt-get update -qq && apt-get install -y \
  libbtrfs-dev \
  git \
  libassuan-dev \
  libdevmapper-dev \
  libglib2.0-dev \
  libc6-dev \
  libgpgme-dev \
  libgpg-error-dev \
  libseccomp-dev \
  libsystemd-dev \
  libselinux1-dev \
  pkg-config \
  go-md2man \
  libudev-dev \
  software-properties-common \
  gcc \
  make

BUILD_ROOT="$(pwd)"
BUILD_ARCH="${BUILD_ARCH:-amd64}"

rm -rf "${BUILD_ROOT}/.dist/${BUILD_ARCH}"
mkdir -p "${BUILD_ROOT}/.tmp"

# source ${BUILD_ROOT}/src/containers-common.sh
source ${BUILD_ROOT}/src/cri-o.sh
