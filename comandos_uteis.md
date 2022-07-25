# >>> Comandos Aleatoriamente úteis!

## > GIT

Renomear repositório remoto:

```bash
git remote rename <nome_atual> <novo_nome>
```

Pasta inacessível (pasta com *submodule*):

1. `git rm --cached <folder_name>`
1. `rm -rf <folder_name>/.git`
1. `git add .`
1. `git push origin master`

### Manipulação de branchs

#### Mostrar branchs

Locais:

```bash
git branch [--list|-l]
```

Remotas:

```bash
git branch {--remotes|-r} {--list|-l}
```

Mostra além das branchs remotas, outras infos:

```bash
git remote show <remote_name>
```

#### Trocar de branch

Com *checkout*:

```bash
git checkout <branch_name>
```

Com *switch*:

```bash
git switch <branch_name>
```

#### Criar e mudar para a nova branch

Com *checkout*:

```bash
git checkout -b <nova_branch> 
```

Com *switch*:

```bash
git switch -c <branch_name>
```

#### Remoção de branchs

##### Local

Remover:

```bash
git branch -d <branch_name> 
```

Forçando:

```bash
git branch -D <branch_name>
```

##### Remoto

Remover:

```bash
git push origin {:<remote_branch>|--delete <remote_branch>}
```

### Visualização de log's

Mostra o log de commits:

```bash
git log
```

Mostra o log resumido:

```bash
git log --oneline
```

Mostra por completo o gráfico de nodles:

```bash
git log --graph --all
```

Mostra de forma resumida o gráfico de nodles:

```bash
git log --oneline --graph --all
```

#### Blame

Mostra um histórico de alteraçẽos realizadas:

- -w: remove espaços em branco
- -L: limita a faixa de linhas

```bash
git blame [-w|-L 1,12] <file_name>
```

### Clonagem de repositórios

Clonar:

```bash
git clone <url>
```

Clonar de uma branch específica:

```bash
git clone -b <branch_name> <url>
```

### Manipular informações do usuário

```
~/.gitconfig
```

### Reverter commits

Apenas desfazer o commit (sem perder as alteraçẽos):

```bash
git reset --soft <hash_commit>
```

Desfazer os commits (sem manter as alterações):

```bash
git reset --hard <hash_commit>
```

### .gitignore

#### Arquivos

Arquivo **global**: pode estar alocado em qualquer lugar e vale para qualquer repositório na máquina.

```
~/.gitignore
```

Arquivo **local**: deve estar na raiz do projeto e vale somente para aquele projeto e todos que contribuem.

```
/path/to/project/.gitignore
```

Arquivo do usuário: é um arquivo já prédefinido pelo git e não é versionado pelo código.

```
/path/to/project/.git/info/exclude
```

#### Comandos

Depois de ignorar qualquer arquivo deve-se removelo do índice:

```bash
git rm --cached file.txt
```

Setar o `.gitignore` global:

```bash
git config --global core.excludesfile ~/.gitignore
```

Adicionar algum arquivo que esteja sendo ignorado:

```bash
git add -f file.txt
```

#### Skip Work Tree

Remover da árvore de trabalho:

```bash
git update-index --skip-worktree file.txt
```

Retornar para a árvore de trabalho:

```bash
git update-index --no-skip-worktree file.txt
```

Listar os arquivos *skipados*:

```bash
git ls-files -v | grep -E '^S'
```

## > GITHUB CLI

Ver os repositórios remotos:

```bash
gh repo list
```

### Pull request's

Criar pull request:

1. Entrar na ramificação em desenvolvimento e commitar as alterações

	1. `git switch dev`
	1. `git add .`
	1. `git commit -m "<message_commit>"`

1. Criar o pull request informando a branch que ele será mergeado

	1. `gh pr create --base master`

Listar os pr's ativos:

```bash
gh pr list
```

Listar todos os pr's:

```bash
gh pr view
```

Aceitar o pull request:

```bash
gh pr review --aprrove
```

## > Debian base

### Manipulando variável PS1 (PROMPT)

Exibir branch no terminal (bash):

```bash
export PS1='\[\033[01;32m\]\u@\h\[\033[01;37m\]:\[\033[00m\]\[\033[01;34m\]\w\[\033[0;35m\]$(__git_ps1 "(%s)")\[\033[01;37m\]$\[\033[00m\] '
```
	
Cor para usuário root (bash):

```bash
export PS1='\[\033[01;31m\]\u@\h\[\033[01;37m\]:\[\033[00m\]\[\033[01;34m\]\w\[\033[01;37m\]$\[\033[00m\] '
```

Valores:

- \u: usuário atual
- \h: nome da máquina (host)
- \H: nome da máquina completo
- \w: diretório de trabalho atual
- \W: diretório de trabalho atual com o nome base (último segmento) apenas
- $(__git_ps1 "%s"): branch atual caso esteja em um repositório git, se não, não exibe nada.

OBS: Para setar permanentemente, adicione essa script na última linha do arquivo ~/.bashrc (tanto na home do usuario normal quanto na home do root)

---

### Zsh

Colocar oh-my-zsh no root:

1. `sudo cp ${HOME}/.zshrc /root`
1. `sudo cp -r ${HOME}/.oh-my-zsh /root`

---

### Ppa's

Baixar ppa pelo terminal:

```bash
sudo add-apt-repository ppa:<ppa_name>
```

Remover ppa pelo terminal:

```bash
sudo add-apt-repository -r ppa:<ppa_name>
```

---

### Instalar Wine

1. `sudo dpkg --add-architecture i386`
1. `wget -nc https://dl.winehq.org/wine-builds/winehq.key && sudo mv winehq.key /usr/share/keyrings/winehq-archive.key`
1. Verificar repo atual no site: https://wiki.winehq.org/Download
	1. `wget -nc https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources && sudo mv winehq-jammy.sources /etc/apt/sources.list.d/`
1. Verificar a branch desejada (stable pode não estar disponível)
	1. `sudo apt install --install-recommends winehq-(stable|devel) -y`
1. `winecfg` ou `sudo apt install wine -y`

---

### Instalar Plank

1. `sudo apt install chrome-gnome-shell plank -y`
1. https://extensions.gnome.org/extension/4198/dash-to-plank/

---

### Instalar VirtualBox (VB)

Software properties common (obrigatório):

1. `sudo apt install software-properties-common -y`

VirtualBox (obrigatório):

2. `wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -`
1. `wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -`
1. `echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list`
1. `sudo apt update`
1. `sudo apt install virtualbox-6.1 -y`

Extension packs (opcional):

1. `wget "https://download.virtualbox.org/virtualbox/6.1.30/Oracle_VM_VirtualBox_Extension_Pack-6.1.30.vbox-extpack"`
1. `sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-6.1.30.vbox-extpack`

OBS: Verificar se os links estão atualizado

---

### Instalar Vagrant

1. `curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -`
1. `sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"`
1. `sudo apt update && sudo apt install vagrant`

---

### Comando acpi

Ver porcentagem da bateria (notebooks):

```bash
acpi
```

---

### Matar processos no linux

Mostra todos os processos e id's:

```bash
ps -A 
```

Mata o processo pelo id:

```bash
kill <process_id>
```

Mata todos os processos com tal nome:

```bash
killall <process_name>
```

---

### Limpar memória cache

Comando:

```bash
sync; echo 3 > /proc/sys/vm/drop_caches
```

---

### Comando tree

Listagem de diretorios em árvore:

```bash
tree
```

Passando path:

```bash
tree <path>
```

Limitar a recursividade:

```bash
tree -L 2
```

---

### Busca de arquivos e diretorios

#### Comando find

Sintaxe:

```bash
find ./ -name file.txt
```

Limitando a recursividade:

```bash
find ./ -maxdepth 3 -name file.txt
```

Excluir determinado path da busca:

```bash
find ./ -path ./some_path -prune -o -name '*file*'
```

Excluir vários paths da busca:

```bash
find ./ \( -path ./first/path -o -path ./second/path \) -prune -o -name '*file*'
```

Excluir vários paths da busca e limitar a recursivedade:

```bash
find ./ -maxdepth 2 \( -path ./first/path -o -path ./second/path \) -prune -o -name '*file*'
```

#### Comando locate
	
Sintaxe:

```bash
locate file
```

Buscar por nome exato:

```bash
locate -b '\file.txt'
```

---

### Compactação de arquivos

#### Comando tar

Compactar em .tar.gz:

```bash
tar -zcvf target_folder.tar.gz /folder/to/be/compressed_1 /folder/to/be/compressed_2 /file/to/be/compressed
```

Descompactar de .tar.gz:

```bash
tar -zxvf compressed_folder.tar.gz
```

Ver conteúdo de .tar.gz:

```bash
tar -tf compressed_folder.tar.gz
```

Descompactar de .tar.xz:

```bash
tar -xvf compressed_folder.tar.gz
```

#### Comando zip

Compactar em .zip:

```bash
zip target_folder.zip /folder/to/be/compressed_1 /folder/to/be/compressed_2 /file/to/be/compressed /for/compressed/multiples/*
```

Descompactar de .zip:

```bash
unzip compressed_folder.zip 
```

---

### Uso memória RAM

Comando free:

```bash
free -h
```

Comando top:

```bash
top
```

Comando smem:

```bash
smem -akt -P <program_name>
```

---

### Mostra o tamanho dos direitos

Comando:

```bash
du -sch ./*
```

---

### Mostra partições e tamanho dos discos:

Comando:

```bash
df -h
```

---

### Lista os discos na máquina (saber se é HDD ou SSD pelo modelo):

Comando:

```bash
parted -l
```

---

### Apt

Remover completamente o programa:

```bash
sudo apt purge <package>
```

Lista todos os programas instalados:

```bash
sudo dpkg -l
```

---

### Ver tamanho de diretorios (CLI)

```bash
ncdu [<path>]
```

---

### Gravador nativo do linux?

Deixar tempo ilimitado de gravação:

```bash
gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 0
```

Inicia gravação:

```bash
ctrl + alt + shift + r
```

Encerra gravação:

```bash
ctrl + alt + shift + r
```

---

### Comando grep

Sintexe:

```bash
grep -Ri 'ocorrência' {/some/path/*|~/Documentos/teste.txt}
```

OBS: Ele vai buscar recursivamente (-R), sem case sensitive (-i) a palavra ou frase dentro de aspas duplas no diretorio tal com todos arquivos ou em um documento especifico

Para saber quantidade da ocorrência solicitada:

```bash
grep -o 'bash' /etc/passwd | wc -l
```

Pesquisando mais de uma ocorrência (utilizando parâmetro de RegEx):

```bash
grep --color -E "(vmx|svm)" /proc/cpuinfo
```

---

### Comando *hostname*

Hostname:

```bash
hostname
```

Ip interno:

```bash
hostname -I
```

---

### Como inserir icones no "menu de aplicativos"

1. Crie um arquivo .desktop em: ~/.local/share/applications:

```bash
touch ~/.local/share/applications/nome_arquivo.desktop 
```

2. Edite o arquivo inserindo as seguintes linhas:

```
[Desktop Entry]
Encoding=UTF-8
Name=App Name
Comment=App Comment
Icon=/path/for/app/icon.xpm
Exec=/path/to/application/binary
Terminal=false
Type=Application
Categories=Development
```

3. Torne o .desktop criado em executavel:

```bash
chmod +x ~/.local/share/applications/file_name.desktop
```

---

### Atualizar a versão da distro

1. Atualize e limpe o sistema:

```bash
sudo apt update && sudo apt dist-upgrade -y
```

2. Remova pacotes não mais utilizados:

```bash
sudo apt autoremove
```

3. Instale a ferramente de gerenciamento de pacotes:

```bash
sudo apt install update-manager-core -y
```

4. Verifique se há versão disponíveis:

```bash
sudo do-release-upgrade --check-dist-upgrade-only -d
```

5. Atualize a distro:

	- --allow-third-party: Mantém repositórios de terceiros (ppa's)

```bash
sudo do-release-upgrade -d [--allow-third-party]
```

6. Reinicie o sistema:

```bash
sudo shutdown -r now
```

7. Verifique a nova versão:

```bash
lsb_release -a
```

---

### Variáveis de ambiente (escopo global)
	
Mostrar variáveis de ambiente (do usuario corrente):
	
```bash
env
```

Criar variável de ambiente (escopo global):

```bash
export FOO="BAR"
```

---

### Mapear teclas e ações 

Comando:

```bash
xev | sed -ne '/^KeyPress/,/^$/p'
```

---

### Dispositivos

#### Xinput

Listar e descobrir os códigos dos dispositivos:

```bash
xinput
```

Listar as propriedades do dispositivo:

```bash
xinput list-props <device_id>
```

Alterar o valor da respectiva propriedade:

```bash
xinput set-prop <device_id> <property_id> <value>
```

OBS: Descobrir qual o range de valor para cada propriedade (*Accel Speed*: ['0.0'-'1.0'])

#### Lsusb

Listagem dos dispositivos:

```bash
lsusb
```

---

### Kernel do sistema

```bash
uname -r
```

---

### Comando *update-alternatives*

#### Editor de texto padrão

Para saber qual:

```bash
cat /usr/share/applications/defaults.list
```

Para escolher o editor padrão modo texto/ver o editor padrão modo texto:

```bash
sudo update-alternatives --config editor
```

#### Terminal padrão

Comando:

```bash
sudo update-alternatives --config x-terminal-emulator
```

---

### Mudar shell padrão

Mudando diretamente no arquivo:

```bash		
sudo vim /etc/passwd
```

Com variável de ambiente USER (opção curta):

```bash
sudo chsh {--shell|-s} $(which zsh) {$(whoami)|${USER}}
```

---

### Alias'es (definir permanente)
	
1. Edite o rc do seu shell:

```bash
vim ~/.<shell>rc
```

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

#### DISPOSITIVOS DE ENTRADA - TOUCHPAD

##### Alterar velocidade do ponteiro

###### Descobrir o código do dispositivo de entrada do *touch*

```bash
xinput
```
###### Listar as propriedades do dispositivo grepando por *speed*

```bash
xinput list-props <device_id> | grep -iF speed
```

###### Alterar o valor da respectiva propriedade

```bash
xinput set-prop <device_id> <propertie_id> <value>
```

> Descobrir qual o range de valor para cada propriedade (*Accel Speed*: ['0.0'-'1.0'])

#### FILE MANAGER (THUNAR)

##### Configurar "Open Terminal Here"

Edit » "Configure custom actions..." » "Open Terminal Here" » *engrenagem* » Command:

```bash
terminator --working-directory=%f
```

#### FONTS

##### Diretórios

Path de todos os usuários

```bash
/usr/share/fonts
```

Path pessoal do usuário (${XDG\_CONFIG})

```bash
~/.local/share/fonts
```

##### Comandos

Listar todas as fontes

```bash
fc-list
```

Atualizar o cache de fontes

```bash
fc-cache
```

##### Instalação

Instalar no path do usuário

```bash
cp *.ttf ~/.local/share/fonts/truetype/<directorie_font_name>/
```

Instalar no path global

```bash
sudo cp *.ttf /usr/share/fonts/truetype/<directorie_font_name>/
```

### UBUNTU

#### Pesquisar pacotes:

```
https://packages.ubuntu.com/
```

#### Pesquisar manpages:

Pesquisar na barrar de pesquisa da página

```
https://manpages.ubuntu.com/manpages/
```

Pesquisar diretamente pela URL

```
https://manpages.ubuntu.com/manpages/cgi-bin/search.py?q=<package_name>
```

#### Pesquisar ppa's:

```
https://launchpad.net/ubuntu/+ppas
```

#### Pesquisar por ppas

---

### > Arch Base

#### PACMAN

Sincronização total/procura por atualização

```bash
pacman -Syyu
```

Procura por um pacote

```bash
pacman -Ss <package>
```

Instala um pacote

```bash
pacman -S <package>
```

Apenas baixa o pacote e não o instala

```bash
pacman -Sw <package>
```

Mostra informações de um pacote não instalado

```bash
pacman -Si <package>
```

Mostra informações do pacote já instalado

```bash
pacman -Qi <package>
```

Instala apenas as dependências

```bash
pacman -Se <package>
```

Remove um pacote

```bash
pacman -R <package>
```

Remove o pacote junto com as dependências não usadas por outros pacotes

```bash
pacman -Rs <package>
```

#### IWD

Editar o arquivo: /etc/iwd/main.conf

```
[General]
EnableNetworkConfiguration=true
[Network]
NameResolvingService=systemd
```

Habilitar e iniciar os seguintes serviços

```bash
systemctl start iwd.service && systemctl enable iwd.service &&; \
systemctl start systemd-networkd.service && systemctl enable systemd-networkd.service; \
systemctl start systemd-resolved.service && systemctl enable systemd-resolved.service
```

## > Estudos

### Tipos de datas

- Access time
	- Explicação: data que o arquivo foi acessado ou lido pela última vez (sem modificações)
	- Exemplo: cat, head, vim, less

- Modify time
	- Explicação: data que o arquivo foi modificado pela última vez
	- Exemplo: editando o contúdo do arquivo, adicionando ou excluindo

- Change time
	- Explicação: data que o inode do arquivo é modificado
	- Exemplo: alterando permissões, propriedade, nome do arquivo ou número de links físicos
