#!/usr/bin/env bash

# Move os scripts para a pasta correta

[ "${*}" = "" ] && sudo cp -v ./*.sh /usr/local/bin/ || for i in ${@}; do sudo cp -v ./${i} /usr/local/bin/; done
