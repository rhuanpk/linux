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

# Função que print uma mensagem de finalização

msg_final() {
	echo -e "\n---------- Finalizado [${data} * $(date +%T)] ----------" >> ${log_file}
}

# Função que faz todo o tratamento e execução de qual backup está antigo para ser excluido

rm_bkp_antigo() {

	path="${1}"
	tempo_exclusao=2
	dia_atual=$(date "+%d")
	mes_atual=$(date "+%m")
	ano_atual=$(date "+%Y")

	ultimo_dia_mes_passado() {
		mes_passado=${mes_atual}
		ano_passado=${ano_atual}
		[ ${mes_atual} -eq 1 ] && { mes_passado=12; let --ano_passado ;} || let --mes_passado
		linhas_calendario=$(cal ${mes_passado} ${ano_passado} | grep -c '.*')
		pega_ultima_linha() {
			f_linhas_calendario=${1}
			echo "$(cal ${mes_passado} ${ano_passado} | sed -n "${f_linhas_calendario}p" | grep -E '([0-9])+')"
		}
		ultima_linha_calendario=$(pega_ultima_linha ${linhas_calendario})
		[ -z ${ultima_linha_calendario} ] 2>&- && ultima_linha_calendario=$(pega_ultima_linha $((${linhas_calendario}-1)))
		pega_ultimo_dia() {
			f_ultima_linha_calendario="${*}"
			echo "$(tr ' ' '\n' <<< ${f_ultima_linha_calendario} | tail -n +$(tr ' ' '\n' <<< ${f_ultima_linha_calendario} | grep -c '.*'))"
		}
		echo "$(pega_ultimo_dia ${ultima_linha_calendario})"
	}

	qtd_arquivos=$(ls -1 ${path} | grep -E "^.*(${espaco}).*$"  | grep -c '.*')
	for ((j=0;j<2;++j)); do
		for ((i=0;i<${qtd_arquivos};++i)); do
			if [ ${j} -eq 0 ]; then
				# Outra forma de pegar a data de crição dos arquivos usando o ls com a opção alongada:
				# ls -l ${path} | tr -s ' ' | cut -d ' ' -f '7' | sed '/^$/d' | sed -n "$((${i}+1))p")
				dias_criacao[${i}]=$(ls -1 ${path} | grep -E "^.*(${espaco}).*$"  | sed -n "$((${i}+1))p" | cut -c '1-2')
				nomes_arquivos[${i}]=$(ls -1 ${path} | grep -E "^.*(${espaco}).*$" | sed -n "$((${i}+1))p")
			fi
			if [ ${j} -eq 1 ]; then
				diff_day=$((${dia_atual}-${dias_criacao[${i}]}))
				if [ ${diff_day} -ge ${tempo_exclusao} ]; then
					rm -v ${path}/${nomes_arquivos[${i}]}
				elif [ ${diff_day} -lt 0 ]; then
					let diff_day*=-1
					let ++diff_day
					diff_day=$(($(($(ultimo_dia_mes_passado)-${diff_day}))+${dia_atual}))
					if [ ${diff_day} -ge ${tempo_exclusao} ]; then
						rm -v ${path}/${nomes_arquivos[${i}]}
					fi
				fi
			fi
		done
	done

}

# ---------------------------------------------- Inicio do programa ----------------------------------------------------

echo -e "\n     ~     ~     ~" >> ${log_file}
echo -e "\n---------- Iniciado [${data} * $(date +%T)] ----------\n" >> ${log_file}

# >>> Backup CLOUD !

rm_bkp_antigo ${cloud}

if aux=$(for ((i=0;i<${#busca[@]};++i)); do zip -r ${cloud}/${arquivo} ${busca[${i}]}; done 2>&1); then
	echo -e "\n[${data} * $(date +%T)] --- PROCESSO CLOUD INICIADO ---\n" >> ${log_file}
	echo -e "[${data} * $(date +%T)] - Atualização do backup realizada - SUCESSO ! " >> ${log_file}
else
	echo -e "\n[${data} * $(date +%T)] --- PROCESSO CLOUD NÃO INICIADO ---\n" >> ${log_file}
	echo -e "[${data} * $(date +%T)] - Atualização do backup não realizada - FALHA ! " >> ${log_file}
	echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> ${log_file}
fi

# >>> VERIFICAÇÃO e MONTAGEM da mídia removível

if mountpoint ${externo_auto} 2>&-; then
	flag_externo_mount_auto=0	
else
	mkdir ${externo_manu}
	if aux=$(sudo mount -o uid=1000 -L BACKUP-DISK ${externo_manu} 2>&1); then
		flag_externo_mount_manu=0
	else
		rmdir ${externo_manu} 
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

rm_bkp_antigo ${externo}

if aux=$(for ((i=0;i<${#busca[@]};++i)); do zip -r ${externo}/${arquivo} ${busca[${i}]}; done 2>&1); then
	echo -e "\n[${data} * $(date +%T)] --- PROCESSO EXTERNO INICIADO ---\n" >> ${log_file}
	echo -e "[${data} * $(date +%T)] - Atualização do backup realizada - SUCESSO ! " >> ${log_file}
else
	echo -e "\n[${data} * $(date +%T)] --- PROCESSO EXTERNO NÃO INICIADO ---\n" >> ${log_file}
	echo -e "[${data} * $(date +%T)] - Atualização do backup não realizada - FALHA ! " >> ${log_file}
	echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> ${log_file}
fi

# >>> DESMONTAGEM da mídia removível

if [ ${flag_externo_mount_auto} -eq 0 ]; then
	if aux=$(sudo umount ${externo} 2>&1); then
		msg_final
	else
		echo -e " - Não foi possível desmontar o disco (automático) - FALHA !" >> ${log_file}
		echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> ${log_file}
		msg_final
	fi
elif [ ${flag_externo_mount_manu} -eq 0 ]; then
	if aux=$(sudo umount ${externo} 2>&1); then
		rmdir ${externo}
		msg_final
	else
		echo -e " - Não foi possível desmontar o disco (manual) - FALHA !" >> ${log_file}
		echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> ${log_file}
		msg_final
	fi
fi
