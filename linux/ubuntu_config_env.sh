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

# gnome tweaks
apt -y install gnome-tweaks

# git
apt -y install git

# docker
apt -y install docker.io

# python 3
apt -y install python3

# python pip3
apt -y install python3-pip

# configure python3 as default
echo "
alias python=python3
alias pip=pip3
" >> ~/.bash_aliases

# java
# https://www.digitalocean.com/community/tutorials/como-instalar-o-java-com-apt-no-ubuntu-18-04-pt
apt -y install default-jre

# maven
apt -y install maven

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

# install codecs
# https://websiteforstudents.com/how-to-install-video-audio-codecs-on-ubuntu-18-10-18-04-16-04-lts/
apt -y install libdvdnav4 libdvdread4 gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly libdvd-pkg
apt -y install ubuntu-restricted-extras
