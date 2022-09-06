#!/bin/bash

RED='\033[0;31m'
GREEN='\033[32;1m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
ERROR=${RED}ERROR${NC}
INFO=${GREEN}INFO${NC}
WARN=${YELLOW}WARN${NC}

# 检测网关节点是否被定义
function check_gateway() {
    `ping registry.cn-hangzhou.aliyuncs.com -c4 &>/dev/null`
    a=$?
    `curl docker.io &> /dev/null`
    b=$?
    if [ $a -ne  0 ] && [ $b -ne 0 ]
    then
        echo "外部网络不可访问，退出安装"
        return
    fi
    if [ -z "$GATEWAY_IP" ]; then
        echo -e "${WARN} No custom gateway nodes are detected, which is highly discouraged."
        echo -e "${WARN} 没有检测到自定义的网关节点,即将自动选择网关节点并跳过检测."
        GATEWAY_IP=($GATEWAY_AUTO_0 $GATEWAY_AUTO_1)
    else
        echo -e "${INFO} Found defined gateway IP $GATEWAY_IP"
        echo -e "${INFO} 检测到自定义的网关节点: $GATEWAY_IP"
    fi

    # 检测网关节点是否有端口占用
    if [ -z "$NOT_CHECK_7070" ]; then
        echo -e "${INFO} 通过helm安装rainbond和控制台."
        ports=(80 443 6060 7070 8443)
    else
        echo -e "${INFO} 通过helm对接集群到控制台."
        ports=(80 443 6060 8443)
    fi
    for ip in ${GATEWAY_IP[@]}; do
        if !(ping -c 1 -i 0.2 -W 1 $ip>/dev/null); then
            echo -e "${ERROR} Gateway $ip is unreachable!"
            echo -e "${ERROR} 已设定的网关 $ip 网络不可达"
            exit 1
        fi
        for port in ${ports[@]}; do
            if (nc -zw1 $ip $port); then
                echo -e "${ERROR} Port $port of $ip is in used!"
                echo -e "${ERROR} $ip 的 $port 端口已经被占用"
                exit 1
            fi
            echo -e "${INFO} $ip:$port ready"
        done
    done
}

# 检测 nfs-client 包是否存在
function check_nfsclient() {
    if !(which mount.nfs) && !(which mount_nfs); then
        echo -e "${ERROR} Nfs client must been installed on node $NODE!"
        echo -e "${ERROR} Nfs 客户端在节点 $NODE 中没有被检测到, 请确定是否已在所有宿主机安装该软件包."
        echo -e "${INFO} For CentOS: yum install -y nfs-utils; For Ubuntu: apt install -y nfs-common"
        exit 2
    else
        echo -e "${INFO} Nfs client ready on node $NODE"
    fi
}

case $1 in
check_gateway)
    check_gateway
    ;;
check_nfsclient)
    check_nfsclient
    ;;
*)
    bash
    ;;
esac
