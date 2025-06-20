#!/bin/bash



function startStarrocks() {
    echo "开始启动StarRocks..."
    echo "开始部署 StarRocks Cluster CRD"
    kubectl apply -f k8s/starrocks/starrocks_clusters.yaml
    echo "开始部署 StarRocks Operator"
    kubectl apply -f k8s/starrocks/starrocks_operator.yaml
    echo "开始部署 StarRocks FE 和 BE"
    kubectl apply -f k8s/starrocks/starrocks_fe_and_be.yaml
    echo "StarRocks启动成功"
}

startStarrocks