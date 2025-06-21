#!/bin/bash

PROXY_IP=""
RUNTIME="containerd"

while [[ $# -gt 0 ]]; do
    case $1 in
        --proxy-ip|-p)
            PROXY_IP="$2"
            shift 2
            ;;
        --runtime|-r)
            RUNTIME="$2"
            shift 2
            ;;
        --help|-h)
            echo "用法: $0 [选项]"
            echo "选项:"
            echo "  -p, --proxy-ip <IP地址>    设置代理IP地址"
            echo "  -r, --runtime <类型>       设置运行时类型"
            echo "  -h, --help                显示此帮助信息"
            exit 0
            ;;
        *)
            echo "错误: 未知参数 $1"
            echo "使用 -h 或 --help 查看帮助信息"
            exit 1
            ;;
    esac
done

function init_env() {
    bash init_env.sh
}

function k8s() {
    bash start_k8s.sh -p ${PROXY_IP} -r ${RUNTIME}
    
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
            [Yy]|[Yy][Ee][Ss])
                echo "✅ 子节点加入完成！"
                break
                ;;
            *)
                echo "⚠️  请在子节点完成加入后输入 y/yes"
                ;;
        esac
    done
}

function redis() {
    bash start_redis.sh
}

function starrocks() {
    bash start_starrocks.sh
}

function start_sightiq() {
    echo "开始启动SightIQ..."
    init_env
    k8s
    redis
    starrocks
}

start_sightiq
