#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function startStarrocks() {
    echo "开始启动StarRocks..."
    echo "开始部署 StarRocks Cluster CRD"
    kubectl apply -f $SIGHTIQ_ROOT/k8s/starrocks/starrocks_clusters.yaml
    echo "StarRocks Cluster CRD 权限绑定"
    kubectl create clusterrolebinding starrocks-operator-admin --clusterrole=cluster-admin --serviceaccount=starrocks:default
    echo "开始部署 StarRocks Operator"
    kubectl apply -f $SIGHTIQ_ROOT/k8s/starrocks/starrocks_operator.yaml
    echo "开始部署 StarRocks FE 和 BE"
    kubectl apply -f $SIGHTIQ_ROOT/k8s/starrocks/starrocks_fe_and_be.yaml
    echo "StarRocks启动成功"
}

startStarrocks