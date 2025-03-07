#!/bin/bash

 # vagrant may issue locales error in some systems like: 
 # dpkg-reconfigure: unable to re-open stdin: No file or directory
 # uncomment lines below to set locales manually
 # echo -e "\n\n=======Setting up locales started!========"
 # export LANGUAGE=en_US.UTF-8
 # export LANG=en_US.UTF-8
 # export LC_ALL=en_US.UTF-8
 # locale-gen en_US.UTF-8
 # dpkg-reconfigure locales
 # echo "======Setting up locales finished!========="

 # disabling SWAP (файл подкачки) file, Kubernetes requires it for stable work
echo -e "\n\n==========Swap disabling started!=========="
sudo swapoff -a  
sudo sed -i '/ swap / s/^/#/' /etc/fstab
echo "===============Swap disabled!=============="
 # openning ports for k8s master node installation
echo  -e "\n\n==========Ports opening started!==========="
iptables -I INPUT 1 -p tcp --match multiport --dports 6443,2379:2380,10250,10259,10257 -j ACCEPT
echo "================Ports opened!==============="

 # forwarding IPv4 and letting iptables see bridged traffic for Kubernetes container runtimes
echo  -e "\n\n==========Forwarding IPv4 started!==========="
#????????
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
#???????
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system
echo "================Forwarding IPv4 finished!==============="

 # setting up hostnames nodes
echo  -e "\n\n======Hostnames setting up started======="
sudo echo -e "\n172.16.0.1 master">>/etc/hosts
sudo echo -e "\n172.16.0.11 worker1">>/etc/hosts
sudo echo -e "\n172.16.0.12 worker2">>/etc/hosts
sudo systemctl restart systemd-hostnamed
echo "======Hostnames setting up finished======"
 # installing Docker as Container Runtimes for Kubernetes + cri-dockerd
 # Docker Engine installation guide: 
 # https://docs.docker.com/engine/install/
echo  -e "\n\n=======Docker installation started!========"
sudo apt-get update
sudo apt-get install -y ca-certificates curl apt-transport-https
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
wget -q https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.16/cri-dockerd_0.3.16.3-0.ubuntu-jammy_amd64.deb
sudo dpkg -i cri-dockerd_0.3.16.3-0.ubuntu-jammy_amd64.deb
sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
systemctl daemon-reload
systemctl enable --now cri-docker.socket
echo "=========Docker installed finished!========="
 # kubeadm installation for Debian-based Linux
echo  -e "\n\n=====Kubernetes installation started!======"
sudo apt-get update
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
 
 # fix error
 # curl -sSL http://localhost:10248/healthz' failed with error:
 # Get http://localhost:10248/healthz: dial tcp [::1]:10248: connect: connection refused
sudo mkdir -p /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
"exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl restart kubelet
sudo kubeadm init --apiserver-advertise-address=172.16.0.1 --cri-socket=unix:///var/run/cri-dockerd.sock --pod-network-cidr=10.244.0.0/16


echo -e "\n\n=========Configuring k8s to be accesible without root for vagrant user========="
mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config
echo "========= K8s configured!========="


echo -e "\n\n=========Networking plugin installation started========="
wget -q https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
 # changed --iface=enp0s8  for vagrant 
sed -i '/- --kube-subnet-mgr/a\        - --iface=enp0s8' kube-flannel.yml
kubectl apply -f kube-flannel.yml
sleep 5
echo "=========Networking plugin installed!========="

echo -e "\n\n=========Pinging hosts to enshure connection========="
ping worker1 -c 5
ping worker2 -c 5
echo "=========Pinging done!========="
# kubeadm join 172.16.0.1:6443 --token he53na.ys7q5gs76qi4aak1 --discovery-token-ca-cert-hash sha256:08619a91aec3d94ecf164f4d8fd449ef0240a25c3225762745dcf092605deeaa --cri-socket unix:///var/run/cri-dockerd.sock