#!/usr/bin/env bash

# Tenta concertar pacotes quebrados no sistema

apt install -f -y ;
apt --fix-broken install
