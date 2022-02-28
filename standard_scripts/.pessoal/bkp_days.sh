#!/usr/bin/env bash

path=${1}
dia_atual=$(date "+%d")

qtd_arquivos=$(ls -1 | grep -c '.*')
for ((i=0;i<${qtd_arquivos};++i)); do
	dia_criacao[${i}]=$(ls -l ${path} | tr -s ' ' | cut -d ' ' -f '7' | sed '/^$/d' | sed -n "${i}p")
	nome_arquivos[${i}]=$(ls -1 | sed -n "${i}p")
	echo "nome arquivo [${i}]: ${nome_arquivo[${i}]} - dia criacao [${i}]: ${dia_criacao[${i}]}"
done
