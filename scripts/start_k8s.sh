#!/bin/bash

echo "开始启动项目..."

export PROXY_IP=${1:-}  # 允许空代理设置

function starrK8s() {
    # 检查时间
    date
    sudo timedatectl set-ntp true
    echo 'KUBELET_KUBEADM_ARGS=""' > /var/lib/kubelet/kubeadm-flags.env
    kubectl delete pvc --all --all-namespaces
    kubectl delete pv --all
    kubectl delete ns starrocks local-path-storage
    sudo ip link delete cni0
    sudo ip link delete flannel.1
    sudo kubeadm reset -f
    sudo systemctl stop kubelet
    sudo rm -rf /etc/kubernetes/*
    sudo rm -rf /var/lib/etcd
    sudo rm -rf ~/.kube
    echo "开始启动 Kubernetes 集群..."
    bash scripts/utils/container_proxy_pull.sh containerd ${PROXY_IP} true ghcr.io/flannel-io/flannel:v0.27.0 ghcr.io/flannel-io/flannel-cni-plugin:v1.7.1-flannel1 docker.io/flannel/flannel-cni-plugin:v1.1.2 docker.io/flannel/flannel-cni-plugin:v1.1.2
    sudo kubeadm config images pull --config=init-config.yaml --v=5
    bash scripts/utils/container_proxy_pull.sh containerd ${PROXY_IP} false
    echo "初始化集群..."
    export MASTER_IP=192.168.10.140
    sudo kubeadm init --config init-config.yaml --v=5
    echo "配置 kubectl..."
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    # 禁用 CoreDNS 的内存限制
    kubectl patch deployment -n kube-system coredns -p '{"spec":{"template":{"spec":{"containers":[{"name":"coredns","resources":null}]}}}}'
    kubectl apply -f kube-flannel.yaml
    kubectl rollout status -n kube-system daemonset/kube-flannel --timeout=120s
    # 创建默认PVC
    kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
    kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
}

starrK8s