#!/usr/bin/env bash

# Move os scripts para a pasta correta

[ ${#} -eq 0 ] && sudo cp -v ./*.sh /usr/local/bin/ || for files in ${@}; do sudo cp -v ./${files} /usr/local/bin/; done
