#!/bin/bash

set -e
set -o pipefail

# 初始化变量
RUNTIME="containerd"
PROXY_IP=""
KEEP_PROXY="false"
declare -a IMAGE_NAMES

# 显示使用方法
function show_usage() {
    echo "💡 用法: $0 -r|--runtime <运行时类型> [-p|--proxy <代理IP>] [-k] <镜像1> [镜像2...]"
    echo "选项:"
    echo "  -r, --runtime      指定运行时类型 (docker 或 containerd)"
    echo "  -p, --proxy        可选: 指定代理服务器IP"
    echo "  -k                 可选: 拉取完成后保持代理设置（不需要值）"
    exit 1
}

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -r|--runtime)
            if [ -z "$2" ] || [[ "$2" == -* ]]; then
                echo "❌ 错误: -r|--runtime 选项需要一个值"
                show_usage
            fi
            RUNTIME="$2"
            shift 2
            ;;
        -p|--proxy)
            if [ -z "$2" ] || [[ "$2" == -* ]]; then
                echo "❌ 错误: -p|--proxy 选项需要一个值"
                show_usage
            fi
            PROXY_IP="$2"
            shift 2
            ;;
        -k)
            KEEP_PROXY="true"
            shift
            ;;
        -h|--help)
            show_usage
            ;;
        -*)
            echo "❌ 错误: 未知选项 $1"
            show_usage
            ;;
        *)
            IMAGE_NAMES+=("$1")
            shift
            ;;
    esac
done

# 验证必需参数
if [ -z "$RUNTIME" ]; then
    echo "❌ 错误: 必须指定运行时类型"
    show_usage
fi

function validate_runtime() {
    if [[ "${RUNTIME}" != "docker" && "${RUNTIME}" != "containerd" ]]; then
        echo "❌ 错误: 容器运行时必须是 'docker' 或 'containerd'"
        exit 1
    fi
}

function setProxy() {
    # 如果没有设置代理IP，则跳过代理设置
    if [ -z "${PROXY_IP}" ]; then
        echo "ℹ️ 未设置代理IP，将直接拉取镜像"
        return
    fi

    echo "🔧 设置代理..."
    export http_proxy=http://${PROXY_IP}
    export https_proxy=http://${PROXY_IP}

    if [ "${RUNTIME}" == "containerd" ]; then
        sudo mkdir -p /etc/systemd/system/containerd.service.d
        cat <<EOF | sudo tee /etc/systemd/system/containerd.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://${PROXY_IP}"
Environment="HTTPS_PROXY=http://${PROXY_IP}"
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
EOF
        sudo systemctl daemon-reload
        sudo systemctl restart docker
        echo "✅ docker代理设置完成"
    fi
}

function unsetProxy() {
    # 如果没有设置代理IP，则无需取消代理
    if [ -z "${PROXY_IP}" ]; then
        return
    fi

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
        if [ -n "${PROXY_IP}" ]; then
            echo "ℹ️ 未指定镜像，仅设置代理"
            if [ "${KEEP_PROXY}" == "false" ]; then
                unsetProxy
            fi
        else
            echo "❌ 错误: 必须指定至少一个镜像"
            show_usage
        fi
        exit 1
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
