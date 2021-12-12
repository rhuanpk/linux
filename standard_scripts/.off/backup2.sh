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

# Declaração de variáveis

busca=("${HOME}/Desktop" "${HOME}/Documents" "${HOME}/Downloads" "${HOME}/Pictures" "${HOME}/Videos")
espaco="teste"
data="$(date +"%d-%m-%y")"
arquivo="${data}_${espaco}_backup.tar.gz"
main="/tmp/tmp/backup_teste/backup"
destino="/tmp/tmp/backup_teste/destino"
# usuario="usuario"
externo="/tmp/tmp/backup_teste/externo"
log_file="/tmp/tmp/backup_teste/backup_file.log"

# Para criar as pastas necessárias para realizar os testes
# for foo in "backup" "destino" "externo"; do mkdir -p /tmp/tmp/backup_teste/${foo}; done

# Inicio do Backup

echo -e "\n    ~     ~     ~" >> "${log_file}"

get_stt() {
	stt=$(zsh -c 'for dir in /tmp/tmp/backup_teste/backup/*; do rm -rf ${dir}; done; echo "${?}"')
	echo "${stt}"
}

for ((i=0;i<=1;++i)); do
	if [ ${i} -eq 0 ]; then
		echo "here remocao"
		echo "----- retorno da função: $(get_stt) --------"
		if [ $(get_stt) -ne 0 ]; then
			echo "if falha remocao"
			echo -e "\n[${data} * $(date +%T)] --- BACKUP NÃO INICIADO ---\n" >> "${log_file}"
			echo -e "[${data} * $(date +%T)] STDERR (remoção): ${aux}" >> "${log_file}"
			exit 1
		else
			echo "if acerto remocao"
		fi
	else
		echo "here criacao"
		if ! aux=$(cp -rv ${busca[${j}]} ${main} 2>&1); then		
			echo "if falha cricao"
			echo -e "\n[${data} * $(date +%T)] --- BACKUP NÃO INICIADO ---\n" >> "${log_file}"
			echo -e "[${data} * $(date +%T)] STDERR (criação): ${aux}" >> "${log_file}"
			exit 1
		else
			echo "if acerto cricao"
		fi
	fi
done

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