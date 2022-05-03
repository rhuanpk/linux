#!/usr/bin/env bash

# Move os scripts para a pasta correta

std_scripts_path=${HOME}/Documents/git/comandos-linux/standard_scripts

[ ${#} -eq 0 ] && sudo cp -v ${std_scripts_path}/*.sh /usr/local/bin/ || for file in ${@}; do sudo cp -v ${std_scripts_path}/${file} /usr/local/bin/; done
