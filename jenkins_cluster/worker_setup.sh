#!/bin/bash
sudo apt update -y
sudo apt install openjdk-17-jdk -y
sudo useradd jenkins -s /bin/bash
sudo mkdir -p /home/jenkins
sudo chown -R jenkins:jenkins /home/jenkins
sudo timedatectl set-timezone Asia/Kolkata