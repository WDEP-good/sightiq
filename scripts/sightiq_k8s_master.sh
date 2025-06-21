#!/bin/bash

PROXY_IP=""
RUNTIME="containerd"

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

function check_k8s_env() {
    echo "检查时间..."
    date
    sudo timedatectl set-ntp true
    sudo timedatectl set-timezone Asia/Shanghai
    
    echo "关闭 swap..."
    sudo swapoff -a
    # 注释掉 /etc/fstab 中的 swap 条目以防止重启后自动启用
    sudo sed -i '/swap/s/^/#/' /etc/fstab
}

function k8s_initialized() {
    echo "检查是否存在 Kubernetes 环境..."
    if [ -f "/etc/kubernetes/admin.conf" ] ||
        [ -d "/etc/kubernetes/manifests" ] ||
        [ -d "/var/lib/etcd" ] ||
        systemctl is-active kubelet >/dev/null 2>&1 ||
        ([ -S "/var/run/containerd/containerd.sock" ] &&
            sudo ctr --namespace k8s.io containers ls >/dev/null 2>&1); then
        echo "⚠️ 检测到已存在的 Kubernetes 环境"
        echo "🧹 正在执行环境清理..."
        bash ${SIGHTIQ_SCRIPT_DIR}/utils/sightiq_del_k8s.sh
        echo "✅ 环境清理完成"
        return 0
    fi
    echo "❌ 未检测到已存在的 Kubernetes 环境"
}

function init_kubectl() {
    echo "配置 kubectl..."
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    echo 'KUBELET_KUBEADM_ARGS=""' >/var/lib/kubelet/kubeadm-flags.env
    # 禁用 CoreDNS 的内存限制
    kubectl patch deployment -n kube-system coredns -p '{"spec":{"template":{"spec":{"containers":[{"name":"coredns","resources":null}]}}}}'
    kubectl apply -f $SIGHTIQ_ROOT/k8s/kube-flannel.yaml
    kubectl rollout status -n kube-system daemonset/kube-flannel --timeout=120s
    # 创建默认PVC
    kubectl apply -f $SIGHTIQ_ROOT/k8s/local-path-storage.yaml
    kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
}

function startK8s() {
    check_k8s_env
    k8s_initialized
    echo "开始启动 Kubernetes 集群..."
    bash ${SIGHTIQ_SCRIPT_DIR}/utils/container_proxy_pull.sh -r ${RUNTIME} -p ${PROXY_IP} -k ghcr.io/flannel-io/flannel:v0.27.0 ghcr.io/flannel-io/flannel-cni-plugin:v1.7.1-flannel1 docker.io/flannel/flannel-cni-plugin:v1.1.2 docker.io/flannel/flannel-cni-plugin:v1.1.2
    sudo kubeadm config images pull --config=$SIGHTIQ_ROOT/k8s/init-config.yaml --v=5
    bash ${SIGHTIQ_SCRIPT_DIR}/utils/container_proxy_pull.sh -r ${RUNTIME} -p ${PROXY_IP}
    echo "初始化集群..."
    sudo kubeadm init --config $SIGHTIQ_ROOT/k8s/init-config.yaml --v=5
    init_kubectl
}

startK8s
