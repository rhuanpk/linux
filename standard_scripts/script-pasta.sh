#!/usr/bin/env bash

# Cria uma separada para os scripts ;
# Move todos os scritps da pasta para a pasta criada ;
# Adiciona essa pasta ao $PATH
# Correr o script dentro do repo pasta

sudo mkdir -v /scripts

sudo cp -v ./*.sh /scripts

echo -e "" >> "$HOME"/.bashrc
echo 'export PATH=$PATH:/scripts' >> "$HOME"/.bashrc

sudo echo -e "" >> /root/.bashrc
sudo echo 'export PATH=$PATH:/scripts' >> /root/.bashrc
