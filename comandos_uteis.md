>>> Comandos Aleatoriamente úteis !

-----------------------------------------------------------------------------------------------------

* script cork

wget 'https://raw.githubusercontent.com/rhuan-pk/cork/master/cork.sh'
sudo chmod +x cork.sh

-----------------------------------------------------------------------------------------------------

* git 

# renomear repositorio remoto

git remote rename <nome_atual> <novo_nome>

# pasta inacessivel (pasta com submodule)

1) git rm --cached <nome_pasta>
2) rm -Rf <nome_pasta>/.git
3) git add .
4) git push origin master

# manipulação de branch

   # mostra branchs locais
   git branch ou $ git branch --list 

   # mostra branchs remotas
   git branch --remotes --list

   # mostra além das branchs remotas, outras infos
   git remote show <nome_remoto> 

   # trocar de branch
   git checkout <nome_branch>

   # cria e muda para uma nova ramificação
   git checkout -b <nova_branch> 

   # remove branch local
   git branch -d <nome_branch> 

   # força exclusão da branch
   git branch -D <nome_branch> 

   # remove branch remoto
   git push origin :<branch_remoto> 
   
   # remove branch remoto
   git push origin --delete <branch_remoto> 

# visualização de log's

   # mostro os log's por completo
   git log
   
   # mostra os log's resumidos
   git log --oneline

   # mostra por completo o gráfico de nodles
   git log --graph --all
   
   # mostra de forma resumida o gráfico de nodles
   git log --oneline --graph --all

# blame

   # mostra um histórico de alteraçẽos realizadas
   git blame <nome_do_arquivo>

   # -w: remove espaços em branco; -L: limita a faixa de linhas
   git blame -w -L 1,12 <nome_do_arquivo>

# clone

   # clonar de uma branch específica
   git clone -b <branch_name> <url_clone>

# setando e removendo token pessoal de acesso (github)
   
   # setando pelo cache
      git config --global credential.helper 'cache --timeout=28800'

      # removendo
      git credential-cache exit

   # setando da maneira "correta"? (usando keyring)
      1) instalar o make (make developer tools)
         1.1) sudo snap install ubuntu-make --classic
         1.2) sudo snap install ubuntu-make --edge
         1.3) sudo snap refresh ubuntu-make
      2) sudo apt install gcc build-essential
      3) sudo apt-get install libsecret-1-0 libsecret-1-dev
      4) cd /usr/share/doc/git/contrib/credential/libsecret
      5) sudo make
      6) git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
         
      # removendo
      git config --global --unset credential.helper

# para manipular informações do usuários

vim ~/.gitconfig

# restaurar repo a um commit específico

# tenha o log em mãos
1) git log --oneline
2) git reset --hard 1aa0da8

* github cli

# ver os repositórios remotos

gh repo list

# pull request

   # para criar pull request
   
   1) entrar na ramificação em desenvolvimento e commitar as alterações
      1.1) git checkout dev
      1.2) git add .
      1.3) git commit -m "mensagem"
   # criar o pull request informando a branch que ele será mergado
   2) gh pr create --base master

   # listar os pr's ativos
   gh pr list

   # listar todos os pr's
   gh pr view

   # aceitar o pull request
   gh pr review --aprrove

-----------------------------------------------------------------------------------------------------

* manipulando variável PS1

# exibir branch no terminal (bash)

export PS1='\[\033[01;32m\]\u@\h\[\033[01;37m\]:\[\033[00m\]\[\033[01;34m\]\w\[\033[0;35m\]$(__git_ps1 "(%s)")\[\033[01;37m\]$\[\033[00m\] '
	
# cor para usuário root (bash)

export PS1='\[\033[01;31m\]\u@\h\[\033[01;37m\]:\[\033[00m\]\[\033[01;34m\]\w\[\033[01;37m\]$\[\033[00m\] '

-----------------------------------------------------------------------------------------------------

* zsh

# colocar oh-my-zsh no root

   1) sudo cp /$HOME/.zshrc /root
   2) sudo cp -r /$HOME/.oh-my-zsh /root
   3) editar o arquivo ".zshrc" no root para trocar a linha que contenha o path do usuario normal para colocar o root
      3.1) sudo nano /root/.zshrc
      3.2) de....: export ZSH="/home/$USER/.oh-my-zsh" 
           para..: export ZSH="/root/.oh-my-zsh" 

valores

	\u: usuário atual
	\h: nome da máquina (host)
	\H: nome da máquina completo
	\w: diretório de trabalho atual
	\W: diretório de trabalho atual com o nome base (último segmento) apenas
	$(__git_ps1 "%s"): branch atual caso esteja em um repositório git, se não, não exibe nada.

obs: para setar permanentemente adicione essa script na última linha do arquivo ~/.bashrc (tanto na home do usuario normal quanto na home do root)

-----------------------------------------------------------------------------------------------------

* ppa

# baixar ppa pelo terminal

sudo add-apt-repository ppa:<nome_ppa>

# remover ppa pelo terminal

sudo add-apt-repository -r ppa:<nome_ppa>

-----------------------------------------------------------------------------------------------------

* instalar wine

1) sudo dpkg --add-architecture i386 
2) wget -nc https://dl.winehq.org/wine-builds/winehq.key && sudo mv winehq.key /usr/share/keyrings/winehq-archive.key
3) verificar repo atual no site: https://wiki.winehq.org/Download
   3.1) wget -nc https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources && sudo mv winehq-jammy.sources /etc/apt/sources.list.d/
4) verificar a branch desejada (stable pode não estar disponível)
   4.1) sudo apt install --install-recommends winehq-stable
   4.2) sudo apt install --install-recommends winehq-devel
5) "winecfg" ou "sudo apt install wine"

-----------------------------------------------------------------------------------------------------

* instalar plank

1) sudo apt install chrome-gnome-shell plank
2) https://extensions.gnome.org/extension/4198/dash-to-plank/

-----------------------------------------------------------------------------------------------------

* instalar virtualbox (VB)

obs: verificar se os links estão atualizado

# software-properties-common (obrigatório)

1) sudo apt install software-properties-common -y 

# virtualbox (obrigatório)

2) wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
3) wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
4) echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
5) sudo apt update
6) sudo apt install virtualbox-6.1 -y

# extension packs (opcional)

7) wget "https://download.virtualbox.org/virtualbox/6.1.30/Oracle_VM_VirtualBox_Extension_Pack-6.1.30.vbox-extpack"
8) sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-6.1.30.vbox-extpack

-----------------------------------------------------------------------------------------------------

* instalar vagrant

1) curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
2) sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
3) sudo apt-get update && sudo apt-get install vagrant

-----------------------------------------------------------------------------------------------------

* comando acpi

# ver porcentagem da bateria (notebooks)
acpi

-----------------------------------------------------------------------------------------------------

* matar processos no linux

# mostra todos os processos e id's
ps -A 

# mata o processo pelo id
kill <id_processo>

# mata todos os processos com tal nome
killall <nome_processo>

-----------------------------------------------------------------------------------------------------

* limpar memória cache

sync; echo 3 > /proc/sys/vm/drop_caches

-----------------------------------------------------------------------------------------------------

* comando tree

# listagem de diretorios em árvore
tree

# passando path
tree <diretorio>

# limitante a recursividade
tree -L 2

-----------------------------------------------------------------------------------------------------

* busca de arquivos e diretorios

   # comando find
   
      # sintaxe
      find . -name arquivo.txt

      # limitando a recursividade
      find / -maxdepth 3 -name arquivo.txt

   # comando locate
	
      # sintaxe
      locate arquivo

      # buscar por nome exato
      locate -b '\arquivo.txt'

-----------------------------------------------------------------------------------------------------

* compactação

   # comando tar

      # compactar em .tar.gz
      tar -zcvf pasta_compactada.tar.gz /etc/passwd /var/log

      # descompactar de .tar.gz
      tar -zxvf pasta_compactada.tar.gz

      # ver conteúdo de .tar.gz
      tar -tf pasta_compactada.tar.gz

      # descompactar de .tar.xz
      tar -xvf arquivos.tar.gz

   # comando zip

      # compactar em .zip
      zip pasta_compactada.zip /path/to/files/*

      # descompactar de .zip
      unzip pasta_compactada.zip 

-----------------------------------------------------------------------------------------------------

* uso memória RAM

   # comando free
   free -h

   # comando top
   top

   # comando smem
   smem -rtk

      # da para explorar com um grep e talvez somar a quantidade de ram para ver quanto um único processo está consumindo?
      smem -rtk | grep 'chrome'

-----------------------------------------------------------------------------------------------------

* mostra o tamanho dos direitos

du -sch ./*

-----------------------------------------------------------------------------------------------------

* mostra partições e tamanho dos discos

df -h

-----------------------------------------------------------------------------------------------------

# CONTINUAR DAQUI --->

*remove completamente o programa

$ sudo apt-get purge <pacote>

ou

$ sudo apt-get --purge remove <pacote>

-----------------------------------------------------------------------------------------------------

*lista todos os programas instalados

$ sudo dpkg -l

obs: joga a saida para um arquivo de texto para poder abrir num editor, assim pode-se procurar por algo
mais especifico para fazer alguma ação!

exemplo: $ dpkg -l > ~/saida.txt

-----------------------------------------------------------------------------------------------------

*ver tamanho de diretorios modo texto

como usar: $ ncdu <pode_passar_path> // "d" exclui

-----------------------------------------------------------------------------------------------------

*gravador nativo linux?

1) $ gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 0 // deixar tempo ilimitado de gravação
2) ctrl + alt + shift + r // inicia gravação
3) ctrl + alt + shift + r // encerra gravação

-----------------------------------------------------------------------------------------------------

* comando grep

# sintexe

grep -Ri 'trecho' /var/www/* ou ~/Documentos/teste.txt

obs: ele vai buscar recursivamente (-R), sem case sensitive (-i) a palavra ou frase dentro de aspas duplas no diretorio tal com todos arquivos ou em um documento especifico

# exemplo de utilização
   # para saber quantidade da ocorrência solicitada
   grep -o 'bash' /etc/passwd | wc -l

# pesquisando mais de uma ocorrência (utilizando parâmetro de RegEx)

grep --color -E "vmx|svm" /proc/cpuinfo

-----------------------------------------------------------------------------------------------------

*IP interno

$ hostname -I

-----------------------------------------------------------------------------------------------------

*como inserir icones no "menu de aplicativos" e adiciona-los na "barra de favoritos"

1) Crie um arquivo .desktop em: ~/.local/share/applications

    exemplo: touch ~/.local/share/applications/nome_arquivo.desktop 

2) Edite o arquivo inserindo as seguintes linhas

   [Desktop Entry]
   Encoding=UTF-8
   Name=Nome App
   Comment=Comentario App
   Icon=/path/for/app/icon.xpm
   Exec=/path/to/binary/to/your/app
   Terminal=false
   Type=Application
   Categories=Desenvolvimento

3) Torne o .desktop criado em executavel

   $ chmod +x nome_arquivo.desktop

4) Clicando em "Mostrar Aplicativos"
5) Busque pelo nome do aplicativo
6) Com botão direito do mouse no mesmo, escolha "Adicionar aos favoritos"

-----------------------------------------------------------------------------------------------------

*atualiza a distro?

$ sudo do-release-upgrade -d

-----------------------------------------------------------------------------------------------------

*variáveis de ambiente (escopo global)
	
	mostrar variáveis de ambiente (do usuario corrente)
	
		$ env
		
	criar variável de ambiente (escopo global)

		$ export edward="hostinger"

-----------------------------------------------------------------------------------------------------

*mapear teclas e ações 

$ xev | sed -ne '/^KeyPress/,/^$/p'

-----------------------------------------------------------------------------------------------------

*dispositivos conectados

$ xinput -list

&&

$ lsusb

-----------------------------------------------------------------------------------------------------

*kernel do sistema

$ uname -r

-----------------------------------------------------------------------------------------------------

*editor de texto padrão

	para saber qual 

		$ cat /usr/share/applications/defaults.list

	para escolher o editor padrão modo texto / ver o editor padrão modo texto

		$ sudo update-alternatives --config editor

-----------------------------------------------------------------------------------------------------

*mudar terminal padrão

$ sudo update-alternatives --config x-terminal-emulator

-----------------------------------------------------------------------------------------------------

*mudar shell padrão

	mudando diretamente no arquivo:
		
		$ sudo nano /etc/passwd
		
	rodando:
	
		$ chsh -s $(which zsh)
		
-----------------------------------------------------------------------------------------------------

*alias (definir permanente)
	
	1) $ nano ~/.bashrc

	entre no campo (bloco) específico do "alias"
	
	2) $ alias <nome_atalho>='<comando>'
	3) $ source .bashrc

-----------------------------------------------------------------------------------------------------

*encriptar arquivos
	
	caso os arquivos que seram encriptados ainda não tenham uma pasta preparada
	
		1) $ mkdir ~/privado // crie a pasta
		2) $ sudo chmod 700 ~/privado // faça que apenas o dono tenha permissões sobre ela
		
		obs: primeiro faça o processo de montagem e depois coloque os arquivos dentro da mesma
		
	montando o sistema de arquivos com a pasta "privada"
	
		1) $ sudo mount -t ecryptfs ~/privado ~/privado // montando a pasta
			1.1) $ 2
			1.2) $ <digite_a_senha>
			1.3) $ 1
			1.4) $ 1
			1.5) $ n
			1.6) $ n
			1.7) $ yes
			1.8) $ yes

		obs: coloque os arquivos na pasta
		
		2) $ sudo umount ~/privado // desmonta a pasta (efetivamente os arquivos estaram agora encriptados)
		3) $ sudo mount -t ecryptfs ~/privado ~/privado -o key=passphrase,ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_passthrough=n // desmonta novamente a pasta para conseguer ter acesso aos arquivos	

		obs: para fefinir no "ALias"

			no campo (bloco) correto dentro de .bashrc

			mountt() {
			   sudo mount -t ecryptfs "$1" "$2"; 
			}

			remountt() {
			   sudo mount -t ecryptfs "$1" "$2" -o key=passphrase,ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_passthrough=n
			}

-----------------------------------------------------------------------------------------------------

*como saber a placa de vídeo

$ lspci | grep 'VGA'

-----------------------------------------------------------------------------------------------------

*mudar resolução da tela via terminal 

https://www.tutorialeinformacao.com.br/2020/07/forcar-resolucao-de-tela-no-linux.html

-----------------------------------------------------------------------------------------------------

*colocar programas para autostart 

	1) crie um arquivo ".desktop" dentro da pasta "~/.config/autostart/"
	2) coloque nesse arquivo:
	
		[Desktop Entry]
		Type=Application
		Name=program_name
		Exec=/path/to/binarie
		StartupNotify=false
		Terminal=false
		
	obs: caso a pasta ainda não exista, basta cria-la
	1) $ mkdir ~/.config/autostart/

-----------------------------------------------------------------------------------------------------

*cron - adicionar alguma tarefa

	sintaxe: m h dm m ds command
	exemplo de horario: 0 8 * * 1,2,3,4,5 // de segunda a sexta às 08:00

	1) $ crontab -e
	2) $ inserir na última linha sempre
	
*para mudar o editor do cron

$ select-editor

-----------------------------------------------------------------------------------------------------

*hard links / links simbolicos

$ ls -i ~/arq.txt // mostra o "inode" do arquivo
$ file ~/arq.txt // mostra o tipo do arquivo e seu path

	link simbolico
	
		1) $ ln -s ~/path/to/arquivo.txt ~/home/nome_link_simbolico
		
		obs: tem que passar o path completo para esta operação
		obs: o link simbólico terá um inode diferente do arquivo original e o arquivo original for corrompido o link se tornara inutil
		
	hard link
	
		1) $ ln -s ~/path/to/arquivo.txt ~/home/nome_link_simbolico
		
		obs: o hard link tem o mesmo inode do original e se o original for corrompido o link fica independente

-----------------------------------------------------------------------------------------------------

*rodar um comando em outra janela de terminal

$ gnome-terminal -x sh -c "<comando>; bash" // abre em outra guia

ou

$ gnome-terminal -- sh -c "<comando>; bash" // abre em outra janela

-----------------------------------------------------------------------------------------------------

*calendario

$ cal <mes> <ano>

*hora/data de hoje

$ date

-----------------------------------------------------------------------------------------------------

*para instalar quaisquer dependencias que possam ter sidas removidas (para ubuntu)

$ sudo apt install ubuntu-desktop

-----------------------------------------------------------------------------------------------------

*adicionando $PATH (diretorio de binários)

$ export PATH=$PATH:/home/user/scripts

obs: para adicionar permanentemente, insira esse script na última linha do arquivo do seu shell (exemplo: .bashrc)

-----------------------------------------------------------------------------------------------------

*como passar senha para comando sudo automáticamente

$ echo -e "senha\n" | sudo -S <comando>

obs: parâmetro -S no sudo aceita outra etrada de dado que não seja e entrada padrão via terminal esperando receber no final da string uma nova linha
	
-----------------------------------------------------------------------------------------------------

*como encerrar o terminal depois de executar um comando

$ kill -9 $$

ou

$ exec <comando> // usando o "exec" depois de executar a sessão de terminal corrente é encerrada

-----------------------------------------------------------------------------------------------------

*rodar programas ou comandos em segundo plano

	$ <programa> &
	$ bg // com o programa em execução
	$ ctrl+z // com o programa em execução

mostrar programas em segundo plano: 

	$ jobs

para trazer um programa para primeiro plano:

	$ fg <programa>

-----------------------------------------------------------------------------------------------------

*protetor de tela modo texto com infos do sistema

$ neofetch

obs: como instalar o programa em "./ferramentas.txt"

-----------------------------------------------------------------------------------------------------

*minimizar tela do terminal corrente (com xdotool)

1) $ var=$(xdotool getactivewindow)
2) $ xdotool windowminimize "$var"

obs: como instalar o programa em "./ferramentas.txt"

-----------------------------------------------------------------------------------------------------

*rodar um comando como se estivesse logado como root

$ su -c "<comando>"

-----------------------------------------------------------------------------------------------------

*reiniciar o sistema

$ reboot

ou

$ exec /sbin/init

-----------------------------------------------------------------------------------------------------

*copiar saida de comando para a área de transferencia

$ pwd | xclip -selection clipboard

ou

$ pwd | tr -d '\n' | xclip -selection clipboard // para remover a "new line"

obs: criar um alias para falicitamento 
	
	$ alias cb="tr -d '\n' | xclip -selection clipboard"
	
	exemplo
	
	$ pwd | cb
	
	
*copiar saida de comando para dentro de um abiente 'X'

copiar

	$ pwd | xclip

colar

	$ xclip -o

exemplo

	1) $ pwd | xclip
	2) $ xclip -o | cd
	
obs: criar um alias para falicitamento

	$ alias c='xclip'
	$ alias v='xclip -o'
	
exemplo

	1) $ pwd | xclip
	2) $ cd `v`
	ou
	2) $ cd $(v)

-----------------------------------------------------------------------------------------------------

*mostra os programas baixado em apt

$ sudo ls /etc/apt/sources.list.d

-----------------------------------------------------------------------------------------------------

*pegar o "valor bruto" da memória ram em buff/cache

$ free -h | cut -d' ' -f45 | grep '2' | cut -c1

-----------------------------------------------------------------------------------------------------

*depurar programas

$ sh -x programa

-----------------------------------------------------------------------------------------------------

*sempre pedir a senha do sudo (reseta o tempo de armazenar a senha)


colocar "Defaults:ALL timestamp_timeout=0" na última linha do "/etc/sudoers"

	$ echo -e "\nDefaults:ALL timestamp_timeout=0" >> /etc/sudoers
	
força em pedir a senha do sudo

	$ sudo -k comando
		
-----------------------------------------------------------------------------------------------------

*exibir info do sistema

$ lshw

-----------------------------------------------------------------------------------------------------

*informações completas da máquina

$ inxi

ou

$ inxi -F

ou

$ inxi -Fxz

-----------------------------------------------------------------------------------------------------

*volta para o diretorio anterior (equivalente a "$ cd $OLDPWD")

$ cd -

-----------------------------------------------------------------------------------------------------

*pegar/cortar determinado linhas de coluna de um arquivo

$ head -5 /etc/passwd

-----------------------------------------------------------------------------------------------------

*organizar arquivos em colunas

$ column -s':' -t /etc/passwd

-----------------------------------------------------------------------------------------------------

*força o reboot?

$ systemctl reboot -i

-----------------------------------------------------------------------------------------------------

*para alterar data/hora do sistema

$ sudo date -s "mes/dia/ano 13:30"

*para atualizar automáticamente

$ sudo hwclock -s

-----------------------------------------------------------------------------------------------------

*saber todos os probrmas que já foram instalados?

$ history | grep 'apt install' > instalados.txt; history | grep 'apt-get install' >> instalados.txt

-----------------------------------------------------------------------------------------------------

*mostra o tamanho de uma pasta/arquivo específico

$ du -sh /path

-----------------------------------------------------------------------------------------------------

*tentativa de reconfigurar programas quebrados?

$ sudo apt install --reinstall <programa>

ou

$ sudo dpkg-reconfigure <programa>

-----------------------------------------------------------------------------------------------------

* comando tail
 
# mostra a última linha de um arquivo

tail -n 1 arquivo.txt

# mostra atualização do arquivo em tempo real

tail -f arquivo.txt 

-----------------------------------------------------------------------------------------------------

*** COM HASH ***

# ToDo List (SlackJeff)

export TODO="${HOME}/Documents/anotacoes/todo_list.txt"

tla() { [ $# -eq 0 ] && cat ${TODO} || echo "$(echo $* | md5sum | cut -c 1-4) ---> $*" >> ${TODO} ;}
tlr() { sed -i "/^$*/d" ${TODO} ;}

*** APENAS NUMERICOS ***

# ToDo List (SlackJeff)

export TODO="${HOME}/Documents/anotacoes/todo_list.txt"

rand() { export RAND=0; while [ ${#RAND} -lt 4 ]; do RAND=$((${RANDOM}%10000)); done ;}
tla() { rand; [ $# -eq 0 ] && cat $TODO || echo "${RAND} ---> $*" >> $TODO ;}
tlr() { sed -i "/^$*/d" $TODO ;}

-----------------------------------------------------------------------------------------------------

* ssh

# instalar conexão
sudo apt install ssh openssh-server

# start/stop/restart/status
service ssh opcao

# conexão
   # apenas CLI
   ssh usuario@127.0.0.1
   
   # acessar GUI
   ssh -X -C usuario@127.0.0.1
      # caso dê algum erro de conexão com interface remova a pasta Xauthority da Home
      rm -rfv ~/Xauthority
      
# transferir por ssh
   # remoto -> local
   scp /path/local usuario@192.168.0.1:/path/remoto

   # remoto -> local
   scp remoto@192.168.0.1:/path/remoto /tmp/tmp
      # aceito parâmetro "-r" para recursividade
      scp -r remoto@192.168.0.1:/path/remoto /tmp/tmp

-----------------------------------------------------------------------------------------------------

# mudar tema e icones por linha de comando

gsettings set org.gnome.desktop.interface gtk-theme "nome_do_tema"
gsettings set org.gnome.desktop.interface icon-theme "nome_do_icone" 

-----------------------------------------------------------------------------------------------------

* comando history

# limpar histórico do terminal

history -c

# não gravar comando no histórico (dê um espaço antes do comando)

 ls /home

# pesquisar algum comando do histórico

CTRL + r

-----------------------------------------------------------------------------------------------------

* comando yes

# loop infinito de echo (por default printa "y" na tela)

yes

# passando algum string como parâmetro ele printara a string

yes "no"

-----------------------------------------------------------------------------------------------------

* atributos

# adicionar atributo de imutabilidade

sudo chattr +i file.md

# listar atributos

lsattr

# removendo atributo de imutabilidade

sudo chattr -i file.md

# adicionar ou remover atributos recusivamente (em diretórios)

sudo chattr -R +i /path

-----------------------------------------------------------------------------------------------------

* comando cat

# mostra a quantidade de linhas de um arquivo

cat -n file.md

# utilizando com heredocument 

cat > file.txt << "EOF"

-----------------------------------------------------------------------------------------------------

* comando progress

<comando> | progress -m

-----------------------------------------------------------------------------------------------------

* comando cut

# pegar a coluna 1 e 7 do arquivo "/etc/passwd" pelo delimitador ":"

cut -d ':' -f 1,7 /etc/passwd

# pegar do 1º até o 3º caractere de cada linha

cut -c 1-3 /etc/passwd

# mudar o delimitador padrão

cut -d ' ' -f 3,4 --output-delimiter=',' arquivo.txt

-----------------------------------------------------------------------------------------------------

* manipulação de linhas

# excluir a última linha de um arquivo

sed -i "$(cat arquivo.txt > /dev/null | wc -l)d" arquivo.txt

# recortar primeira linha de um arquivo

echo "$(head -n 1 arquivo.txt)" > arquivo.txt

# recortar última linha de um arquivo

echo "$(tail -n 1 arquivo.txt)" > arquivo.txt

# mostrar a últinha linha de um arquivo

head -n 4 arquivo.txt | tail -n 1

-----------------------------------------------------------------------------------------------------

* RegEx (negar as ocorrências específicadas)

# habilitar o RegEx no bash
shopt -s extglob
   
   # sintaxe 
   rm -rfv !(*.txt|*.md)

# habilitar o RegEx no bash
setopt extendedglob

   # sintaxe
   rm -rfv ^*.txt
   rm -v ^file-1*
   rm -v ^*.(txt|tmp

-----------------------------------------------------------------------------------------------------

* comando dpkg

# instalar pacotes .deb

sudo dpkg -i pkg.deb

# saber arquitetura do sistema

dpkg --print-architecture

# saber se há outra arquitetura disponível para ser habilitada

dpkg --print-foreign-architectures

# adicionar arquitetura

sudo dpkg --add-architecture i386

# remover arquitetura

sudo dpkg --remove-architecture i386

-----------------------------------------------------------------------------------------------------

* montagem/desmontagem e ejeção de dispositivos

# montar

sudo mount /dev/sdc1 /mnt

# desmontar

sudo umount /mnt

# ejetar

sudo eject /dev/sdc1

-----------------------------------------------------------------------------------------------------

* layout do teclado

sudo vim /etc/default/keyboard

   # trocar o conteúdo dessa linha "XKBLAYOUT" para "br" (que é o ABNT 2)
   XKBLAYOUT="en"

-----------------------------------------------------------------------------------------------------

* mudar a furtividade de senhas

sudo vim /etc/sudoers

   # inserir em baixo da sessão dos "Defaults"
   Defaults        pwfeedback

-----------------------------------------------------------------------------------------------------

* manipulação de discos

# manipulação de partições

sudo fdisk /dev/sdb

# formatação de disco

sudo mkfs.ext4 /dev/sdb
sudo mkfs.vfat /dev/sdb

-----------------------------------------------------------------------------------------------------

* portas

sudo ss -ntpl

-----------------------------------------------------------------------------------------------------

* grupos/usuários/permissões

# saber os grupos de um usuário

groups <usuario>

-----------------------------------------------------------------------------------------------------

* comando gdebi

sudo gdebi pkg.deb

-----------------------------------------------------------------------------------------------------

* comando trans

# sintaxe

trans -b en:pt-br 'The books on the table!'

# traduzir arquivos

trans -b en:pt-br -i hello_world.txt

-----------------------------------------------------------------------------------------------------

* infos do sistema (compilar os outros comandos referentes nessa seção tabém)

   # infos do sistema
      1) hwinfo --short
      2) inxi -GIS

   # saber número de núcleos (cores) do processador
   nproc

   # saber arquitetura do sistema
   uname -m

   # saber interface gráfica atual
   echo $XDG_CURRENT_DESKTOP

   # distro
   
      # infos da distro
      lsb_release -a

      # somente o nome da distro
      lsb_release -cs

-----------------------------------------------------------------------------------------------------

* caixas de diálogo

# notify-send

notify-send 'Atenção!' 'Reinicialização necessária.'

# zenity

# dialog

# whiptail

# toilet

-----------------------------------------------------------------------------------------------------

* qemu

# criar disco

qemu-img create -f qcow2 imagem-disco.qcow2 15G

# subir VM

qemu-system-i386 -enable-kvm -m 2048 -smp 2 -hda [imagem-disco.qcow2|/dev/sdb] -boot d -cdrom imagem-distro.iso

# iniciar a imamgem

qemu-system-i386 -enable-kvm -m 2048 -smp 2 -hda [imagem-disco.qcow2|/dev/sdb]

# subir vm modo UEFI

sudo apt install ovmf -y

# subir VM

qemu-system-i386 -enable-kvm -bios /usr/share/ovmf/OVMF.fd -m 2048 -smp 2 -hda [imagem-disco.qcow2|/dev/sdb] -boot d -cdrom imagem-distro.iso

# iniciar a imamgem

qemu-system-i386 -enable-kvm -bios /usr/share/ovmf/OVMF.fd -m 2048 -smp 2 -hda [imagem-disco.qcow2|/dev/sdb]

-----------------------------------------------------------------------------------------------------

* wi-fi CLI

# conectar rede wi-fi via CLI

nmtui-connect

# saber ips conectados a minha rede

sudo apt install nmap -y
ip address
sudo nmap -sn 192.168.0.255/24 

-----------------------------------------------------------------------------------------------------

* ver info e metadados de arquivos?

stat arquivo.txt

-----------------------------------------------------------------------------------------------------

# gerador de arquivo com nome aleatório

TMPFILE=$(mktemp RAM-XXXXX.tmp)

-----------------------------------------------------------------------------------------------------

* comando apt

# apenas fazer download do programa e suas dependências sem instalar

sudo apt install --download-only package

obs: será salvo em "/var/cache/apt/archives"

-----------------------------------------------------------------------------------------------------

## >>> Arch Linux !

### PACMAN

\- Sincronização total/procura por atualização

```bash
pacman -Syyu
```

\- Procura por um pacote

```bash
pacman -Ss <package>
```

\- Instala um pacote

```bash
pacman -S <package>
```

\- Apenas baixa o pacote e não o instala

```bash
pacman -Sw <package>
```

\- Mostra informações de um pacote não instalado

```bash
pacman -Si <package>
```

\- Mostra informações do pacote já instalado

```bash
pacman -Qi <package>
```

\- Instala apenas as dependências

```bash
pacman -Se <package>
```

\- Remove um pacote

```bash
pacman -R <package>
```

\- Remove o pacote junto com as dependências não usadas por outros pacotes

```bash
pacman -Rs <package>
```

### IWD

\- Editar o arquivo: /etc/iwd/main.conf

```
[General]
EnableNetworkConfiguration=true
[Network]
NameResolvingService=systemd
```

\- Habilitar e iniciar os seguintes serviços

```bash
systemctl start iwd.service && systemctl enable iwd.service &&; \
systemctl start systemd-networkd.service && systemctl enable systemd-networkd.service; \
systemctl start systemd-resolved.service && systemctl enable systemd-resolved.service
```
