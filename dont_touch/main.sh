#!/bin/bash

# parametros:
#
#		1 - nome git
#		2 - e-mail git

echo
echo "======================ATUALIZANDO======================"
echo

apt update -y ;
apt upgrade -y ;
apt full-upgrade -y ;

echo "---switch---"

ubuntu-drivers autoinstall ;
apt install ubuntu-restricted-extras -y ;

echo
echo "======================NPM======================"
echo

apt install npm -y ;

echo
echo "======================GIT======================"
echo

apt install git -y ;

echo "---switch---"

git --version ;

echo "---switch---"

git config --global user.name "$1" ;
git config --global user.email "$2" ;

echo "---switch---"

git config --list ;

echo
echo "======================CHROME======================"
echo

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb ;
dpkg -i ./google-chrome-stable_current_amd64.deb ;

echo
echo "======================SNAP======================"
echo

apt install snapd -y ;

echo
echo "======================VS-CODE======================"
echo

snap install code --classic ;
snap refresh code ;

echo
echo "======================DISCORD======================"
echo

snap install discord ;
snap refresh discord ;

echo
echo "======================FILEZILLA======================"
echo

apt install filezilla -y ;

echo
echo "======================ANYDESK======================"
echo

wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | apt-key add - ;
echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list ;
apt update -y ;
apt install anydesk -y ;

echo
echo "======================LIMPAR======================"
echo

apt install -f ;
apt --fix-broken install ;

echo "---switch---"

apt full-upgrade -y ;

echo "---switch---"

apt clean -y ;
apt autoclean -y ;
apt autoremove -y

echo
echo "======================Version 0.0.3======================"
echo
echo
echo "A simple solution ..."
echo
echo "Created by: Crazy Group Inc © (CG)"
echo
echo
echo "=========================================================="
