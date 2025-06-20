#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "开始启动项目..."

export PROXY_IP=${1:-} # 允许空代理设置
export MASTER_IP=192.168.10.140

function validate_runtime() {
    if [ -z "${PROXY_IP}" ]; then
        echo "请设置代理IP"
        exit 1
    fi
    if [ -z "${MASTER_IP}" ]; then
        echo "请设置Master IP"
        exit 1
    fi
}

function check_k8s_env() {
    echo "检查时间..."
    date
    sudo timedatectl set-ntp true
}

function is_k8s_initialized() {
    echo "检查是否存在 Kubernetes 环境..."

    # 检查关键文件和目录
    if [ -f "/etc/kubernetes/admin.conf" ] ||
        [ -d "/etc/kubernetes/manifests" ] ||
        [ -d "/var/lib/etcd" ] ||
        systemctl is-active kubelet >/dev/null 2>&1 ||
        ([ -S "/var/run/containerd/containerd.sock" ] &&
            sudo ctr --namespace k8s.io containers ls >/dev/null 2>&1); then
        echo "⚠️ 检测到已存在的 Kubernetes 环境"
        echo "🧹 正在执行环境清理..."
        bash ${SCRIPT_DIR}/utils/sightiq_del_k8s.sh
        echo "✅ 环境清理完成"
        return 0
    fi

    return 1 # 返回 false，表示环境不存在
}

function starrK8s() {
    validate_runtime
    check_k8s_env
    if is_k8s_initialized; then
        echo "⏳ 等待 30 秒确保服务完全停止..."
        sleep 30
    fi

    echo "开始启动 Kubernetes 集群..."
    bash ${SCRIPT_DIR}/utils/container_proxy_pull.sh containerd ${PROXY_IP} true ghcr.io/flannel-io/flannel:v0.27.0 ghcr.io/flannel-io/flannel-cni-plugin:v1.7.1-flannel1 docker.io/flannel/flannel-cni-plugin:v1.1.2 docker.io/flannel/flannel-cni-plugin:v1.1.2
    sudo kubeadm config images pull --config=${PROJECT_ROOT}/k8s/init-config.yaml --v=5
    bash ${SCRIPT_DIR}/utils/container_proxy_pull.sh containerd ${PROXY_IP} false
    echo "初始化集群..."
    export MASTER_IP=192.168.10.140
    sudo kubeadm init --config ${PROJECT_ROOT}/k8s/init-config.yaml --v=5
    echo "配置 kubectl..."
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    echo 'KUBELET_KUBEADM_ARGS=""' >/var/lib/kubelet/kubeadm-flags.env
    # 禁用 CoreDNS 的内存限制
    kubectl patch deployment -n kube-system coredns -p '{"spec":{"template":{"spec":{"containers":[{"name":"coredns","resources":null}]}}}}'
    kubectl apply -f ${PROJECT_ROOT}/k8s/kube-flannel.yaml
    kubectl rollout status -n kube-system daemonset/kube-flannel --timeout=120s
    # 创建默认PVC
    kubectl apply -f ${PROJECT_ROOT}/k8s/local-path-storage.yaml
    kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
}

starrK8s
