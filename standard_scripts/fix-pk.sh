#!/usr/bin/env bash

# Tenta concertar pacotes quebrados no sistema

apt-get install -f -y
apt-get --fix-broken install
