#!/usr/bin/env bash

arquivo="$(date +"%d-%m-%y")_backup.tar.gz"
busca=("${HOME}/Desktop" "${HOME}/Documents" "${HOME}/Downloads" "${HOME}/Pictures" "${HOME}/Videos")
main="${HOME}/loja_suporte"
destino="${HOME}/Dropbox/backup"

rm -rf ${main}/*
rm -rf ${destino}/*.tar.gz

for (( i = 0; i < ${#busca[@]}; ++i )); do
        cp -r ${busca[i]} ${main}
done

tar -zcvf ${destino}/${arquivo} ${main}
