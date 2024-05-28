# cri-o

为 ansible-podman 项目准备可跨平台的 cri-o 二进制文件。

## build

[cri-o](https://github.com/cri-o/cri-o)

```bash
# amd64
docker run -it --rm \
-v $PWD/:/go/src/github.com/open-beagle/cri-o \
-w /go/src/github.com/open-beagle/cri-o \
-e BUILD_ARCH=amd64 \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.22-amd64 \
bash
```

## nix

```bash
docker pull nixos/nix:2.3.16 && \
docker tag nixos/nix:2.3.16 registry.cn-qingdao.aliyuncs.com/wod/nix:2.3.16 && \
docker push registry.cn-qingdao.aliyuncs.com/wod/nix:2.3.16

docker run -it --rm \
-v $PWD/:/go/src/github.com/open-beagle/cri-o \
-w /go/src/github.com/open-beagle/cri-o/.tmp/cri-o-v1.30.1 \
registry.cn-qingdao.aliyuncs.com/wod/nix:2.3.16 \
sh -c '
nix --print-build-logs --option cores 8 --option max-jobs 8 build --file nix/ && \
mkdir -p bin && \
cp -r result/bin bin/static
'

docker run -it --rm \
-v $PWD/:/go/src/github.com/open-beagle/cri-o \
-w /go/src/github.com/open-beagle/cri-o/.tmp/cri-o-v1.30.1 \
registry.cn-qingdao.aliyuncs.com/wod/nix:2.3.16 \
sh -c '
rm -rf /nix && \
cp -rfT ../nix /nix && \
nix --print-build-logs --option cores 8 --option max-jobs 8 build --file nix/ && \
mkdir -p ../../.dist && \
cp -r result/bin ../../.dist/amd64
'

docker run -it --rm \
-v $PWD/:/go/src/github.com/open-beagle/cri-o \
-w /go/src/github.com/open-beagle/cri-o/.tmp/cri-o-v1.30.1 \
registry.cn-qingdao.aliyuncs.com/wod/nix:2.3.16 \
sh -c '
rm -rf /nix && \
cp -rfT ../nix /nix && \
nix --print-build-logs --option cores 8 --option max-jobs 8 build --file nix/ && \
mkdir -p bin && \
cp -r result/bin ../../.dist/arm64
'
```
