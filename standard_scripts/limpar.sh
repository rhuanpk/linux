#!/usr/bin/env bash

# Limpa tudo que está inútil no sistema, deixado por pacotes desinstalados

apt clean -y
apt autoclean -y
apt autoremove -y
apt full-upgrade -y
