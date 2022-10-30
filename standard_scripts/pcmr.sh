#!/usr/bin/env zsh

# Get the RAM consumption of some specific program.

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        echo -e "Passe o nome de algum programa para saber o consumo de RAM do mesmo.\n\tExemplo: ./$(basename ${0}) [-f|--full] chrome"
}

verify_privileges

[ ${#} -lt 1 -o "${1}" = '-h' -o "${1}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

# ---------- implementações -------------------------------------------------------------------------------------------------------------------
#
# 1. Fazer um cálculo para printar o resultado com cores diferente, pegar o tatal de RAM da máquina e caso seja 40% = verde, até 75% amarelo...
#
# ---------------------------------------------------------------------------------------------------------------------------------------------

# broken_flag=true
# if ${broken_flag}; then
# 	echo "Esse script precisa de ajustes! (caso queria usar mesmo assim, edite a flag como \"false\" dentro do script)\nSaindo..."
# 	exit 1
# fi

# Mensagem caso precise instalar o smem
no_installed(){
        echo -e "\e[40;37;1m
                \r${0}: ---------------------------------------------- \n \
                \r${0}: |   Necessário instalar o programa: SMEM     | \n \
                \r${0}: |                                            | \n \
                \r${0}: |   Enter - Prosseguir para a instalação     | \n \
                \r${0}: |   Ctrl+c - Cancelar                        | \n \
                \r${0}: ---------------------------------------------- \e[m\n"
}

# Converte o nome do programa em maiúsculo
lower_to_upper(){
	echo "${1}" | tr '[:lower:]' '[:upper:]'
}

# Verifica se o smem está instalado, caso não, prossegue para a instalação
# ---------------------------------------------------------------
# Poderia chamar diretamente o "dpkg -l <program>" num if negado
# ---------------------------------------------------------------
if ! (dpkg -l smem >/dev/null 2>&1); then
        no_installed && \
        read readkey && \
        sudo apt install smem -y
fi

[ "${1}" = "-f" -o "${1}" = "--full" ] && {
        if ! (dpkg -l ${2} >/dev/null 2>&1); then
                echo "Programa pode não existir..."
        fi
        smem -aktP ${2}
} || {
        if ! (dpkg -l ${1} >/dev/null 2>&1); then
                echo "Programa pode não existir..."
        fi
        echo -e "\e[1m$(lower_to_upper ${1})\e[m: $(smem -aktP ${1} | tail -1 | tr -s ' ' | cut -d ' ' -f 5) (RAM)"
}
