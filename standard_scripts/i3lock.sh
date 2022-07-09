#!/bin/sh

# troca o círculo pela bottom var
# --bar-indicator

# tamanho da barra na hora do click
# --bar-max-height 50

# tamanho da barra padrão que fica de fundo
# --bar-base-width 50

# cor da barra padrão que fica fixa no fundo
# --bar-color 000000cc

# cor da barra na hora do click
# --keyhl-color 880088cc

# posição do relógio
# --time-pos x+9:y+h-30

# cor do relógio
# --time-color 00ff94cc

# cor da data
# --date-color 00ff94cc

# posição da data
# --date-pos tx+3:ty+17

# cor da barra na hora da verificação
# --ringver-color 00ff94cc

# cor da barra caso na verificação de wrong
# --ringwrong-color ff008888

# posição do no input
# --status-pos x+625:y+h-400

# tira uma print antes do block e aplicar uma blear para deixar como background
# --blur 5 \

i3lock --color 00000000          \
\
--bar-indicator                  \
--bar-pos y+h                    \
--bar-direction 1                \
--bar-max-height 5               \
--bar-base-width 5               \
--bar-color 00000000             \
--keyhl-color 00ff94cc           \
--bshl-color ff0033cc            \
--bar-periodic-step 50           \
--bar-step 25                    \
--redraw-thread                  \
\
--clock                          \
--force-clock                    \
--time-pos x+9:y+h-30            \
--time-color ffffffff            \
--date-pos tx+3:ty+17            \
--date-color ffffffff            \
--date-align 1                   \
--time-align 1                   \
--ringver-color 00ff94cc         \
--ringwrong-color ff0033cc       \
--status-pos x+613:y+h-425       \
--verif-align 1                  \
--wrong-align 1                  \
--verif-color ffffffff           \
--wrong-color ffffffff           \
--ind-pos 613:345                \
\
--time-str="%H:%M:%S"            \
--date-str="%Y-%m-%d"            \
\
--verif-text='Verifying...'      \
--wrong-text='Keep Out!'         \
--noinput-text='No input?'       \
--lock-text='Locking...'         \
--lockfailed-text='Lock failed!'
