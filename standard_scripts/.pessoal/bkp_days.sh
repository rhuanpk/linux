#!/usr/bin/env bash

path=${1}
dia_atual=$(date "+%d")

qtd_arquivos=$(ls -1 ${path} | grep -c '.*')
for ((i=0;i<${qtd_arquivos};++i)); do
	# Outra forma de pegar a data de crição dos arquivos usando o ls com a opção alongada:
	# ls -l ${path} | tr -s ' ' | cut -d ' ' -f '7' | sed '/^$/d' | sed -n "$((${i}+1))p")
	dias_criacao[${i}]=$(ls -1 ${path} | sed -n "$((${i}+1))p" | cut -c '1-2')
	nomes_arquivos[${i}]=$(ls -1 ${path} | sed -n "$((${i}+1))p")
	echo "nome arquivo [${i}]: ${nomes_arquivos[${i}]} - dia criacao [${i}]: ${dias_criacao[${i}]} - data atual [${i}]: ${dia_atual}"
	echo "diff dia hoje [${i}]: $((${dia_atual}-${dias_criacao[${i}]}))"
	sleep 1
done
