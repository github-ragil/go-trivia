#!/bin/bash

echo "Disabling swap...."
sudo swapoff -a
sudo sed -i.bak '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
echo "Installing necessary dependencies...."
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
echo "Setting up hostname...."
sudo hostnamectl set-hostname "k8s-worker1"
PUBLIC_IP_ADDRESS=`hostname -I|cut -d" " -f 1`
sudo echo "${PUBLIC_IP_ADDRESS}  k8s-worker1" >> /etc/hosts
echo "Removing existing Docker Installation...."
sudo apt-get purge aufs-tools docker-ce docker-ce-cli containerd.io pigz cgroupfs-mount -y
sudo apt-get purge kubeadm kubernetes-cni -y
sudo rm -rf /etc/kubernetes
sudo rm -rf $HOME/.kube/config
sudo rm -rf /var/lib/etcd
sudo rm -rf /var/lib/docker
sudo rm -rf /opt/containerd
sudo rm /etc/containerd/config.toml
sudo apt autoremove -y
  
echo "Installing Docker...."
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
### Add Docker apt repository.
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

## Install Docker CE.
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io make git wget -y

# Setup daemon.

sudo mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
sudo usermod -aG docker ubuntu && newgrp docker
sudo systemctl daemon-reload
sudo systemctl restart docker
echo "Install Helm"
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo bash get_helm.sh

sudo modprobe br_netfilter
sudo sysctl net.bridge.bridge-nf-call-iptables=1
sudo sysctl -p

echo "Setting up Kubernetes Package Repository..."
sudo apt-get install apt-transport-https curl -y 
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add 
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
echo "Installing Kubernetes..."
sudo apt install kubeadm -y