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
#	OBS: Atualmente, trocar os valores das variáveis: ${espaco}, ${home},
# 	${busca[@]}, ${cloud}, ${externo_auto}, ${externo_manu} e ${dir_lvl}
#
#	Necessário estar liberado no sudo: /usr/bin/mkdir,/usr/bin/rmdir,
# 	/usr/bin/mount,/usr/bin/umount
#
###############################################################################

# ---------------------------------------------- Declaração de variáveis -----------------------------------------------

# Nomes e formatação

espaco="teste"
usuario="$(whoami)"
home="/tmp/home/${usuario}"
data="$(date +"%d-%m-%y")"
log_file="${home}/.backup_file.log"
arquivo="${data}_${espaco}_backup.zip"

# Array das pastas a serem backupiadas

busca=("${home}/Desktop" "${home}/Documents" "${home}/Downloads" "${home}/Music" "${home}/Pictures" "${home}/Videos")

# Path dos backups

cloud="${home}/Dropbox"
externo_auto="/media/BACKUP-DISK"
externo_manu="/mnt/BACKUP-DISK"
dir_lvl="b4ckups"

# Flags de controle

flag_cloud=true
flag_externo=true
flag_externo_mount_manu=1
flag_externo_mount_auto=1

# ---------------------------------------------- Declaração de funções -------------------------------------------------

# Função que print uma mensagem de finalização

msg_final() {
	echo -e "\n---------- Finalizado [${data} * $(date +%T)] ----------" >> ${log_file}
}

# Função que faz todo o tratamento e execução de qual backup está antigo para ser excluido

get_arr_nomes_arquivos() {

	path=${1}
	z=1

	for i in $(ls -1 ${path} | sort -t '-' -k '3' | cut -d '-' -f '3' | sort -u); do
		cont_year=0
		save_year=""
		limit_year=$(ls -1 ${path} | egrep "^.*(${espaco}).*$" | egrep "^([[:digit:]]+[[:punct:]]?){2}${i}" | grep -c '.*')
		for j in $(ls -1 ${path} | egrep "^.*(${espaco}).*$" | egrep "^([[:digit:]]+[[:punct:]]?){2}${i}"); do
			save_year="${save_year}${j} "
			let ++cont_year
			if [ ${cont_year} -eq ${limit_year} ]; then
				for x in $(echo "${save_year}" | tr ' ' '\n' | sort -t '-' -k '2' | cut -d '-' -f '2' | sort -u); do
					cont_month=0
					save_month=""
					limit_month=$(echo "${save_year}" | tr ' ' '\n' | egrep "^.*(${espaco}).*$" | egrep "^([[:digit:]]+[[:punct:]]?){1}${x}" | grep -c '.*')
					for y in $(echo "${save_year}" | tr ' ' '\n' | egrep "^.*(${espaco}).*$" | egrep "^([[:digit:]]+[[:punct:]]?){1}${x}"); do
						save_month="${save_month}${y} "
						let ++cont_month
						if [ ${cont_month} -eq ${limit_month} ]; then
							control_sed=1
							control_while=${z}
							while [ ${z} -le $((${limit_month}+$((${control_while}-1)))) ]; do
								arr_names[$((${z}-1))]=$(echo "${save_month}" | tr ' ' '\n' | sort -n -t '-' -k '1' | sed '1d' | sed -n "${control_sed}p")
								let ++z
								let ++control_sed
							done
						fi
					done
				done
			fi
		done
	done

	echo "${arr_names[@]}"

}

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

	cont=0
	for file_name in $(get_arr_nomes_arquivos ${path}); do
		nomes_arquivos[${cont}]="${file_name}"
		let ++cont
	done

	qtd_arquivos=$(ls -1 ${path} | grep -E "^.*(${espaco}).*$" | grep -c '.*')
	for ((j=0;j<2;++j)); do
		for ((i=0;i<${qtd_arquivos};++i)); do
			if [ ${j} -eq 0 ]; then
				dias_criacao[${i}]=$(ls -1 ${path} | grep -E "^.*(${espaco}).*$" | sed -n "$((${i}+1))p" | cut -c '1-2')
			fi
			if [ ${j} -eq 1 ]; then
				if [ ! -e ${path}/${nomes_arquivos[@]: -2: 1} ]; then
					break
				else
					if [ -z ${nomes_arquivos[@]: -2: 1} ]; then
						break
					fi
				fi
				diff_day="$((${dia_atual#0}-${dias_criacao[${i}]#0}))"
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
echo -e "\n---------- Iniciado [${data} * $(date +%T)] ----------" >> ${log_file}

# >>> Backup CLOUD !

if ${flag_cloud}; then

	rm_bkp_antigo ${cloud}

	if aux=$(for ((i=0;i<${#busca[@]};++i)); do zip -ry ${cloud}/${arquivo} ${busca[${i}]}; done 2>&1); then
		echo -e "\n[${data} * $(date +%T)] --- PROCESSO CLOUD INICIADO ---\n" >> ${log_file}
		echo -e "[${data} * $(date +%T)] - Atualização do backup realizada - SUCESSO ! " >> ${log_file}
	else
		echo -e "\n[${data} * $(date +%T)] --- PROCESSO CLOUD NÃO INICIADO ---\n" >> ${log_file}
		echo -e "[${data} * $(date +%T)] - Atualização do backup não realizada - FALHA ! " >> ${log_file}
		echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> ${log_file}
	fi

	if ! ${flag_externo}; then
		msg_final
	fi

fi

if ${flag_externo}; then

	# >>> VERIFICAÇÃO e MONTAGEM da mídia removível

	if mountpoint ${externo_auto} 2>&-; then
		flag_externo_mount_auto=0
	else
		sudo mkdir ${externo_manu}
		if aux=$(sudo mount -o rw,uid=1000,gid=1000 -L BACKUP-DISK ${externo_manu} 2>&1); then
			flag_externo_mount_manu=0
		else
			sudo rmdir ${externo_manu}
			echo -e "\n[${data} * $(date +%T)] --- PROCESSO EXTERNO NÃO INICIADO ---\n" >> ${log_file}
			echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> ${log_file}
			msg_final
			exit 1
		fi
	fi

	# >>> Backup EXTERNO !

	if [ ${flag_externo_mount_auto} -eq 0 ]; then
		externo="${externo_auto}/${dir_lvl}"
	elif [ ${flag_externo_mount_manu} -eq 0 ]; then
		externo="${externo_manu}/${dir_lvl}"
	fi

	rm_bkp_antigo ${externo}

	if aux=$(for ((i=0;i<${#busca[@]};++i)); do zip --recurse-paths --symlinks ${externo}/${arquivo} ${busca[${i}]}; done 2>&1); then
		echo -e "\n[${data} * $(date +%T)] --- PROCESSO EXTERNO INICIADO ---\n" >> ${log_file}
		echo -e "[${data} * $(date +%T)] - Atualização do backup realizada - SUCESSO ! " >> ${log_file}
	else
		echo -e "\n[${data} * $(date +%T)] --- PROCESSO EXTERNO NÃO INICIADO ---\n" >> ${log_file}
		echo -e "[${data} * $(date +%T)] - Atualização do backup não realizada - FALHA ! " >> ${log_file}
		echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> ${log_file}
	fi

	# >>> DESMONTAGEM da mídia removível

	if [ ${flag_externo_mount_auto} -eq 0 ]; then
		if aux=$(sudo umount ${externo%/${dir_lvl}} 2>&1); then
			msg_final
		else
			echo -e " - Não foi possível desmontar o disco (automático) - FALHA !" >> ${log_file}
			echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> ${log_file}
			msg_final
		fi
	elif [ ${flag_externo_mount_manu} -eq 0 ]; then
		if aux=$(sudo umount ${externo%/${dir_lvl}} 2>&1); then
			sudo rmdir ${externo%/${dir_lvl}}
			msg_final
		else
			echo -e " - Não foi possível desmontar o disco (manual) - FALHA !" >> ${log_file}
			echo -e "[${data} * $(date +%T)] STDERR: ${aux}" >> ${log_file}
			msg_final
		fi
	fi

fi
