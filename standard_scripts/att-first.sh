#!/usr/bin/env bash

# Para quando ainda não tiver sido feito nenhuma atualização no sistema

apt update -y
apt upgrade -y
apt dist-upgrade -y

apt full-upgrade -y

ubuntu-drivers autoinstall
apt install ubuntu-restricted-extras -y
