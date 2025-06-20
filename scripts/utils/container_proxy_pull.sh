#!/bin/bash

set -e
set -o pipefail

export RUNTIME=$1
export PROXY_IP=$2
export KEEP_PROXY=${3:-"false"}
export IMAGE_NAMES=(${@:4})

# 校验所有参数
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "❌ 错误: 前三个参数都不能为空"
    echo "💡 用法: $0 <运行时类型> <代理IP> <是否保持代理> [镜像1 镜像2...]"
    exit 1
fi

function validate_runtime() {
    if [[ "${RUNTIME}" != "docker" && "${RUNTIME}" != "containerd" ]]; then
        echo "❌ 错误: 容器运行时必须是 'docker' 或 'containerd'"
        exit 1
    fi
}

function setProxy() {
    echo "🔧 设置代理..."
    export http_proxy=http://${PROXY_IP}
    export https_proxy=http://${PROXY_IP}

    if [ "${RUNTIME}" == "containerd" ]; then
        sudo mkdir -p /etc/systemd/system/containerd.service.d
        cat <<EOF | sudo tee /etc/systemd/system/containerd.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://${PROXY_IP}"
Environment="HTTPS_PROXY=http://${PROXY_IP}"
Environment="NO_PROXY=127.0.0.1,localhost,10.96.0.0/12,10.244.0.0/16"
EOF
        sudo systemctl daemon-reload
        sudo systemctl restart containerd
        echo "✅ containerd代理设置完成"
    else
        sudo mkdir -p /etc/systemd/system/docker.service.d
        cat <<EOF | sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://${PROXY_IP}"
Environment="HTTPS_PROXY=http://${PROXY_IP}"
Environment="NO_PROXY=127.0.0.1,localhost,10.96.0.0/12,10.244.0.0/16"
EOF
        sudo systemctl daemon-reload
        sudo systemctl restart docker
        echo "✅ docker代理设置完成"
    fi
}

function unsetProxy() {
    if [ "${KEEP_PROXY}" == "true" ]; then
        echo "🔒 保持代理设置..."
        return
    fi
    
    echo "🔧 取消代理..."
    unset http_proxy
    unset https_proxy
    
    if [ "${RUNTIME}" == "containerd" ]; then
        sudo rm -f /etc/systemd/system/containerd.service.d/http-proxy.conf
        sudo systemctl daemon-reload
        sudo systemctl restart containerd
        echo "✅ containerd代理已取消"
    else
        sudo rm -f /etc/systemd/system/docker.service.d/http-proxy.conf
        sudo systemctl daemon-reload
        sudo systemctl restart docker
        echo "✅ docker代理已取消"
    fi
}

function pullImage() {
    validate_runtime
    setProxy
    
    # 如果没有传递镜像参数，则只设置代理后退出
    if [ ${#IMAGE_NAMES[@]} -eq 0 ]; then
        echo "ℹ️ 未指定镜像，仅设置代理"
        if [ "${KEEP_PROXY}" == "false" ]; then
            unsetProxy
        fi
        exit 0
    fi
    
    echo "🚀 开始拉取镜像..."
    for image in "${IMAGE_NAMES[@]}"; do
        echo "📦 正在拉取镜像: ${image}"
        if [ "${RUNTIME}" == "containerd" ]; then
            sudo crictl pull ${image}
        else
            sudo docker pull ${image}
        fi
        echo "✨ 镜像 ${image} 拉取成功"
    done
    unsetProxy
    echo "🎉 所有镜像已完成拉取！"
}

pullImage
