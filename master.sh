#!/bin/bash
echo "Install Jenkins...."
sudo apt-get update 
sudo apt install apt-transport-https ca-certificates curl software-properties-common wget openjdk-11-jdk -y
sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins

sudo cat /var/lib/jenkins/secrets/initialAdminPassword > /home/passwordjenkins.txt
echo "Disabling swap & remove unattended upgrades...."
sudo swapoff -a
sudo sed -i.bak '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo apt remove unattended-upgrades -y
echo "Installing necessary dependencies...."
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
echo "Setting up hostname...."
sudo hostnamectl set-hostname "k8s-master"
PUBLIC_IP_ADDRESS=`hostname -I|cut -d" " -f 1`
sudo echo "${PUBLIC_IP_ADDRESS}  k8s-master" >> /etc/hosts
  
echo "Installing Docker...."
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
### Add Docker apt repository.
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

## Install Docker CE.
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io make git wget -y

# Restart docker.
sudo usermod -aG docker ubuntu && newgrp docker
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
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
sudo apt install kubeadm -y
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
sudo sleep 180

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo "Installing Flannel..."
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
echo "Kubernetes Installation finished..."
echo "Waiting 30 seconds for the cluster to go online..."
sudo sleep 60
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
sudo export KUBECONFIG=$HOME/.kube/config
echo "Testing Kubernetes namespaces... "
kubectl get pods --all-namespaces
echo "Testing Kubernetes nodes... "
kubectl get nodes
echo "All ok ;)"
kubeadm token create --print-join-command > /home/ubuntu/token.txt
echo "Git clone gitub.com/github-ragil/go-trivia"
sudo git clone https://github.com/github-ragil/go-trivia.git
sudo su
sudo echo 'jenkins ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers
sudo echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers