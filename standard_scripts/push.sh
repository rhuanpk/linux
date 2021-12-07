#!/usr/bin/env bash

# Faz todo o processo de push automaticamente e se não passado parâmetro, commita com uma mensagem padrão

[[ "${1}" == "" ]] && MSG='refresh!' || MSG="${1}"
[[ "${2}" == "" ]] && BRANCH='master' || BRANCH="${2}"

git add .
git commit -m "${MSG}"
git push origin "${BRANCH}"
