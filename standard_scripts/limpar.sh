#!/usr/bin/env bash

# Limpa tudo que está inútil no sistema, deixado por pacotes desinstalados

apt-get clean -y
apt-get autoclean -y
apt-get autoremove -y
