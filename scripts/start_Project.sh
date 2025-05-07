#! /bin/bash


CRI_CONFIG_PATH="/etc/crictl.yaml"
CONTAINERD_SOCKET="/run/containerd/containerd.sock"




function InitDocker() {
    if ! command -v docker &>/dev/null; then
        echo "Docker 未安装，正在安装 Docker..."
        # 卸载所有冲突的软件包
        for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
        # 添加docker仓库 GPG key:
        sudo apt-get update
        sudo apt-get install ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
        # 添加docker仓库到apt源:
        echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
            sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
        sudo apt-get update
        # 安装docker
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    else
        echo "Docker 已安装"
    fi
}

function InitK8s() {
    if ! command -v kubectl &>/dev/null; then
        echo "Kubernetes 未安装，正在安装 Kubernetes..."
        # 关闭swap
        sudo swapoff -a
        # 安装kubeadm
        echo "安装kubeadm"
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates curl gpg
        curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
        echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
        sudo apt-get update
        sudo apt-get install -y kubelet kubeadm kubectl
        sudo apt-mark hold kubelet kubeadm kubectl
    else
        echo "Kubernetes 已安装"
    fi
}

function InitContainerd() {
    echo "初始化containerd"
    if [ ! -f "$CRI_CONFIG_PATH" ]; then
        echo "配置文件不存在，正在添加配置..."
        sudo tee "$CRI_CONFIG_PATH" >/dev/null <<EOF
runtime-endpoint: unix://$CONTAINERD_SOCKET
image-endpoint: unix://$CONTAINERD_SOCKET
timeout: 10
debug: true
EOF
    else
        echo "containerd配置文件已存在，跳过配置"
    fi
}

function start_project() {
    echo "Starting project..."
}

InitDocker
InitK8s
InitContainerd
start_project
