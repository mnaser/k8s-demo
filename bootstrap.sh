#!/bin/bash

# add deps
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# install k8s
sudo apt update
sudo apt -y install docker.io=17.12.1-0ubuntu1 \
                    kubelet=1.10.2-00 \
		    kubeadm=1.10.2-00 \
		    kubectl=1.10.2-00 \
		    python-openstackclient

# prepull images
docker pull mysql:5.6 &
docker pull k8s.gcr.io/kube-apiserver-$(dpkg --print-architecture):v1.10.2 &
docker pull k8s.gcr.io/kube-scheduler-$(dpkg --print-architecture):v1.10.2 &
docker pull k8s.gcr.io/kube-controller-manager-$(dpkg --print-architecture):v1.10.2 &
docker pull k8s.gcr.io/kube-proxy-$(dpkg --print-architecture):v1.10.2 &
docker pull weaveworks/weave-npc:2.3.0 &
docker pull weaveworks/weave-kube:2.3.0 &
docker pull k8s.gcr.io/etcd-$(dpkg --print-architecture):3.1.12 &
docker pull k8s.gcr.io/k8s-dns-dnsmasq-nanny-$(dpkg --print-architecture):1.14.8 &
docker pull k8s.gcr.io/k8s-dns-sidecar-$(dpkg --print-architecture):1.14.8 &
docker pull k8s.gcr.io/k8s-dns-kube-dns-$(dpkg --print-architecture):1.14.8 &
docker pull k8s.gcr.io/pause-$(dpkg --print-architecture):3.1 &
docker pull wordpress:4.9.5-apache &
