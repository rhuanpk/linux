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
espaco="home"
data="$(date +"%d-%m-%y")"
arquivo="${data}_${espaco}_backup.tar.gz"
main="${HOME}/backup"
destino="${HOME}/cloud/backup"
usuario="rhuan"
externo="/media/${usuario}/A3DE-614D"
log_file="/home/${usuario}/.backup_log.log"

rm -rfv ${main}/*

for (( i = 0; i < ${#busca[@]}; ++i )); do
        cp -rv ${busca[i]} ${main}
done

echo -e "\n    ~     ~     ~" >> "${log_file}"

# Cloud

echo -e "\n[${data} * $(date +%T)] --- PROCESSO CLOUD INICIADO ---\n" >> "${log_file}"
if rm -rfv ${destino}/*.tar.gz 2>> "${log_file}"; then
	echo -e "[${data} * $(date +%T)] - Backup antigo removido - SUCESSO !" >> "${log_file}"
	if tar -zcvf ${destino}/${arquivo} ${main} 2> /dev/null; then
		echo -e "[${data} * $(date +%T)] - Novo backup realizado - SUCESSO ! " >> "${log_file}"
	else
		echo -e "[${data} * $(date +%T)] - Novo backup não realizado - FALHA ! " >> "${log_file}"
	fi
else
	echo -e "[${data} * $(date +%T)] - Backup antigo não removido - FALHA !" >> "${log_file}"
fi

# Externo

if aux=$(mountpoint /media/${usuario}/A3DE-614D 2>&1); then
	echo -e "\n[${data} * $(date +%T)] --- PROCESSO EXTERNO INICIADO ---\n" >> "${log_file}"
	if aux=$(rm ${externo}/*${espaco}* 2>&1); then 
		echo -e "[${data} * $(date +%T)] - Backup antigo removido - SUCESSO !" >> "${log_file}"
		if aux=$(tar -zcvf ${externo}/${arquivo} ${main} 2>&1); then
			echo -e "[${data} * $(date +%T)] - Novo backup realizado - SUCESSO ! " >> "${log_file}"
		else
			echo -e "[${data} * $(date +%T)] - Novo backup não realizado - FALHA ! " >> "${log_file}"
			echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> "${log_file}"
		fi
	else
		echo -e "[${data} * $(date +%T)] - Backup antigo não removido - FALHA !" >> "${log_file}"
		echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> "${log_file}"
	fi
else
	echo -e "\n[${data} * $(date +%T)] --- PROCESSO EXTERNO NÃO INICIADO ---\n" >> "${log_file}"
	echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> "${log_file}"
fi
