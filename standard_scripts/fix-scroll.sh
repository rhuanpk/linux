#!/usr/bin/env bash

# Inverte o sentido de rolagem do scroll.
# Rodar: $ synclient ->
# -> Retorna: Valores do scroll, colocar o valor oposto no lugar dos "-79"

synclient VertScrollDelta=-79
synclient HorizScrollDelta=-79
