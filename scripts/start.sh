#!/bin/bash

echo "开始启动项目..."

export PROXY_IP=$1


function setProxy() {   
    echo "设置代理..."
    export http_proxy=http://${PROXY_IP}
    export https_proxy=http://${PROXY_IP}
}

function unsetProxy() {
    echo "取消代理..."
    unset http_proxy
    unset https_proxy
}

function starrK8s() {
    echo "开始启动 Kubernetes 集群..."
    setProxy
    sudo kubeadm config images pull
    unsetProxy
    # 初始化集群
    echo "初始化集群..."
    sudo kubeadm init --pod-network-cidr=10.244.0.0/16
    # 配置 kubectl
    echo "配置 kubectl..."
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

}

starrK8s
