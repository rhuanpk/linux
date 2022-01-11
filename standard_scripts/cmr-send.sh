#!/usr/bin/env bash

CRAM=$(free -h | tr ' ' '-' | cut -d '-' -f 18 | sed '/^$/d' | cut -d ',' -f 1)
[ ${CRAM} -ge 4 ] && notify-send 'Consumo de RAM!' 'O consumo de RAM está acima de 4G.'
