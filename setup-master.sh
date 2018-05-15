#!/bin/bash

# install k8s
sudo kubeadm init
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
# forget this: kubectl taint nodes --all node-role.kubernetes.io/master-

# config cloud provider
source ~/openrc
cat << EOF | sudo tee /etc/kubernetes/cloud-config
[Global]
domain-name = $OS_USER_DOMAIN_NAME
tenant-id = $OS_PROJECT_ID
auth-url = $OS_AUTH_URL
password = $OS_PASSWORD
username = $OS_USERNAME
region = $OS_REGION_NAME
[LoadBalancer]
use-octavia = true
floating-network-id = $(openstack network list --external -f value -c ID | head -n 1)
subnet-id = $(openstack network list --internal -f value -c Subnets | head -n 1)
[BlockStorage]
bs-version = v2
ignore-volume-az = yes
EOF

# config storageclass
cat << EOF | kubectl create -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: standard
  annotations:
    storageclass.beta.kubernetes.io/is-default-class: "true"
  labels:
    kubernetes.io/cluster-service: "true"
    addonmanager.kubernetes.io/mode: EnsureExists
provisioner: kubernetes.io/cinder
EOF
