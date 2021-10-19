#!/usr/bin/env bash

########################################################
# Sessão de declaração de variáveis
########################################################

# Variáveis para o backup

data="$(date +"%d-%m-%y")"
arquivo="${data}_backup.tar.gz"
busca=("${HOME}/Documentos" "${HOME}/Downloads" "${HOME}/Imagens" "${HOME}/Vídeos")
main="${HOME}/backup"
destino="${HOME}/Cloud/backup"
montagem="/root/mnt/back-up"
arquivo_log="/var/log/backup_diario.log"

# Variáveis para guardar parte das mensagens de log

msg_cloud="processo NUVEM"
msg_ext="processo EXTERNO"

# Variável para guardar a senha do sudo

password="12345"

########################################################
# Sessão de declaração de funções
########################################################

# Função para executar o comando sudo automáticamente

auto_sudo() {
	echo -e "${password}\n" | sudo -S ${1}
}

########################################################
# Início do programa
########################################################

# --- Preparação do diretorio com as pastas a serem backpeadas ---

rm -rfv ${main}/*

for (( i = 0; i < ${#busca[@]}; ++i )); do
        cp -rv ${busca[i]} ${main}
done

# --- Backup para armazenamento em Cloud ---

# Remoção do backup antigo ---> (PROCESSO EXCLUSÃO)

if rm -rfv ${destino}/*.tar.gz 2> /dev/null; then
	echo -e "[${data}] - Backup antigo excluido! (${msg_cloud} EXCLUSÃO) - SUCESSO" >> ${arquivo_log}
	excluido_nuvem=0
else
	echo -e "[${data}] - Backup antigo não excluido! (${msg_cloud} EXCLUSÃO) - FALHA" >> ${arquivo_log}
	excluido_nuvem=1
fi	

# Criação do novo backup ---> (PROCESSO DE ADIÇÃO)

if [ ${excluido_nuvem} -eq 0 ]; then
	if tar -zcvf ${destino}/${arquivo} ${main} 2> /dev/null; then
		echo -e "[${data}] - Novo backup criado! (${msg_cloud} ADIÇÃO) - SUCESSO" >> ${arquivo_log}
	else
		echo -e "[${data}] - Novo backup não criado! (${msg_cloud} ADIÇÃO) - FALHA" >> ${arquivo_log}
	fi
fi

# --- Backup para o armazenamento externo ---

# Verifica se o exite o ponto para montagem do disco externo, caso não existir, seja criado ---> (PROCESSO 1)

if [ ! -d ${montagem} ]; then
	auto_sudo "mkdir -pv ${montagem}"
	if [ ! -d ${montagem} ]; then
		echo -e "[${data}] - Diretorio de montagem não criado (${msg_ext} 1) - FALHA" >> ${arquivo_log}
		cria_ponto=1
	fi
	echo -e "[${data}] - Diretorio de montagem criado (${msg_ext} 1) - SUCESSO" >> ${arquivo_log}
	cria_ponto=0
else
	echo -e "[${data}] - Diretorio de montagem já existente (${msg_ext} 1) - SUCESSO" >> ${arquivo_log}
	cria_ponto=0
fi

# Verificar se o disco externo está montado, se não estiver, tenta montar ---> (PROCESSO 2)

if [ ${cria_ponto} -eq 0 ]; then 
	if mountpoint ${montagem}; then
     		echo -e "[${data}] - Disco externo já esta montado em ${montagem} (${msg_ext} 2) - SUCESSO" >> ${arquivo_log}
      		montado=0
	else
		auto_sudo "mount /dev/sdb1 ${montagem}" 2>> ${arquivo_log}
		if ! mountpoint ${montagem}; then
			echo -e "[${data}] - Disco externo não montado em ${montagem} (${msg_ext} 2) - FALHA" >> ${arquivo_log}
			montado=1
		else
			echo -e "[${data}] - Disco externo montado em ${montagem} (${msg_ext} 2) - SUCESSO" >> ${arquivo_log}
			montado=0
		fi
	fi
fi

# Backup para o disco externo ---> (PROCESSO 3)

if [ ${montado} -eq 0 ]; then

	# Remoção do backup antigo no disco externo

	if rm -rfv ${montagem}/*.tar.gz 2> /dev/null; then
		echo -e "[${data}] - Backup antigo excluido! (${msg_ext} 3 1/2) - SUCESSO" >> ${arquivo_log}
		excluido=0
	else
		echo -e "[${data}] - Backup antigo não excluido! (${msg_ext} 3 1/2) - FALHA" >> ${arquivo_log}
		excluido=1
	fi

	# Criação do novo arquivo de backup
	
	if [ ${excluido} -eq 0 ]; then
		if tar -zcvf ${montagem}/${arquivo} ${main} 2> /dev/null; then
			echo -e "[${data}] - Novo backup criado! (${msg_ext} 3 2/2) - SUCESSO" >> ${arquivo_log}
		else
			echo -e "[${data}] - Novo backup não criado! (${msg_ext} 3 2/2) - FALHA" >> ${arquivo_log}	
		fi
	fi

fi
