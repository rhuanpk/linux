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

# ---------------------------------------------- Declaração de variáveis -----------------------------------------------

# Array das pastas a serem backupiadas

busca=("/tmp/tmp/home/Desktop" "/tmp/tmp/home/Documents" "/tmp/tmp/home/Downloads" "/tmp/tmp/home/Pictures" "/tmp/tmp/home/Videos" "/tmp/tmp/home/script")

# Nomes e formatação

espaco="teste"
usuario="user"
data="$(date +"%d-%m-%y")"
log_file="/tmp/tmp/.teste_backup_file.log"
arquivo="${data}_${espaco}_backup.zip"

# Path dos backups

cloud="/tmp/tmp/dropbox/backup"
externo_auto="/tmp/tmp/externo/media"
externo_manu="/tmp/tmp/externo/tmp"

# Flags de controle

flag_externo_mount_manu=1
flag_externo_mount_auto=1

# ---------------------------------------------- Declaração de funções -------------------------------------------------

msg_final() {
	echo -e "\n---------- Finalizado [${data} * $(date +%T)] ----------" >> ${log_file}
}

# ---------------------------------------------- Inicio do programa ----------------------------------------------------

echo -e "\n     ~     ~     ~" >> ${log_file}
echo -e "\n---------- Iniciado [${data} * $(date +%T)] ----------\n" >> ${log_file}

# >>> Backup CLOUD !

# touch ${cloud}/.unbroken
# sudo chmod 600 ${cloud}/.unbroken
# sudo chattr +i ${cloud}/.unbroken

find ${cloud} -mtime +2 -delete

if aux=$(for ((i=0;i<${#busca[@]};++i)); do zip -rv ${cloud}/${arquivo} ${busca[${i}]}; done 2>&1); then
	echo -e "\n[${data} * $(date +%T)] --- PROCESSO CLOUD INICIADO ---\n" >> ${log_file}
	echo -e "[${data} * $(date +%T)] - Atualização do backup realizada - SUCESSO ! " >> ${log_file}
else
	echo -e "\n[${data} * $(date +%T)] --- PROCESSO CLOUD NÃO INICIADO ---\n" >> ${log_file}
	echo -e "[${data} * $(date +%T)] - Atualização do backup não realizada - FALHA ! " >> ${log_file}
	echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> ${log_file}
fi

# >>> VERIFICAÇÃO e MONTAGEM da mídia removível

if mountpoint /media/${usuario}/BACKUP-DISK 2>&-; then
	flag_externo_mount_auto=0	
else
	mkdir /tmp/BACKUP-DISK
	if aux=$(sudo mount -L BACKUP-DISK /tmp/BACKUP-DISK 2>&1); then
		flag_externo_mount_manu=0
	else
		rmdir /tmp/BACKUP-DISK
		echo -e "\n[${data} * $(date +%T)] --- PROCESSO EXTERNO NÃO INICIADO ---\n" >> ${log_file}
		echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> ${log_file}
		msg_final
		exit 1
	fi
fi

# >>> Backup EXTERNO !

if [ ${flag_externo_mount_auto} -eq 0 ]; then
	externo="${externo_auto}"
elif [ ${flag_externo_mount_manu} -eq 0 ]; then
	externo="${externo_manu}"
fi

find ${externo} -mtime +2 -delete

if aux=$(for ((i=0;i<${#busca[@]};++i)); do zip -rv ${externo}/${arquivo} ${busca[${i}]}; done 2>&1); then
	echo -e "\n[${data} * $(date +%T)] --- PROCESSO EXTERNO INICIADO ---\n" >> ${log_file}
	echo -e "[${data} * $(date +%T)] - Atualização do backup realizada - SUCESSO ! " >> ${log_file}
else
	echo -e "\n[${data} * $(date +%T)] --- PROCESSO EXTERNO NÃO INICIADO ---\n" >> ${log_file}
	echo -e "[${data} * $(date +%T)] - Atualização do backup não realizada - FALHA ! " >> ${log_file}
	echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> ${log_file}
fi

# >>> DESMONTAGEM da mídia removível

if [ ${flag_externo_mount_auto} -eq 0 ]; then
	if aux=$(sudo umount /media/${usuario}/BACKUP-DISK 2>&1); then
		msg_final
	else
		echo -e " - Não foi possível desmontar o disco (automático) - FALHA !" >> ${log_file}
		echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> ${log_file}
		msg_final
	fi
elif [ ${flag_externo_mount_manu} -eq 0 ]; then
	if aux=$(sudo umount /tmp/BACKUP-DISK 2>&1); then
		rmdir /tmp/BACKUP-DISK
		msg_final
	else
		echo -e " - Não foi possível desmontar o disco (manual) - FALHA !" >> ${log_file}
		echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> ${log_file}
		msg_final
	fi
fi
