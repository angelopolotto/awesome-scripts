#!/bin/bash

# Sources
# https://virtualboxes.org/doc/installing-guest-additions-on-ubuntu/
# https://superuser.com/questions/1318231/why-doesnt-clipboard-sharing-work-with-ubuntu-18-04-lts-inside-virtualbox-5-1-2

# update packages
sudo apt-get update
sudo apt-get upgrade

# install packages for VBox
sudo apt install linux-headers-$(uname -r) dkms
sudo apt-get install virtualbox-guest-x11
sudo apt-get install build-essential module-assistant

# install kernel headers for VBox
sudo m-a prepare

# install VBox addtions from cd-rom
sudo sh /media/lubuntu/VBox_GAs_6.0.4/VBoxLinuxAdditions.run

# enable clipboard and drag-n-drop sharing content with the host
sudo VBoxClient --clipboard
sudo VBoxClient --draganddrop
