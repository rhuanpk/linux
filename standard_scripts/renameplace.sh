#!/usr/bin/env zsh

# Variáveis
LINHA_FINAL='\n>>> ----------- !\n'

# Variáveis » Cores
VERMELHO_NEGRITO='\e[1;31m'
AMARELO_NEGRITO='\e[1;33m'
AMARELO='\e[33m'
AZUL='\e[34m'
NEGRITO='\e[1m'
PISCA_RAPIDO='\e[6m'
RESET_COLOR='\e[m'

# Funções
OPT_INV(){
    echo -en "\nOpção inválida ! <press_enter>"; read X
}

msg_saida(){
    local INDEX_MAX=5
    clear
    for ((i=0;i<=1;++i)); do
        echo -e "\n\t${NEGRITO}*** OBRIGADO ***${RESET_COLOR}\n"
        for ((j=0;j<=${INDEX_MAX};++j)); do
            [[ ${j} -eq 0 ]] && echo -en "Encerrando "
            sleep 0.5
            echo -n "${PISCA_RAPIDO}.${RESET_COLOR}"
            [[ ${j} -eq ${INDEX_MAX} ]] && clear
        done
    done
    echo ""
    clear
}

espacos_branco(){
    espaco_por_carac(){
        clear
        echo -en "\nEntre com o caracter que deseja trocar por um espaço em branco: "
        read SIMBOLO
        for var in *; do
            mv ${var} ${var//${SIMBOLO}/ }
        done
    }
    carac_por_espaco(){
        clear
        echo -en "\nEntre com o caracter a ser colocado no lugar do espaço em branco "
        echo -en "(não aceitos os caracteres '<', '>', ':', '\"', '/', '\', '|', '?', '*'): "
        read SIMBOLO
        for var in *; do
            mv ${var} ${var// /${SIMBOLO}}
        done
    }
    MENU_FLAG=0
    while [ ${MENU_FLAG} -eq 0 ]; do
        clear
        echo -e "\n*** ${NEGRITO}Listagem do Diretório${RESET_COLOR} ***\n"
        ls -1hF --color
        echo -e "\n1. Colocar ${AMARELO}espaço em branco${RESET_COLOR} no lugar de ${AMARELO}algum caracter${RESET_COLOR}\n\
        \r2. Colocar ${AMARELO}algum caracter${RESET_COLOR} no lugar de um ${AMARELO}espaço em branco${RESET_COLOR}\n\
        \r3. ${AZUL}Voltar${RESET_COLOR}\n\
        \r0. ${VERMELHO_NEGRITO}SAIR${RESET_COLOR}\n"
        echo -n "Escolha: "
        read OPCAO
        case ${OPCAO} in
            1) espaco_por_carac ;;
            2) carac_por_espaco ;;
            3) menu ;;
            0) msg_saida; exit 0 ;;
            *) OPT_INV ;;
        esac
    done
}

minu_maiu(){
    minu(){
        clear
        for var in *; do
            mv ${var} $(echo "${var}" | tr '[:lower:]' '[:upper:]')
        done
    }
    maiu(){
        clear
        for var in *; do
            mv ${var} $(echo "${var}" | tr '[:upper:]' '[:lower:]')
        done
    }
    MENU_FLAG=0
    while [ ${MENU_FLAG} -eq 0 ]; do
        clear
        echo -e "\n*** ${NEGRITO}Listagem do Diretório${RESET_COLOR} ***\n"
        ls -1hF --color
        echo -e "\n1. Transformar ${AMARELO}minúsculas${RESET_COLOR} em ${AMARELO}MAIÚSCULAS${RESET_COLOR}\n\
        \r2. Transformar ${AMARELO}maiúsculas${RESET_COLOR} em ${AMARELO}MINÚSCULAS${RESET_COLOR}\n\
        \r3. ${AZUL}Voltar${RESET_COLOR}\n\
        \r0. ${VERMELHO_NEGRITO}SAIR${RESET_COLOR}\n"
        echo -n "Escolha: "
        read OPCAO
        case ${OPCAO} in
            1) minu ;;
            2) maiu ;;
            3) menu ;;
            0) msg_saida; exit 0 ;;
            *) OPT_INV ;;
        esac
    done
}

# Programa
menu(){
    MENU_FLAG=0
    while [ ${MENU_FLAG} -eq 0 ]; do
        clear
        echo -e "\n>>> ${NEGRITO}ReNamePlace${RESET_COLOR} !\n\n\
        \rEscolha as opções de renomeação\n\
        1. Retirar ou Colocar ${AMARELO_NEGRITO}ESPAÇOS EM BRANCO${RESET_COLOR}\n\
        2. Trocar ${AMARELO_NEGRITO}MAIÚSCULAS POR MINÚSCULAS${RESET_COLOR}\n\
        3. ${AZUL}Listar o diretório corrente${RESET_COLOR}\n\
        0. ${VERMELHO_NEGRITO}SAIR${RESET_COLOR}\n"
        echo -n "Escolha: "
        read OPCAO
        case ${OPCAO} in
            1) espacos_branco ;;
            2) minu_maiu ;;
            3) echo ""; ls -1hF --color; echo -en "\n<press_enter>"; read X ;;
            0) msg_saida; exit 0 ;;
            *) OPT_INV ;;
        esac
        echo "${LINHA_FINAL}"
    done
}

menu
