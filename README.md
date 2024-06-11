# cri-o

为 ansible-podman 项目准备可跨平台的 cri-o 二进制文件。

## build

[cri-o](https://github.com/cri-o/cri-o)

```bash
# amd64
docker run -it --rm \
-v $PWD/:/go/src/github.com/open-beagle/cri-o \
-v $PWD/.tmp/nix:/nix \
-w /go/src/github.com/open-beagle/cri-o \
-e BUILD_ARCH=amd64 \
registry.cn-qingdao.aliyuncs.com/wod/nix:2.3.16 \
sh src/debug.sh

# arm64
docker run -it --rm \
-v $PWD/:/go/src/github.com/open-beagle/cri-o \
-v $PWD/.tmp/nix:/nix \
-w /go/src/github.com/open-beagle/cri-o \
-e BUILD_ARCH=arm64 \
registry.cn-qingdao.aliyuncs.com/wod/nix:2.3.16 \
sh src/debug.sh
```

## nix

```bash
docker pull nixos/nix:2.3.16 && \
docker tag nixos/nix:2.3.16 registry.cn-qingdao.aliyuncs.com/wod/nix:2.3.16 && \
docker push registry.cn-qingdao.aliyuncs.com/wod/nix:2.3.16

docker run -it --rm \
-v $PWD/:/go/src/github.com/open-beagle/cri-o \
-w /go/src/github.com/open-beagle/cri-o \
registry.cn-qingdao.aliyuncs.com/wod/nix:2.3.16 \
sh -c '
  mkdir -p $PWD/.tmp/nix && \
  cp -rfT /nix $PWD/.tmp/nix
'
```

## cri-o.deb

```bash
# cri-o
# Redhat研发的容器管理工具，用于替代cri-o
curl -x socks5://www.ali.wodcloud.com:1283 -sL http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/1.28/xUbuntu_22.04/amd64/cri-o_1.28.4~0_amd64.deb > $PWD/.tmp/cri-o_1.28.4~0_amd64.deb && \
mkdir -p $PWD/.tmp/cri-o_1.28.4~0_amd64/DEBIAN/ && \
dpkg -X $PWD/.tmp/cri-o_1.28.4~0_amd64.deb $PWD/.tmp/cri-o_1.28.4~0_amd64/ && \
dpkg -e $PWD/.tmp/cri-o_1.28.4~0_amd64.deb $PWD/.tmp/cri-o_1.28.4~0_amd64/DEBIAN/

# cri-o-runc
# 用于CRI-O的容器运行时RUNC，取自RUNC的CRI-O分支
curl -x socks5://www.ali.wodcloud.com:1283 -sL https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_22.04/amd64/cri-o-runc_1.1.12~0_amd64.deb > $PWD/.tmp/cri-o-runc_1.1.12~0_amd64.deb && \
mkdir -p $PWD/.tmp/cri-o-runc_1.1.12~0_amd64/DEBIAN/ && \
dpkg -X $PWD/.tmp/cri-o-runc_1.1.12~0_amd64.deb $PWD/.tmp/cri-o-runc_1.1.12~0_amd64/ && \
dpkg -e $PWD/.tmp/cri-o-runc_1.1.12~0_amd64.deb $PWD/.tmp/cri-o-runc_1.1.12~0_amd64/DEBIAN/

# containers-common
#
curl -x socks5://www.ali.wodcloud.com:1283 -sL https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_22.04/all/containers-common_1-22_all.deb > $PWD/.tmp/containers-common_1-22_all.deb && \
mkdir -p $PWD/.tmp/containers-common_1-22_all/DEBIAN/ && \
dpkg -X $PWD/.tmp/containers-common_1-22_all.deb $PWD/.tmp/containers-common_1-22_all/ && \
dpkg -e $PWD/.tmp/containers-common_1-22_all.deb $PWD/.tmp/containers-common_1-22_all/DEBIAN/

# conmon
# conmon是一个监控工具。Podman和CRI-O，使用conmon来监控runc或crun运行的容器的运行状态。
curl -x socks5://www.ali.wodcloud.com:1283 -sL https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_22.04/amd64/conmon_2.1.2~0_amd64.deb > $PWD/.tmp/conmon_2.1.2~0_amd64.deb && \
mkdir -p $PWD/.tmp/conmon_2.1.2~0_amd64/DEBIAN/ && \
dpkg -X $PWD/.tmp/conmon_2.1.2~0_amd64.deb $PWD/.tmp/conmon_2.1.2~0_amd64/ && \
dpkg -e $PWD/.tmp/conmon_2.1.2~0_amd64.deb $PWD/.tmp/conmon_2.1.2~0_amd64/DEBIAN/
```

## cache

```bash
# 构建缓存-->推送缓存至服务器
docker run --rm \
  -e PLUGIN_REBUILD=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="cri-o" \
  -e PLUGIN_MOUNT="./.git,./.tmp/nix,./.tmp/cri-o-v1.30.1,./.tmp/conmon-v2.1.12" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0

# 读取缓存-->将缓存从服务器拉取到本地
docker run --rm \
  -e PLUGIN_RESTORE=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="cri-o" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0
```
