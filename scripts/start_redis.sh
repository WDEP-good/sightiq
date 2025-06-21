#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function startRedis() {
    echo "开始启动Redis..."
    kubectl apply -f ${SCRIPT_DIR}/k8s/redis/redis.yaml
    echo "Redis启动成功"
}

startRedis