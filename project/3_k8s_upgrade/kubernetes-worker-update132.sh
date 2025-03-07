#!/bin/bash

#$HOSTNAME - node name

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg --yes
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo NEEDRESTART_MODE=a apt-get install -y kubeadm='1.32*' && \
sudo apt-mark hold kubeadm
sudo kubeadm upgrade node
#kubectl drain $HOSTNAME --ignore-daemonsets
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo NEEDRESTART_MODE=a apt-get install -y kubelet='1.32*' kubectl='1.32*' && \
sudo apt-mark hold kubelet kubectl
sudo systemctl daemon-reload
sudo systemctl restart kubelet
#kubectl uncordon $HOSTNAME
