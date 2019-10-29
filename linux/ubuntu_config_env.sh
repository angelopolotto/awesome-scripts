#!/bin/bash

##########################
# script para instalar os softwares necessários
# para desenvolvimento para Ubuntu
##########################

# exige o super usuário
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

# configura proxy
chmod +x ./ubuntu_set_proxy.sh
./ubuntu_set_proxy.sh

# update apt
apt -y update

# upgrade apt
apt -y upgrade

# gparted
apt -y install gparted

# git
apt -y install git

# docker
apt -y install docker.io

# python pip3
apt -y install python3-pip

# postman
snap install postman

# intellij ultimate
snap install --classic intellij-idea-ultimate

# vs code
snap install --classic code

# android studio
snap install --classic android-studio

# github desktop
snap install --beta --classic github-desktop
