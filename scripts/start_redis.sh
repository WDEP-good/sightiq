#!/bin/bash

function startRedis() {
    echo "开始启动Redis..."
    kubectl apply -f $SIGHTIQ_ROOT/k8s/redis/redis.yaml
    echo "Redis启动成功"
}

startRedis