#!/bin/sh

# My custom "i3lock"

########################################################
# ----- withdrawn -----
# --keylayout 1                \
########################################################

BLANK='#00000000'
CLEAR='#00000000'
DEFAULT='#333333'
TEXT='#EEEEEE'
WRONG='#FF5D5DBB'
VERIFYING='#00FF94BB'
KEYHL='#DDDDDD'
TEXT_SIZES=22
BACKGROUND='#000000FF'

i3lock \
--insidever-color=$CLEAR         \
--ringver-color=$VERIFYING       \
\
--insidewrong-color=$CLEAR       \
--ringwrong-color=$WRONG         \
\
--inside-color=$BLANK            \
--ring-color=$DEFAULT            \
--line-color=$BLANK              \
--separator-color=$DEFAULT       \
\
--verif-color=$TEXT              \
--wrong-color=$TEXT              \
--time-color=$TEXT               \
--date-color=$TEXT               \
--layout-color=$TEXT             \
--keyhl-color=$KEYHL             \
--bshl-color=$WRONG              \
\
--screen 1                       \
--blur 15                        \
--clock                          \
--indicator                      \
--time-str="%H:%M:%S"            \
--date-str="%Y-%m-%d"            \
\
--verif-text='Verifying...'      \
--wrong-text='Keep Out!'         \
--noinput-text='No input?'       \
--lock-text='Locking...'         \
--lockfailed-text='Lock failed!' \
\
--verif-size=$TEXT_SIZES         \
--wrong-size=$TEXT_SIZES