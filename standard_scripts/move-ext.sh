#!/usr/bin/env bash

print_usage() {
	echo -e "Uso:\n\tmove_autostart <-mc> [-hsv]\n\n\t-h : printa essa mensagem e sai\n\t-m : move para a pasta de destino\n\t-c : trás de volta para a pasta de origem\n\t-s : seta caminho de origim e destino e a extensão\n\t\texemplo de path: /home/user/documents\n\t\texemplo de exntesão: .txt\n\t-v : mostra as configurações setadas e sai"
}

print_set() {
	echo "Caminho de origem: ${path_origin}"
	echo "Caminho de destino: ${path_destine}"
	echo "Extensão corrente: ${extension}"
}

while getopts 'mchsv' opts 2> /dev/null; do
	case ${opts} in
		m) ACTIVE=0
		   ;;
		c) ACTIVE=1
		   ;;
		h) print_usage
		   exit 0
		   ;;
		s)	SET=1
			;;
		v) print_set
			exit 0
			;;
		?) print_usage
		   exit 1
		   ;;
		esac
done

if [ "${1}" == "" -o "${1}" == " " ]; then
	print_usage
	exit 1
fi

if [ ${SET} -eq 1 ]; then
	read -p "Path de origem: " path_origin
	read -p "Path de destino: " path_destine
	read -p "Extensão: " extension
	exit 0
fi

if [ ${ACTIVE} -eq 0 ]; then
	echo "${path_origin}"
	echo "${path_destine}"
	echo "${extension}"
#	mv ${path_origin}/*${extension} ${path_destine}
elif [ ${ACTIVE} -eq 1 ]; then
	echo "${path_origin}"
	echo "${path_destine}"
	echo "${extension}"
#	mv ${path_destine}/*${extension} ${path_origin}
fi
