#!/bin/bash

function del_k8s() {
    echo "🧹 开始清理 Kubernetes 环境..."
    
    echo "清理工作负载..."
    kubectl delete all --all --all-namespaces --force --grace-period=0
    kubectl delete pvc --all --all-namespaces --force --grace-period=0
    kubectl delete pv --all --force --grace-period=0
    kubectl delete ns starrocks local-path-storage --force --grace-period=0

    echo "清理网络组件..."
    sudo ip link delete cni0 2>/dev/null || true
    sudo ip link delete flannel.1 2>/dev/null || true
    sudo rm -rf /var/lib/cni/
    sudo rm -rf /etc/cni/
    sudo rm -rf /run/flannel/
    sudo rm -rf /var/run/flannel/

    echo "清理 iptables 规则..."
    sudo iptables -F
    sudo iptables -X
    sudo iptables -t nat -F
    sudo iptables -t nat -X
    sudo iptables -t raw -F
    sudo iptables -t raw -X
    sudo iptables -t mangle -F
    sudo iptables -t mangle -X

    echo "重置 kubeadm..."
    sudo kubeadm reset -f

    echo "清理系统文件..."
    sudo rm -rf /etc/kubernetes/*
    sudo rm -rf /var/lib/etcd
    sudo rm -rf /var/lib/kubelet/*
    sudo rm -rf /var/lib/dockershim/*
    sudo rm -rf /var/run/kubernetes/*
    sudo rm -rf /var/lib/docker/* || true
    sudo rm -rf /var/lib/containerd/* || true
    sudo rm -rf ~/.kube

    echo "✅ Kubernetes 环境清理完成！"
}

del_k8s