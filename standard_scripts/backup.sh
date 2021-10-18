#!/usr/bin/env bash

arquivo="$(date +"%d-%m-%y")_backup.tar.gz"
busca=("${HOME}/Desktop" "${HOME}/Documents" "${HOME}/Downloads" "${HOME}/Pictures" "${HOME}/Videos")
main="${HOME}/backup"
destino="${HOME}/Dropbox/backup"

rm -rfv ${main}/*
rm -rfv ${destino}/*.tar.gz

for (( i = 0; i < ${#busca[@]}; ++i )); do
        cp -rv ${busca[i]} ${main}
done

tar -zcvf ${destino}/${arquivo} ${main}
