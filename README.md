# helm-env-checker
用于在 helm 安装 Rainbond 的过程中，执行 pre-install hook 安装环境检测工作

## 已有检测项

- 检测给定的网关节点中，80 443 6060 7070 8443 等端口是否被占用

- 检测在使用默认 nfs 的情况下，所有的节点是否已经安装了 nfs 客户端挂载工具

## 构建方式

```bash
make
```

## 使用方式

- 检测网关节点端口占用

```bash
docker run -ti -e GATEWAY_IP="192.168.1.1 192.168.1.2" registry.cn-hangzhou.aliyuncs.com/goodrain/helm-env-checker check_gateway
```

- 检测 nfs 客户端工具是否安装

```bash
docker run -ti -e NODE="192.168.1.1" -v /usr/sbin:/usr/sbin -v /sbin:/sbin registry.cn-hangzhou.aliyuncs.com/goodrain/helm-env-checker check_nfsclient
```

**实际使用过程中，该项目作为 https://github.com/goodrain/rainbond-chart 项目的pre-install hooks 使用**