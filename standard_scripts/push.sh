#!/usr/bin/env bash

# Faz todo o processo de push automaticamente e se não passado parâmetro, commita com uma mensagem padrão

[[ "${1}" == "" ]] && value='refresh!' || value="${1}"

git add .
git commit -m "${value}"
git push origin master
