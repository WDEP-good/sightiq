#!/bin/bash

echo "开始启动项目..."

export PROXY_IP=$1

function setProxy() {
    echo "设置代理..."
    export http_proxy=http://${PROXY_IP}
    export https_proxy=http://${PROXY_IP}

    sudo mkdir -p /etc/systemd/system/containerd.service.d
    cat <<EOF | sudo tee /etc/systemd/system/containerd.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://${PROXY_IP}"
Environment="HTTPS_PROXY=http://${PROXY_IP}"
# no_proxy 里保留 localhost 和集群内 IP
Environment="NO_PROXY=127.0.0.1,localhost,10.96.0.0/12,10.244.0.0/16"
EOF
    sudo systemctl daemon-reload
    sudo systemctl restart containerd

}

function unsetProxy() {
    echo "取消代理..."
    unset http_proxy
    unset https_proxy
    sudo rm /etc/systemd/system/containerd.service.d/http-proxy.conf
    sudo systemctl daemon-reload
    sudo systemctl restart containerd
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
