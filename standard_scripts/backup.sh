#!/usr/bin/env bash

###############################################################################
#
# Script criado para fazer backup simples
# para alguma pasta de serviço de cloud e
# para algum disco externo
#
# Modo de uso:
#
#	busca - pastas que seram feitas o backup
#	espaco - nome para diferencias arquivos de backup
#	main - pasta aonde as pastas a serem feitas o backup seram copiadas
#	destino - pasta do serviço de cloud storage
#	externo - caminho do disco externo
#		OBS: MONTAR ATOMÁTICAMENTE O DISCO EXTERNO (para ficar
#		OBS: permissões de usuário normal)
#	usuario - para usar no caminho de montagem automática do dispositivo
#	log_file - nome e caminho do arquivo que será feito
#
###############################################################################

busca=("${HOME}/Desktop" "${HOME}/Documents" "${HOME}/Downloads" "${HOME}/Pictures" "${HOME}/Videos")
espaco="home"
data="$(date +"%d-%m-%y")"
arquivo="${data}_${espaco}_backup.tar.gz"
main="/tmp/backup"
destino="/tmp/temp/backup/destino"
usuario="rhuan"
externo="/tmp/temp/backup/${usuario}/externo"
log_file="/tmp/temp/backup/.backup_file.log"

rm -rfv ${main}/*

for (( i = 0; i < ${#busca[@]}; ++i )); do
        cp -rv ${busca[i]} ${main}
done

echo -e "\n    ~     ~     ~" >> "${log_file}"

# Cloud

if aux=$(rm ${destino}/*.tar.gz 2>&1); then
	echo -e "\n[${data} * $(date +%T)] --- PROCESSO CLOUD INICIADO ---\n" >> "${log_file}"
	echo -e "[${data} * $(date +%T)] - Backup antigo removido - SUCESSO !" >> "${log_file}"
	if aux=$(tar -zcvf ${destino}/${arquivo} ${main} 2>&1); then
		echo -e "[${data} * $(date +%T)] - Novo backup realizado - SUCESSO ! " >> "${log_file}"
	else
		echo -e "[${data} * $(date +%T)] - Novo backup não realizado - FALHA ! " >> "${log_file}"
		echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> "${log_file}"
	fi
else
	echo -e "\n[${data} * $(date +%T)] --- PROCESSO CLOUD NÃO INICIADO ---\n" >> "${log_file}"
	echo -e "[${data} * $(date +%T)] - Backup antigo não removido - FALHA !" >> "${log_file}"
	echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> "${log_file}"
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
