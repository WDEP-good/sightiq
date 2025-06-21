#!/bin/bash

PROXY_IP=""
RUNTIME="containerd"

export SIGHTIQ_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SIGHTIQ_ROOT="$(cd "$SIGHTIQ_SCRIPT_DIR/.." && pwd)"


while [[ $# -gt 0 ]]; do
    case $1 in
        --proxy-ip|-p)
            PROXY_IP="$2"
            shift 2
            ;;
        --runtime|-r)
            RUNTIME="$2"
            shift 2
            ;;
        --help|-h)
            echo "用法: $0 [选项]"
            echo "选项:"
            echo "  -p, --proxy-ip <IP地址>    设置代理IP地址"
            echo "  -r, --runtime <类型>       设置运行时类型"
            echo "  -h, --help                显示此帮助信息"
            exit 0
            ;;
        *)
            echo "错误: 未知参数 $1"
            echo "使用 -h 或 --help 查看帮助信息"
            exit 1
            ;;
    esac
done

function check_node_env() {
    echo "检查时间..."
    date
    sudo timedatectl set-ntp true
    sudo timedatectl set-timezone Asia/Shanghai
    
    echo "关闭 swap..."
    sudo swapoff -a
    # 注释掉 /etc/fstab 中的 swap 条目以防止重启后自动启用
    sudo sed -i '/swap/s/^/#/' /etc/fstab
}

function init_node() {
    echo "初始化节点环境..."
    bash $SIGHTIQ_SCRIPT_DIR/init_env.sh
    check_node_env
    echo "开始启动 Kubernetes 集群..."
    bash $SIGHTIQ_SCRIPT_DIR/utils/container_proxy_pull.sh -r ${RUNTIME} -p ${PROXY_IP} -k ghcr.io/flannel-io/flannel:v0.27.0 ghcr.io/flannel-io/flannel-cni-plugin:v1.7.1-flannel1 docker.io/flannel/flannel-cni-plugin:v1.1.2 docker.io/flannel/flannel-cni-plugin:v1.1.2
    sudo kubeadm config images pull --config=$SIGHTIQ_ROOT/k8s/init-config.yaml --v=5
    bash $SIGHTIQ_SCRIPT_DIR/utils/container_proxy_pull.sh -r ${RUNTIME} -p ${PROXY_IP}
    echo "初始化集群..."
    sudo kubeadm init --config $SIGHTIQ_ROOT/k8s/init-config.yaml --v=5
    init_kubectl
}

init_node
