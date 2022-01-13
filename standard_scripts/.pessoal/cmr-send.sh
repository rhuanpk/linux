#!/usr/bin/env bash

#### para rodar o programa ############
# nohup repita.sh 'cmr-send.sh' '30' &
#######################################

#### para encerrar o programa ###########################################################
# kill -TERM $(ps -e -o pid,cmd | grep 'repita' | grep 'cmr-send.sh' | awk '{print $1}')
#########################################################################################

CRMMSG=2
CRAM=$(free -h | tr ' ' '-' | cut -d '-' -f 18 | sed '/^$/d' | cut -d ',' -f 1 | head -n 1)

# [ ${CRAM} -ge ${CRMMSG} ] && noti -t "Consumo de RAM!" -m "O consumo de memória RAM está acima de ${CRMMSG}G."
[ ${CRAM} -ge ${CRMMSG} ] && notify-send "Consumo de RAM!" "O consumo de memória RAM está acima de ${CRMMSG}G."

