k8s 1.27 is no longer maintained, so it's gpg signature expired:
# echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.27/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
# curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.27/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
=>
echo "deb [trusted=yes] https://pkgs.k8s.io/core:/stable:/v1.27/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
