#!/usr/bin/env bash

# Script que atualiza/conserta e limpa o sistema de uma única vez

# Atualizar
apt update -y
apt upgrade -y

ubuntu-drivers autoinstall
apt install ubuntu-restricted-extras -y

# Consertar
apt install -f -y
apt dist-upgrade -y
apt --fix-broken install -y

# Limapr
apt clean -y
apt autoclean -y
apt autoremove -y
apt full-upgrade -y
