#!/bin/sh

# disable notifications
dunstctl set-paused 'true' && polybar-msg action '#dunst.hook.1'

# mute audio
wpctl set-mute '@DEFAULT_AUDIO_SINK@' 1

# troca o círculo pela bottom bar
#--bar-indicator

# tamanho da barra na hora do click
#--bar-max-height 50

# tamanho da barra padrão que fica de fundo
#--bar-base-width 50

# cor da barra padrão que fica fixa no fundo
#--bar-color 000000cc

# cor da barra na hora do click
#--keyhl-color 880088cc

# posição do relógio
#--time-pos x+9:y+h-30

# cor do relógio
#--time-color 00ff94cc

# cor da data
#--date-color 00ff94cc

# posição da data
#--date-pos tx+3:ty+17

# cor da barra na hora da verificação
#--ringver-color 00ff94cc

# cor da barra caso na verificação de wrong
#--ringwrong-color ff008888

# posição do no input
#--status-pos x+625:y+h-400

# tira uma print antes do block e aplicar uma blear para deixar como background
#--blur 5

i3lock --color 00000000          \
\
--bar-indicator                  \
--bar-pos y+h                    \
--bar-direction 1                \
--bar-max-height 1               \
--bar-base-width 1               \
--bar-color 00000000             \
--keyhl-color 00000000           \
--bshl-color 00000000            \
\
--clock                          \
--force-clock                    \
--time-color ffffffff            \
--date-color ffffffff            \
--ringver-color 00000000         \
--ringwrong-color ff0033cc       \
\
--time-str="%H:%M:%S"            \
--date-str="%Y-%m-%d"            \
\
--verif-text=''                  \
--wrong-text=''                  \
--noinput-text=''                \
--lock-text=''                   \
--lockfailed-text=''
