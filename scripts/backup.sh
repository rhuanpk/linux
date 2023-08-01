#!/usr/bin/env bash

# Script criado para realização de backup para alguma pasta de serviço de cloud storage e para alguma mídia externa.
#
# 1. OBS: atualmente, trocar os valores das variáveis:
# 	- `NAME_PLACE`;
# 	- `home`;
# 	- `${ARRAY_FOLDERS[@]}`;
# 	- `PATH_CLOUD`;
# 	- `PATH_EXTERNAL_AUTO`;
# 	- `PATH_EXTERNAL_MANU`;
# 	- `PATH_DIR_LVL`.
#
# 1. OBS: necessário estar liberado no sudo:
# 	- `/usr/bin/mkdir`;
# 	- `/usr/bin/rmdir`;
# 	- `/usr/bin/mount`;
# 	- `/usr/bin/umount`.

#	ARRAY_FOLDERS - pastas que seram feitas o backup
#	NAME_PLACE - nome para diferencias arquivos de backup
#	main - pasta aonde as pastas a serem feitas o backup seram copiadas
#	destino - pasta do serviço de cloud storage
#	externo - caminho do disco externo
#		OBS: MONTAR ATOMÁTICAMENTE O DISCO EXTERNO (para ficar
#		OBS: permissões de usuário normal)
#	user - para usar no caminho de montagem automática do dispositivo
#	LOG_MAIN - nome e caminho do arquivo que será feito
#
#
#
###############################################################################

# -------------------------------------------------- Declaração de variáveis --------------------------------------------------
# Principais:
script="`basename "$0"`"
user="`id -un 1000`"
home="/tmp/home/$user"

# Arrays das pastas a serem backupiadas:
ARRAY_FOLDERS=( \
	"$home/Desktop" \
	"$home/Documents" \
	"$home/Downloads" \
	"$home/Music" \
	"$home/Pictures" \
	"$home/Videos" \
)

# Path dos backups:
PATH_CLOUD="$home/cloud"
PATH_EXTERNAL_AUTO='/media/backup-disk'
PATH_EXTERNAL_MANU='/mnt/backup-disk'
PATH_DIR_LVL='b4ckups'

# Formatação:
FORMAT_DATE="`date '+%y-%m-%d'`"

# Nomes:
NAME_PLACE='teste'
NAME_FILE="${FORMAT_DATE}_${NAME_PLACE}_backup.zip"

# Logs:
LOG_MAIN="$home/.backup_file.log"

# Flags de controle:
FLAG_CLOUD='false'
FLAG_EXTERNAL='false'
FLAG_MOUNT_AUTO='1'
FLAG_MOUNT_MANU='1'

# -------------------------------------------------- Declaração de funções --------------------------------------------------

# Função que print uma mensagem de finalização.
message-ending() {
	echo -e "\n---------- Finalizado [$FORMAT_DATE * `date '+%T'`] ----------" >>"$LOG_MAIN"
}

# Função que faz todo o tratamento e execução de qual backup está antigo para ser excluido.
get-array-file-names() {

	PATHWAY="$1"
	DELIMITER='-'
	COLUMN_YEAR='1'
	COLUMN_MONTH='2'
	COLUMN_DAY='3'
	LIST_DIR=`ls -1 "$PATHWAY"`

	for atual_year in `cut -d "$DELIMITER" -f "$COLUMN_YEAR" <<< "$LIST_DIR" | sort -nu`; do
		for atual_month in `grep -E "^$atual_year-([[:digit:]]+[[:punct:]]?){2}_$NAME_PLACE" <<< "$LIST_DIR" | cut -d "$DELIMITER" -f "$COLUMN_MONTH" | sort -nu`; do
			for atual_file_day in `grep -E "^$atual_year-$atual_month-[[:digit:]]+_$NAME_PLACE" <<< "$LIST_DIR" | sort -nt "$DELIMITER" -k "$COLUMN_DAY" | tail -n +2`; do
				ARRAY_FILE_NAMES+=("$atual_file_day")
			done
		done
	done

	echo "${ARRAY_FILE_NAMES[@]}"

}

# Função que remove os backups antigos.
remove-old-backup() {

	PATHWAY="$1"
	tempo_exclusao='2'
	dia_atual="`date '+%d'`"
	mes_atual="`date '+%m'`"
	ano_atual="`date '+%Y'`"

	ultimo_dia_mes_passado() {
		mes_passado="$mes_atual"
		ano_passado="$ano_atual"
		[ "$mes_atual" -eq 1 ] && { mes_passado='12'; let --ano_passado ;} || let --mes_passado
		linhas_calendario="`cal "$mes_passado" "$ano_passado" | grep -c '.*'`"
		pega_ultima_linha() {
			f_linhas_calendario="$1"
			echo "`cal "$mes_passado" "$ano_passado" | sed -n "${f_linhas_calendario}p" | grep -E '([0-9])+'`"
		}
		ultima_linha_calendario="`pega_ultima_linha "$linhas_calendario"`"
		[ -z "$ultima_linha_calendario" ] 2>&- && ultima_linha_calendario="`pega_ultima_linha $(("$linhas_calendario"-1))`"
		pega_ultimo_dia() {
			f_ultima_linha_calendario="$*"
			echo "$(tr ' ' '\n' <<< "$f_ultima_linha_calendario" | tail -n +`tr ' ' '\n' <<< "$f_ultima_linha_calendario" | grep -c '.*'`)"
		}
		echo "`pega_ultimo_dia "$ultima_linha_calendario"`"
	}

	for file in `get-array-file-names "$PATHWAY"`; do
		nomes_arquivos+=("$file")
	done

	qtd_arquivos="`ls -1 "$PATHWAY" | grep "$NAME_PLACE" | wc -l`"
	for ((j=0;j<2;++j)); do
		for ((i=0;i<"$qtd_arquivos";++i)); do
			if [ "$j" -eq 0 ]; then
				dias_criacao["$i"]="`ls -1 "$PATHWAY" | grep -E "^.*($NAME_PLACE).*$" | sed -n "$(("$i"+'1'))p" | cut -c '1-2'`"
			fi
			if [ "$j" -eq 1 ]; then
				if [ ! -e $PATHWAY/${nomes_arquivos[@]: -2: 1} ]; then
					break
				else
					if [ -z ${nomes_arquivos[@]: -2: 1} ]; then
						break
					fi
				fi
				diff_day="$(("${dia_atual#0}"-"${dias_criacao["$i"]#0}"))"
				if [ "$diff_day" -ge "$tempo_exclusao" ]; then
					rm -v $PATHWAY/${nomes_arquivos[${i}]}
				elif [ "$diff_day" -lt 0 ]; then
					let diff_day*=-1
					let ++diff_day
					diff_day="$(($(("`ultimo_dia_mes_passado`"-"$diff_day"))+"$dia_atual"))"
					if [ "$diff_day" -ge "$tempo_exclusao" ]; then
						rm -v $PATHWAY/${nomes_arquivos[${i}]}
					fi
				fi
			fi
		done
	done

}

# -------------------------------------------------- Inicio do programa --------------------------------------------------

echo -e "\n     ~     ~     ~" >>"$LOG_MAIN"
echo -e "\n---------- Iniciado [$FORMAT_DATE * `date '+%T'`] ----------" >>"$LOG_MAIN"

# >>> Backup ClOUD !
if "$FLAG_CLOUD"; then

	remove-old-backup "$PATH_CLOUD"

	if aux="`for ((i=0;i<${#ARRAY_FOLDERS[@]};++i)); do zip -ry $PATH_CLOUD/$NAME_FILE ${ARRAY_FOLDERS[${i}]}; done 2>&1`"; then
		echo -e "\n[$FORMAT_DATE * `date '+%T'`] --- PROCESSO CLOUD INICIADO ---\n" >>"$LOG_MAIN"
		echo -e "[$FORMAT_DATE * `date '+%T'`] - Atualização do backup realizada - SUCESSO ! " >>"$LOG_MAIN"
	else
		echo -e "\n[$FORMAT_DATE * `date '+%T'`] --- PROCESSO CLOUD NÃO INICIADO ---\n" >>"$LOG_MAIN"
		echo -e "[$FORMAT_DATE * `date '+%T'`] - Atualização do backup não realizada - FALHA ! " >>"$LOG_MAIN"
		echo -e "[$FORMAT_DATE * `date '+%T'`] STDERR: $aux" >>"$LOG_MAIN"
	fi

	if ! "$FLAG_EXTERNAL"; then
		message-ending
	fi

fi

# >>> Backup EXTERNAL!
if "$FLAG_EXTERNAL"; then

	if mountpoint "$PATH_EXTERNAL_AUTO" 2>&-; then
		FLAG_MOUNT_AUTO='0'
	else
		sudo mkdir "$PATH_EXTERNAL_MANU"
		if aux="`sudo mount -o rw,uid=1000,gid=1000 -L BACKUP-DISK "$PATH_EXTERNAL_MANU" 2>&1`"; then
			FLAG_MOUNT_MANU='0'
		else
			sudo rmdir "$PATH_EXTERNAL_MANU"
			echo -e "\n[$FORMAT_DATE * `date '+%T'`] --- PROCESSO EXTERNO NÃO INICIADO ---\n" >>"$LOG_MAIN"
			echo -e "[$FORMAT_DATE * `date '+%T'`] STDERR: $aux" >>"$LOG_MAIN"
			message-ending
			exit 1
		fi
	fi

	if [ "$FLAG_MOUNT_AUTO" -eq 0 ]; then
		externo="$PATH_EXTERNAL_AUTO/$PATH_DIR_LVL"
	elif [ "$FLAG_MOUNT_MANU" -eq 0 ]; then
		externo="$PATH_EXTERNAL_MANU/$PATH_DIR_LVL"
	fi

	remove-old-backup "$externo"

	if aux="`for ((i=0;i<${#ARRAY_FOLDERS[@]};++i)); do zip --recurse-paths --symlinks $externo/$NAME_FILE ${ARRAY_FOLDERS[${i}]}; done 2>&1`"; then
		echo -e "\n[$FORMAT_DATE * `date '+%T'`] --- PROCESSO EXTERNO INICIADO ---\n" >>"$LOG_MAIN"
		echo -e "[$FORMAT_DATE * `date '+%T'`] - Atualização do backup realizada - SUCESSO ! " >>"$LOG_MAIN"
	else
		echo -e "\n[$FORMAT_DATE * `date '+%T'`] --- PROCESSO EXTERNO NÃO INICIADO ---\n" >>"$LOG_MAIN"
		echo -e "[$FORMAT_DATE * `date '+%T'`] - Atualização do backup não realizada - FALHA ! " >>"$LOG_MAIN"
		echo -e "[$FORMAT_DATE * `date '+%T'`] STDERR: $aux" >>"$LOG_MAIN"
	fi

	if [ "$FLAG_MOUNT_AUTO" -eq 0 ]; then
		if aux="`sudo umount ${externo%/${PATH_DIR_LVL}} 2>&1`"; then
			message-ending
		else
			echo -e " - Não foi possível desmontar o disco (automático) - FALHA !" >>"$LOG_MAIN"
			echo -e "[$FORMAT_DATE * `date '+%T'`] STDERR: $aux" >>"$LOG_MAIN"
			message-ending
		fi
	elif [ "$FLAG_MOUNT_MANU" -eq 0 ]; then
		if aux="`sudo umount ${externo%/${PATH_DIR_LVL}} 2>&1`"; then
			sudo rmdir ${externo%/${PATH_DIR_LVL}}
			message-ending
		else
			echo -e " - Não foi possível desmontar o disco (manual) - FALHA !" >>"$LOG_MAIN"
			echo -e "[$FORMAT_DATE * `date '+%T'`] STDERR: $aux" >>"$LOG_MAIN"
			message-ending
		fi
	fi

fi
