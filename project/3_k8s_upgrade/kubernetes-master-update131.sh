#!/bin/bash

 # $HOSTNAME - node name
 # CNI flannel doesnt require any upgrade from 1.30 to 1.32

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg --yes
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm='1.31.*' && \
sudo apt-mark hold kubeadm
sudo kubeadm upgrade plan
sudo killall -s SIGTERM kube-apiserver # trigger a graceful kube-apiserver shutdown
sleep 40 # wait a little bit to permit completing in-flight requests
sudo kubeadm upgrade apply v1.31.* --yes
kubectl drain $HOSTNAME --ignore-daemonsets
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet='1.28.11-*' kubectl='1.28.11-*' && \
sudo apt-mark hold kubelet kubectl
sudo systemctl daemon-reload
sudo systemctl restart kubelet
kubectl uncordon $HOSTNAME
 # DO NOT DRAIN ALL NODES AT ONCE!!!!!!
kubectl drain worker1 --ignore-daemonsets
kubectl drain worker2 --ignore-daemonsets
 # execute after updating node
#kubectl uncordon worker1
#kubectl uncordon worker2
