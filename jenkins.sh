#!/bin/bash
sudo apt-get update 
sudo apt install apt-transport-https ca-certificates curl software-properties-common wget openjdk-11-jdk -y
sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo echo 'jenkins ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers
sudo cat /var/lib/jenkins/secrets/initialAdminPassword > /home/passwordjenkins.txt