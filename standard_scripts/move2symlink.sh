#!/usr/bin/env bash

for files in ${HOME}/Documents/git/comandos-linux/standard_scripts/*.sh; do sudo ln -sv ${files} "/usr/local/bin/pk-$(basename ${files%.sh})"; done
