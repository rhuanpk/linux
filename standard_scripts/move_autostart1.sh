#!/usr/bin/env bash

print_usage() {
	echo -e "Usage: move_autostart <-mc> [-h]\n\n\t-h: print this message and exit with 0\n\t-m: move para a pasta de destino\n\t-c: trás de volta para a pasta de origem"
}

while getopts 'mch' opts 2> /dev/null; do
	case ${opts} in
		m) active=0
		   ;;
		c) active=1
		   ;;
		h) print_usage
		   exit 0
		   ;;
		?) print_usage
		   exit 1
		   ;;
		esac
done

if [ "${1}" = "" -o "${1}" = " " ]; then
	print_usage
	exit 1
fi

path_origin=~/.config/autostart/
path_destine=~/.config/autostart/off/

if [ ${active} -eq 0 ]; then
	mv ${path_origin}
elif [ ${active} -eq 1 ]; then
	mv ${path_destine}
fi
