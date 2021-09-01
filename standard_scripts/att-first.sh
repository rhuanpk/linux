#!/usr/bin/env bash

apt update -y ;
apt upgrade -y ;
apt dist-upgrade -y ;

apt-get update -y ;
apt-get upgrade -y ;
apt-get dist-upgrade -y ;

apt full-upgrade -y ;

ubuntu-drivers autoinstall ;
apt install ubuntu-restricted-extras -y
