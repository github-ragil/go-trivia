#!/bin/bash

echo  " _   _ _                 _                    _ _   _       _    ___       "
echo  "| | | | |__  _   _ _ __ | |_ _   _  __      _(_) |_| |__   | | _( _ ) ___  "
echo  "| | | | '_ \| | | | '_ \| __| | | | \ \ /\ / / | __| '_ \  | |/ / _ \/ __| "
echo  "| |_| | |_) | |_| | | | | |_| |_| |  \ V  V /| | |_| | | | |   < (_) \__ \ "
echo  " \___/|_.__/ \__,_|_| |_|\__|\__,_|   \_/\_/ |_|\__|_| |_| |_|\_\___/|___/ "

echo                                                     

echo  "__        __         _               _   _           _       "
echo  "\ \      / /__  _ __| | _____ _ __  | \ | | ___   __| | ___  "
echo  " \ \ /\ / / _ \| '__| |/ / _ \ '__| |  \| |/ _ \ / _\` |/ _ \ "
echo  "  \ V  V / (_) | |  |   <  __/ |    | |\  | (_) | (_| |  __/ "
echo  "   \_/\_/ \___/|_|  |_|\_\___|_|    |_| \_|\___/ \__,_|\___| "


sleep 5

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

echo 
echo "****  Config node worker with k8s and Docker *****"
echo 

echo 
echo "**** update repository package ****"
echo 

apt-get update

echo 
echo "**** disable swap ****"
echo 

swapoff -a
cp /etc/fstab /etc/fstab.bkp
sed -i.bak '/ swap / s/^\(.*\)$/#/g' /etc/fstab

echo 
echo "**** install docker ****"
echo 

curl -fsSL https://get.docker.com | bash

echo 
echo "**** config deamon cgroup ****"
echo 

echo '{"exec-opts": ["native.cgroupdriver=systemd"],"log-driver": "json-file","log-opts": {"max-size": "100m"},"storage-driver": "overlay2"}' > /etc/docker/daemon.json

mkdir -p /etc/systemd/system/docker.service.d

systemctl daemon-reload
systemctl restart docker

echo 
echo "**** install repository packages kubernetes ****"
echo 

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/k8s.list

echo 
echo "**** update repository package ****"
echo 

apt-get update

echo 
echo "**** install kubectl, kubeadm and kubelet ****"
echo 

apt-get -y install kubectl
apt-get -y install kubeadm 
apt-get -y install kubelet

echo 
echo "**** autocompletion kubectl ****"
echo 

echo "source <(kubectl completion bash)" >> $HOME/.bashrc

echo "finish install"