#!/usr/bin/env bash

busca=("${HOME}/Desktop" "${HOME}/Documents" "${HOME}/Downloads" "${HOME}/Pictures" "${HOME}/Videos")
espaco="home"
arquivo="$(date +"%d-%m-%y")_${espaco}_backup.tar.gz"
main="${HOME}/backup"
destino="${HOME}/cloud/backup"
externo="/media/${USER}/99B0-A454"

rm -rfv ${main}/*
rm -rfv ${destino}/*.tar.gz
rm -rfv ${externo}/*${espaco}*

for (( i = 0; i < ${#busca[@]}; ++i )); do
        cp -rv ${busca[i]} ${main}
done

tar -zcvf ${destino}/${arquivo} ${main}
tar -zcvf ${externo}/${arquivo} ${main}
