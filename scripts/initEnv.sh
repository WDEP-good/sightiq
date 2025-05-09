#!/bin/bash

echo "初始化脚本开始执行..."



CRI_CONFIG_PATH="/etc/crictl.yaml"
CONTAINERD_SOCKET="/run/containerd/containerd.sock"

function InitDocker() {
    if ! command -v docker &>/dev/null; then
        echo "Docker 未安装，正在安装 Docker..."
        for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
            sudo apt-get remove -y $pkg
        done
        sudo apt-get update
        sudo apt-get install -y ca-certificates curl gnupg lsb-release
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
            $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    else
        echo "Docker 已安装"
    fi
}

function InitK8s() {
    if ! command -v kubectl &>/dev/null; then
        echo "Kubernetes 未安装，正在安装 Kubernetes..."
        sudo swapoff -a
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates curl gpg
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
        echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
        sudo apt-get update
        sudo apt-get install -y kubelet kubeadm kubectl
        sudo apt-mark hold kubelet kubeadm kubectl
    else
        echo "Kubernetes 已安装"
    fi
}

function InitContainerd() {
    echo "初始化 containerd..."

    if ! command -v containerd &>/dev/null; then
        echo "containerd 未安装，正在安装..."
        sudo apt-get update
        sudo apt-get install -y containerd
    fi

    echo "生成默认配置（如果不存在）..."
    sudo mkdir -p /etc/containerd
    if [ ! -f "/etc/containerd/config.toml" ]; then
        containerd config default | sudo tee /etc/containerd/config.toml
    fi

    echo "启用 CRI 插件（如果被禁用）..."
    sudo sed -i 's/disabled_plugins = \[.*"cri".*\]/# disabled_plugins = []/g' /etc/containerd/config.toml

    echo "重启 containerd 服务..."
    sudo systemctl daemon-reexec
    sudo systemctl restart containerd
    sudo systemctl enable containerd

    echo "写入 crictl 配置..."
    sudo tee "$CRI_CONFIG_PATH" > /dev/null <<EOF
runtime-endpoint: unix://$CONTAINERD_SOCKET
image-endpoint: unix://$CONTAINERD_SOCKET
timeout: 10
debug: false
EOF
}

function start_project() {
    echo "启动项目..."

    if ! pgrep -x "containerd" > /dev/null; then
        echo "❌ containerd 未运行，请检查日志："
        sudo journalctl -u containerd --no-pager | tail -20
        exit 1
    fi

    echo "✅ containerd 正在运行，尝试使用 crictl..."
    sudo crictl images || echo "crictl 命令执行失败，请确认配置是否正确。"
}

# 主流程执行
InitDocker
InitK8s
InitContainerd
start_project
