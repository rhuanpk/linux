#!/usr/bin/env bash

###########################################################################
#
# Script criado para fazer backup soimples
# para alguma pasta de serviço de cloud e
# para algum disco externo
#
# Modo de uso:
#
#	busca - pastas que seram feitas o backup
#	espaco - nome para diferencias arquivos de backup
#	main - pasta aonde irá as pastas a serem feitas o backup
#	destino - pasta do serviço de cloud storage
#	externo - caminho do disco externo
#		OBS: MONTAR ATOMÁTICAMENTE O DISCO EXTERNO (para ficar
#		     permissões de usuário normal)
#
##########################################################################

busca=("${HOME}/Desktop" "${HOME}/Documents" "${HOME}/Downloads" "${HOME}/Pictures" "${HOME}/Videos")
espaco="work"
arquivo="$(date +"%d-%m-%y")_${espaco}_backup.tar.gz"
main="${HOME}/loja_suporte"
destino="${HOME}/Dropbox/backup"
externo="/media/usuario/A3DE-614D"

rm -rfv ${main}/*
rm -rfv ${destino}/*.tar.gz
rm -rfv ${externo}/*${espaco}*

for (( i = 0; i < ${#busca[@]}; ++i )); do
        cp -rv ${busca[i]} ${main}
done

tar -zcvf ${destino}/${arquivo} ${main}
tar -zcvf ${externo}/${arquivo} ${main}
