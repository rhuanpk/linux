#!/bin/bash

# parametros:
#
#		1 - nome git
#		2 - e-mail git

echo
echo "======================ATUALIZANDO======================"
echo

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

apt install google-chrome-stable -y ;

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

apt install discord -y ;

echo
echo "======================FILEZILLA======================"
echo

apt install filezilla -y ;

echo
echo "======================LIMPAR======================"
echo

apt full-upgrade -y ;

echo "---switch---"

apt clean -y ;
apt autoclean -y ;
apt autoremove -y

echo
echo "============================================"
echo
