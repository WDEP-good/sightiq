#!/bin/bash


export PROXY_IP=$1
export IMAGE_NAME=$2

function setProxy() {
    echo "设置代理..."
    export http_proxy=http://${PROXY_IP}
    export https_proxy=http://${PROXY_IP}

    sudo mkdir -p /etc/systemd/system/containerd.service.d
    cat <<EOF | sudo tee /etc/systemd/system/containerd.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://${PROXY_IP}"
Environment="HTTPS_PROXY=http://${PROXY_IP}"
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

function pullImage() {
    setProxy
    echo "拉取镜像..."
    sudo crictl pull ${IMAGE_NAME}
    unsetProxy
}


pullImage