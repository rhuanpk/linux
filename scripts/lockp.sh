#!/bin/sh

# disable notifications
dunstctl set-paused 'true' && polybar-msg action '#dunst.hook.1'

# mute audio
wpctl set-mute '@DEFAULT_AUDIO_SINK@' 1

# lock screen
i3lock --nofork --color 00000000 \
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
--lockfailed-text=''             \
\
|| i3lock --nofork --color 000000
