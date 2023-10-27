#!/usr/bin/env bash

# Script criado para realização de backup para alguma pasta de serviço de cloud storage e para alguma mídia externa.

# 1. OBS: atualmente, trocar os valores das variáveis:

# 1. OBS: necessário estar liberado no sudo:
# 	- `/usr/bin/mkdir`;
# 	- `/usr/bin/rmdir`;
# 	- `/usr/bin/mount`;
# 	- `/usr/bin/umount`.

# -------------------------------------------------- Declaração de variáveis --------------------------------------------------
# Principais:
script="`basename $(readlink -f "$0")`"
user="`id -un`"
home="/tmp/home/$user"

# Arrays das pastas a serem backupiadas:
ARRAY_FOLDERS_BACKUP=( \
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

# Datas:
DATE_FULL="`date '+%y-%m-%d'`"

# Nomes:
NAME_PLACE='test'
NAME_FILE="${DATE_FULL}_${NAME_PLACE}-backup.zip"

# Logs:
LOG_MAIN="$home/.$script.log"

# Flags de controle:
FLAG_CLOUD='false'
FLAG_EXTERNAL='false'
FLAG_MOUNT_AUTO='false'
FLAG_MOUNT_MANU='false'

# -------------------------------------------------- Declaração de funções --------------------------------------------------

# Função que printa mensagem padrão nos logs.
log-prefix() {
	echo "[$DATE_FULL * `date '+%T'`]"
}

# Função que print uma mensagem de finalização.
message-ending() {
	echo -e "\n---------- Finished `log-prefix` ----------" >>"$LOG_MAIN"
}

# Função que remove os backups antigos.
remove-old-backup() {

	FILES=("$1"/*"$NAME_PLACE"*)

	for file in "${FILES[@]: 0:$(("${#FILES[@]}"-1))}"; do
		find "$file" -mtime +2 -exec rm -fv '{}'\;
	done

}

# -------------------------------------------------- Inicio do programa --------------------------------------------------

echo -e "\n\t~\t~\t~" >>"$LOG_MAIN"
echo -e "\n---------- Started `log-prefix` ----------" >>"$LOG_MAIN"

# >>> Backup ClOUD !
if "$FLAG_CLOUD"; then

	remove-old-backup "$PATH_CLOUD"

	if OUTPUT="`for folder in "${ARRAY_FOLDERS_BACKUP[@]}"; do zip -ry "$PATH_CLOUD/$NAME_FILE" "$folder"; done 2>&1`"; then
		cat <<- EOF >>"$LOG_MAIN"

			`log-prefix` --- CLOUD PROCESS STARTED ---

			`log-prefix` - Backup update performed - SUCCESS !
		EOF
	else
		cat <<- EOF >>"$LOG_MAIN"

			`log-prefix` --- CLOUD PROCESS NOT STARTED ---

			`log-prefix` - Backup update not performed - FAILURE !
			`log-prefix` STDERR: $OUTPUT
		EOF
	fi

	if ! "$FLAG_EXTERNAL"; then message-ending; fi

fi

# >>> Backup EXTERNAL!
if "$FLAG_EXTERNAL"; then

	if mountpoint "$PATH_EXTERNAL_AUTO" 2>&-; then
		FLAG_MOUNT_AUTO='true'
	else
		sudo mkdir "$PATH_EXTERNAL_MANU"
		if OUTPUT="`sudo mount -o 'rw,uid=1000,gid=1000' -L backup-disk "$PATH_EXTERNAL_MANU" 2>&1`"; then
			FLAG_MOUNT_MANU='true'
		else
			sudo rmdir "$PATH_EXTERNAL_MANU"
			cat <<- EOF >>"$LOG_MAIN"

				`log-prefix` --- EXTERNAL PROCESS NOT STARTED ---

				`log-prefix` STDERR: $OUTPUT
			EOF
			message-ending
			exit 1
		fi
	fi

	if "$FLAG_MOUNT_AUTO"; then
		PATH_EXTERNAL="$PATH_EXTERNAL_AUTO/$PATH_DIR_LVL"
	elif "$FLAG_MOUNT_MANU"; then
		PATH_EXTERNAL="$PATH_EXTERNAL_MANU/$PATH_DIR_LVL"
	fi

	remove-old-backup "$PATH_EXTERNAL"

	if OUTPUT="`for folder in ${ARRAY_FOLDERS_BACKUP[@]}; do zip -ry "$PATH_EXTERNAL/$NAME_FILE" "$folder"; done 2>&1`"; then
		cat <<- EOF >>"$LOG_MAIN"

			`log-prefix` --- EXTERNAL PROCESS STARTED ---

			`log-prefix` - Backup update performed - SUCCESS !
		EOF
	else
		cat <<- EOF >>"$LOG_MAIN"

			`log-prefix` --- EXTERNAL PROCESS NOT STARTED ---

			`log-prefix` - Backup update not performed - FAILURE !
			`log-prefix` STDERR: $OUTPUT
		EOF
	fi

	if OUTPUT="`sudo umount "${PATH_EXTERNAL%/$PATH_DIR_LVL}" 2>&1`"; then
		if "$FLAG_MOUNT_MANU"; then sudo rmdir "${PATH_EXTERNAL%/$PATH_DIR_LVL}"; fi
	else
		cat <<- EOF >>"$LOG_MAIN"

			 - Unable to unmount disk (automatic) - FAILURE !
			`log-prefix` STDERR: $OUTPUT
		EOF
	fi

	message-ending

fi
