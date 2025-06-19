#!/bin/bash

echo "开始启动项目..."

export PROXY_IP=${1:-}  # 允许空代理设置

function setProxy() {
    # 关闭swap分区
    sudo swapoff -a
    echo "设置代理..."
    export http_proxy=http://${PROXY_IP}
    export https_proxy=http://${PROXY_IP}

    sudo mkdir -p /etc/systemd/system/containerd.service.d
    cat <<EOF | sudo tee /etc/systemd/system/containerd.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://${PROXY_IP}"
Environment="HTTPS_PROXY=http://${PROXY_IP}"
Environment="NO_PROXY=127.0.0.1,localhost,10.96.0.0/12,10.244.0.0/16"
EOF
    sudo systemctl daemon-reload
    sudo systemctl restart containerd

}

function unsetProxy() {
    echo "取消代理..."
    unset http_proxy
    unset https_proxy
    sudo rm /etc/systemd/system/containerd.service.d/http-proxy.conf
    sudo systemctl daemon-reload
    sudo systemctl restart containerd
}

function starrK8s() {
    # 检查时间
    date
    sudo timedatectl set-ntp true
    echo 'KUBELET_KUBEADM_ARGS=""' > /var/lib/kubelet/kubeadm-flags.env
    kubectl delete pvc --all --all-namespaces
    kubectl delete pv --all
    kubectl delete ns starrocks local-path-storage
    sudo ip link delete cni0
    sudo ip link delete flannel.1
    sudo kubeadm reset -f
    sudo systemctl stop kubelet
    sudo rm -rf /etc/kubernetes/*
    sudo rm -rf /var/lib/etcd
    sudo rm -rf ~/.kube
    echo "开始启动 Kubernetes 集群..."
    setProxy
    sudo kubeadm config images pull --config=init-config.yaml --v=5
    sudo crictl pull ghcr.io/flannel-io/flannel:v0.27.0
    sudo crictl pull ghcr.io/flannel-io/flannel-cni-plugin:v1.7.1-flannel1
    sudo crictl pull docker.io/flannel/flannel-cni-plugin:v1.1.2
    sudo crictl pull docker.io/flannel/flannel-cni-plugin:v1.1.2
    unsetProxy
    echo "初始化集群..."
    export MASTER_IP=192.168.10.140
    sudo kubeadm init --config init-config.yaml --v=5
    echo "配置 kubectl..."
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    # 禁用 CoreDNS 的内存限制
    kubectl patch deployment -n kube-system coredns -p '{"spec":{"template":{"spec":{"containers":[{"name":"coredns","resources":null}]}}}}'
    kubectl apply -f kube-flannel.yaml
    kubectl rollout status -n kube-system daemonset/kube-flannel --timeout=120s
    # 创建默认PVC
    kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
    kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
}

starrK8s
 