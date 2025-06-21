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
    bash start_k8s.sh
}

function redis() {
    bash start_redis.sh
}

function starrocks() {
    bash start_starrocks.sh --proxy-ip ${PROXY_IP} --runtime ${RUNTIME}
}

function start_sightiq() {
    echo "开始启动SightIQ..."
    echo "使用的配置："
    echo "PROXY_IP: ${PROXY_IP}"
    echo "RUNTIME: ${RUNTIME}"
    init_env
    k8s
    redis
    starrocks
}

start_sightiq
