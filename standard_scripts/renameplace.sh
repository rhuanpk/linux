#!/usr/bin/env zsh

################################################## Variáveis ##################################################

# Variáveis » Cores
RESET_COLOR='\e[m'
VERMELHO_NEGRITO='\e[1;31m'
AMARELO_NEGRITO='\e[1;33m'
VERDE='\e[32m'
AMARELO='\e[33m'
AZUL='\e[34m'
ROSA='\e[35m'
CIANO='\e[36m'
NEGRITO='\e[1m'
PISCA_RAPIDO='\e[6m'
BG_PRETO_FG_VERMELHO_NEGRITO='\e[1;40;33m'

################################################## Funções ##################################################

########## Informa que a opção escolhida é inválida e espera algum entrada do usuário ##########
OPT_INV(){
    echo -en "\nOpção inválida ! <press_enter>"; read readkey
}

########## Mensagem animada de saida ##########
msg_saida(){
    local INDEX_MAX=3
    clear
    for ((i=0;i<=2;++i)); do
        echo -e "\n\t${NEGRITO}*** OBRIGADO ***${RESET_COLOR}\n"
        for ((j=0;j<=${INDEX_MAX};++j)); do
            [[ ${j} -eq 0 ]] && echo -en "Encerrando "
            sleep 0.1
            echo -n "."
            [[ ${j} -eq ${INDEX_MAX} ]] && clear
        done
    done
    echo ""
    clear
}

########## Função para listagem do diretorio corrente ##########
lista_dir(){
	ls -1hF --color
}

########## Função que cria um pasta segura (na /tmp) e alguns arquivos para teste ##########
modo_teste(){
    echo -ne "\nCriar uma pasta segura para testes em \"/tmp/tmp\", é movido para ela e gera arquivos aleátorios para testes! [Y/n]? "; read OPCAO
    if [ "${OPCAO}" = "" -o "${OPCAO}" = "y" -o "${OPCAO}" = "Y" ]; then
        [ ! -e /tmp/tmp ] && mkdir -v /tmp/tmp; cd /tmp/tmp || cd /tmp/tmp
    	touch file-{1..4}.{txt,md,new,tmp}
    fi
}

########## Função "main" da primeira opção do menu que trata dos espaços em branco ##########
espacos_branco(){

    # Retira espaços em branco
    espaco_por_carac(){
        clear
        echo ""
        lista_dir
        echo -en "\nDigite o caracter que será removido, para inserir o(s) espaço(s) em branco no lugar: "; read SIMBOLO
        for var in *; do
            mv ${var} ${var//${SIMBOLO}/ }
        done
    }

    # Coloca espaços em branco
    carac_por_espaco(){
	    clear
	    echo ""
        lista_dir
	    echo -en "\nDigite o caracter que será colocado no lugar do(s) espaço(s) em branco "
        echo -en "(não aceitos os caracteres '<', '>', ':', '\"', '/', '\', '|', '?', '*'): "; read SIMBOLO
        for var in *; do
            mv ${var} ${var// /${SIMBOLO}}
        done
    }

    # Menu particular do que trata dos espaços em branco
    while :; do
        clear
        echo -e "\n>>> Espaços em branco !\n \
        \n\r*** ${NEGRITO}Listagem do Diretório${RESET_COLOR} ***\n"
        lista_dir
        echo -e "\n1. ${AMARELO}Colocar${RESET_COLOR} ---> ${AMARELO}ESPAÇO(S) EM BRANCO${RESET_COLOR}\n \
	    \r2. ${AMARELO}Retirar${RESET_COLOR} ---> ${AMARELO}ESPAÇO(S) EM BRANCO${RESET_COLOR}\n \
        \r9. ${AZUL}Voltar${RESET_COLOR}\n \
        \r0. ${VERMELHO_NEGRITO}SAIR${RESET_COLOR}\n"
        echo -n "Escolha: "; read OPCAO
        case ${OPCAO} in
            1) espaco_por_carac;;
            2) carac_por_espaco;;
            9) menu;;
            0) msg_saida; exit 0;;
            *) OPT_INV;;
        esac
    done
}

########## Função "main" da segunda opção do menu que trata das letras maiúsculas e minúsculas ##########
minu_maiu(){

    # Transforma em MAIÚSCULAS
    minu(){
        clear
        for var in *; do
            mv ${var} $(echo "${var}" | tr '[:lower:]' '[:upper:]')
        done
    }

    # Transforma MINÚSCULAS
    maiu(){
        clear
        for var in *; do
            mv ${var} $(echo "${var}" | tr '[:upper:]' '[:lower:]')
        done
    }

    # Menu particular do que trata das letras maiúsculas e minúsculas
    while :; do
        clear
        echo -e "\n>>> Maiúsculas e Minúsculas !\n \
        \n\r*** ${NEGRITO}Listagem do Diretório${RESET_COLOR} ***\n"
        lista_dir
        echo -e "\n1. ${AMARELO}Para${RESET_COLOR} ---> ${AMARELO}MAIÚSCULAS${RESET_COLOR}\n \
        \r2. ${AMARELO}Para${RESET_COLOR} ---> ${AMARELO}minúsculas${RESET_COLOR}\n \
        \r9. ${AZUL}Voltar${RESET_COLOR}\n \
        \r0. ${VERMELHO_NEGRITO}SAIR${RESET_COLOR}\n"
        echo -n "Escolha: "; read OPCAO
        case ${OPCAO} in
            1) minu;;
            2) maiu;;
            9) menu;;
            0) msg_saida; exit 0;;
            *) OPT_INV;;
        esac
    done
}

########## Função "main" da terceira opção do menu que trata da manipução do nome dos arquivos ##########
nome_arquivo(){

    # Adiciona alguma string no final do nome do arquivo
    add_final(){
        clear
        echo -e "\n>>> Adicionar/Remover do Inicio/Final !\n \
        \n\r- Para voltar ao menu anterior sem fazer nada: <enter>\n \
        \n\r*** ${NEGRITO}Listagem do Diretório${RESET_COLOR} ***\n"
        lista_dir
        echo -ne "\nEntre com a ${AMARELO_NEGRITO}string a ser adicionada ao final do nome${RESET_COLOR} de cada arquivo: "; read STRING
        for i in *; do mv ${i} ${i//*/${i}${STRING}}; done
    }

    # Remove alguma string do final do nome do arquivo
    remove_final(){
        clear
        echo -e "\n>>> Adicionar/Remover do Inicio/Final !\n \
        \n\r- Para voltar ao menu anterior sem fazer nada: <enter>\n \
        \n\r*** ${NEGRITO}Listagem do Diretório${RESET_COLOR} ***\n"
        lista_dir
        echo -ne "\nEntre com a ${AMARELO_NEGRITO}string a ser removida do final do nome${RESET_COLOR} de cada arquivo: "; read STRING
        for i in *; do mv ${i} ${i%%${STRING}}; done
    }

    # Adiciona alguma string no inicio do nome do arquivo
    add_inicio(){
        clear
        echo -e "\n>>> Adicionar/Remover do Inicio/Final !\n \
        \n\r- Para voltar ao menu anterior sem fazer nada: <enter>\n \
        \n\r*** ${NEGRITO}Listagem do Diretório${RESET_COLOR} ***\n"
        lista_dir
        echo -ne "\nEntre com a ${AMARELO_NEGRITO}string a ser adicionada ao inicio do nome${RESET_COLOR} de cada arquivo: "; read STRING
        for i in *; do mv ${i} ${STRING}${i}; done
    }
    
    # Remove alguma string do inicio do nome do arquivo
    remove_inicio(){
        clear
        echo -e "\n>>> Adicionar/Remover do Inicio/Final !\n \
        \n\r- Para voltar ao menu anterior sem fazer nada: <enter>\n \
        \n\r*** ${NEGRITO}Listagem do Diretório${RESET_COLOR} ***\n"
        lista_dir
        echo -ne "\nEntre com a ${AMARELO_NEGRITO}string a ser removida do inicio do nome${RESET_COLOR} de cada arquivo (até 12 caracteres): "; read STRING
        for i in *; do mv ${i} ${i##${STRING}}; done
    }

    # Manipula o nome de algum arquivo independente do índice da string
    manipula_indice(){
        clear
        echo -e "\n>>> Renomear string específica !\n \
        \n\r- Para voltar ao menu anterior sem fazer nada <press_enter> nas duas entradas de dados\n \
        \n\r*** ${NEGRITO}Listagem do Diretório${RESET_COLOR} ***\n"
        lista_dir
        echo -e "\nRenomeia todos os arquivos trocando um parte da string por outra, definindo a string de entrada e saida!\n"
        echo -n "String de entrada: "; read ENTRADA
        echo -n "String de saida: "; read SAIDA
        string_entrada_string_saida(){
            [ ${#} -eq 0 ] && { echo "Argumentos não informados! <press_enter>"; read readkey; nome_arquivo ;}
            FILE="$(mktemp XXXXX.tmp)"
            [ ${#} -lt 2 ] && SEGUNDO="" || SEGUNDO="${2}"
            for i in *; do
                basename ${i} > ${FILE}
                mv ./${i} ./$(sed "s/${1}/${SEGUNDO}/g" ${FILE})
            done
            rm ${FILE}
        }
        string_entrada_string_saida "${ENTRADA}" "${SAIDA}"
    }

    # Criar um padrão de nome para conseguir renomer todos como mesmo nome
    cria_padrao(){
        clear
        echo -ne "\n>>> Criar padronização !\n \
        \n\rSe continuar o programa renomeara todos os arquivos do diretório corrente\n \
        \rpara um padrão de nome, usando como caracteres de sequência, caracteres numéricos (0-9).\n \
        \r- Para voltar ao menu anterior digite: quit\n \
        \n\rExemplo: \n \
        \n\r _1.txt\n \
        \r _2.txt\n \
        \r _3.txt\n \
        \r _4.txt\n \
        \r ...\n \
        \n*** ${NEGRITO}Listagem do Diretório${RESET_COLOR} ***\n\n"
        lista_dir
        echo -n "\nEntre com o a extenção dos arquivos (simplesmente <enter> caso queria sem extensão): "; read EXTENSAO
        [ "${EXTENSAO}" != "quit" ] && { n=1; for i in *; do mv ${i} _${n}${EXTENSAO}; let ++n; done ;}
    }

    # Modo customizado para renomeação dos arquivos renomeando um por um individualmente
    customizado(){
        pega_nome(){
            echo "$(ls -1 | sed -n "${1}p")"
        }
        LINHAS=$(ls -1 | grep -c ".")
        for i in $(seq ${LINHAS}); do
            NOMES[${i}]=$(pega_nome ${i})
        done
        let ++LINHAS
        for i in $(seq ${LINHAS}); do
            clear
            echo -e "\n>>> Rename customizado !\n \
            \r\n- Para não renomear qualquer arquivo basta teclar <enter>\n \
            \r- Para parar e voltar ao menu anterior digite: quit\n"
            for ((j=1;j<${LINHAS};++j)); do
                [ "${NOMES[${i}]}" = "$(pega_nome ${j})" ] && echo -e "${BG_PRETO_FG_VERMELHO_NEGRITO}$(pega_nome ${j})${RESET_COLOR}" || echo -e "$(pega_nome ${j})"
            done
            if [ ${i} -lt ${LINHAS} ]; then
                echo -en "\nEntre com o novo nome do arquivo \"${NOMES[${i}]}\": "; read NOVO_NOME
                [ "${NOVO_NOME}" = "quit" ] && break
                mv ${NOMES[${i}]} ${NOVO_NOME} 2>/dev/null
            fi
        done
        echo ""
    } 

    # Sub Menu particular que trata das renomeação no inicio e no final dos arquivos
    sub_menu_rename(){
        while :; do
            clear
            echo -e "\n>>> Adicionar/Remover do Inicio/Final !\n \
            \n\r*** ${NEGRITO}Listagem do Diretório${RESET_COLOR} ***\n"
            lista_dir
            echo -e "\n1. ${VERDE}Adiciona${RESET_COLOR} alguma string no ${VERDE}final${RESET_COLOR} do nome do arquivo: *+\"-off\"\n \
            \r2. ${ROSA}Remove${RESET_COLOR} alguma string do ${ROSA}final${RESET_COLOR} do nome do arquivo: *-\".old\"\n \
            \r3. ${VERDE}Adiciona${RESET_COLOR} alguma string no ${VERDE}inicio${RESET_COLOR} do nome do arquivo: \"imagem-\"+*\n \
            \r4. ${ROSA}Remove${RESET_COLOR} alguma string do ${ROSA}inicio${RESET_COLOR} do nome do arquivo: \"temas_\"-*\n \
            \r9. ${AZUL}Voltar${RESET_COLOR}\n \
            \r0. ${VERMELHO_NEGRITO}SAIR${RESET_COLOR}\n"
            echo -n "Escolha: "; read OPCAO
            case ${OPCAO} in
                1) add_final;;
                2) remove_final;;
                3) add_inicio;;
                4) remove_inicio;;
                9) nome_arquivo;;
                0) msg_saida; exit 0;;
                *) OPT_INV;;
            esac
        done
    }

    # Menu particular do que trata da manipulação do nome dos arquivos
    while :; do
        clear
        echo -e "\n>>> Manipulação de arquivos !\n \
        \n\r*** ${NEGRITO}Listagem do Diretório${RESET_COLOR} ***\n"
        lista_dir
        echo -e "\n1. ${AMARELO}Adicionar${RESET_COLOR} ou ${AMARELO}Remover${RESET_COLOR} string no ${AMARELO}Inicio${RESET_COLOR} ou ${AMARELO}Final${RESET_COLOR} do nome\n \
        \r2. Cria ${AMARELO}padrão de nome${RESET_COLOR}\n \
        \r3. ${AMARELO}Renomeia parte do nome${RESET_COLOR}\n \
        \r4. ${AMARELO_NEGRITO}Renomeção customizada${RESET_COLOR} compelta\n \
        \r9. ${AZUL}Voltar${RESET_COLOR}\n \
        \r0. ${VERMELHO_NEGRITO}SAIR${RESET_COLOR}\n"
        echo -n "Escolha: "; read OPCAO
        case ${OPCAO} in
            1) sub_menu_rename;;
            2) cria_padrao;;
            3) manipula_indice;;
            4) customizado;;
            9) menu;;
            0) msg_saida; exit 0;;
            *) OPT_INV;;
        esac
    done

}

################################################## Inicio ##################################################

# Função main do programa
menu(){
    while :; do
        clear
        echo -e "\n>>> ${NEGRITO}ReNamePlace${RESET_COLOR} !\n\n \
        \rEscolha as opções de renomeação\n \
     	\r\t1. Retirar ou Colocar ${AMARELO_NEGRITO}ESPAÇOS EM BRANCO${RESET_COLOR}\n \
        \r\t2. Trocar ${AMARELO_NEGRITO}MAIÚSCULAS POR MINÚSCULAS${RESET_COLOR}\n \
        \r\t3. Manipular ${AMARELO_NEGRITO}NOME DOS ARQUIVOS${RESET_COLOR}\n \
        \r\t4. ${AMARELO_NEGRITO}Modo Teste${RESET_COLOR}\n \
        \r\t5. ${AZUL}Listar o diretório corrente${RESET_COLOR}\n \
        \r\t0. ${VERMELHO_NEGRITO}SAIR${RESET_COLOR}\n"
        echo -n "Escolha: "; read OPCAO
        case ${OPCAO} in
            1) espacos_branco;;
            2) minu_maiu;;
            3) nome_arquivo;;
	    4) modo_teste;;
	    5) echo ""; lista_dir; echo -en "\n<press_enter>"; read readkey;;
            0) msg_saida; exit 0;;
            *) OPT_INV;;
        esac
    done
}

menu
