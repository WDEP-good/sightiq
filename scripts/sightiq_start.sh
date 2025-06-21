#!/bin/bash

PROXY_IP=""
RUNTIME="containerd"

export SIGHTIQ_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SIGHTIQ_ROOT="$(cd "$SIGHTIQ_SCRIPT_DIR/.." && pwd)"

while [[ $# -gt 0 ]]; do
    case $1 in
    --proxy-ip | -p)
        PROXY_IP="$2"
        shift 2
        ;;
    --runtime | -r)
        RUNTIME="$2"
        shift 2
        ;;
    --help | -h)
        echo "📚 用法: $0 [选项]"
        echo "选项:"
        echo "  -p, --proxy-ip <IP地址>    设置代理IP地址"
        echo "  -r, --runtime <类型>       设置运行时类型"
        echo "  -h, --help                显示此帮助信息"
        exit 0
        ;;
    *)
        echo "❌ 错误: 未知参数 $1"
        echo "💡 使用 -h 或 --help 查看帮助信息"
        exit 1
        ;;
    esac
done

function init_env() {
    echo "🔧 正在初始化环境..."
    bash init_env.sh
    echo "✅ 环境初始化完成"
}

function k8s() {
    echo "🚀 正在启动Kubernetes集群..."
    bash $SIGHTIQ_SCRIPT_DIR/sightiq_k8s_master.sh -p ${PROXY_IP} -r ${RUNTIME}

    echo "🔄 正在生成子节点加入命令..."
    JOIN_CMD=$(kubeadm token create --print-join-command)
    echo "✨ 子节点加入命令已生成"
    echo "📝 请在子节点上运行以下命令加入集群："
    echo "================================================================="
    echo "${JOIN_CMD}"
    echo "================================================================="

    # 等待用户确认是否已完成加入
    while true; do
        read -p "❓ 子节点是否已经完成加入？(y/yes): " yn
        case $yn in
        [Yy] | [Yy][Ee][Ss])
            echo "✅ 子节点加入完成！"
            break
            ;;
        *)
            echo "⚠️  请在子节点完成加入后输入 y/yes"
            ;;
        esac
    done
    echo "📊 节点资源大小(请根据节点资源大小调整StarRocks集群配置)"
    kubectl get nodes -o jsonpath="{range .items[*]}{.metadata.name} {.status.allocatable.cpu} {.status.allocatable.memory}{'\n'}{end}" | awk '{
    node=$1
    cpu=$2
    mem=$3
    if (mem ~ /Ki$/) {
        sub(/Ki$/, "", mem)
        memGi = sprintf("%.2f", mem / 1024 / 1024)
    } else if (mem ~ /Mi$/) {
        sub(/Mi$/, "", mem)
        memGi = sprintf("%.2f", mem / 1024)
    } else if (mem ~ /Gi$/) {
        sub(/Gi$/, "", mem)
        memGi = sprintf("%.2f", mem)
    } else {
        memGi = "?"
    }
    printf "节点: %-12s CPU: %-4s 核  内存: %-6s Gi\n", node, cpu, memGi
    }'
    echo "✅ Kubernetes集群配置完成！"
}

function redis() {
    echo "🔄 正在启动Redis..."
    bash start_redis.sh
    echo "✅ Redis启动完成"
}

function starrocks() {
    echo "🔄 正在启动StarRocks..."
    bash start_starrocks.sh
    echo "✅ StarRocks启动完成"
}

function start_sightiq() {
    echo "🚀 开始启动SightIQ..."
    init_env
    k8s
    redis
    starrocks
    echo "🎉 SightIQ启动完成！"
}

start_sightiq
