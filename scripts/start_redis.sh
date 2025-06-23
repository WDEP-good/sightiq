#!/bin/bash

function startRedis() {
    echo "开始启动Redis..."
    bash $SIGHTIQ_SCRIPT_DIR/utils/container_proxy_pull.sh -r ${RUNTIME} -p ${PROXY_IP} -k docker.io/redis:latest
    kubectl apply -f $SIGHTIQ_ROOT/k8s/redis/redis.yaml
    echo "Redis启动成功"
}

startRedis