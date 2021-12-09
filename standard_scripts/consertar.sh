#!/usr/bin/env bash

# Tenta concertar pacotes quebrados no sistema

apt install -f -y
apt dist-upgrade -y
apt --fix-broken install -y
