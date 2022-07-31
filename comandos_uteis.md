<a id="menu"></a>
# >>> Comandos Aleatoriamente úteis!

- [Debian base](#debian_base)
	- [Customização](#db_customizacao)
	- [Pacotes](#db_pacotes)
	- [Programas](#db_programas)
	- [Sistema](#db_sistema)
	- [SysAdmin](#db_sysadmin)
	- [Configuração](#db_configuracao)
	- [Hardware](#db_hardware)
	- [Tutoriais](#db_tutoriais)
- [Ubuntu](#ubuntu)
- [Git](#git)
- [GitHub CLI](#github_cli)
- [Arch base](#arch_base)
- [Estudos](#estudos)

<a id="debian_base"></a>
## [> Debian base](#menu)

<a id="db_customizacao"></a>
[<span style="font-size:14px;">Customização</span>](#menu)

<h3 style="color:red;">Manipulando variável PS1 (PROMPT)</h3>

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

<h3 style="color:red;">Zsh</h3>

Colocar oh-my-zsh no root:

1. `sudo cp ${HOME}/.zshrc /root`
1. `sudo cp -r ${HOME}/.oh-my-zsh /root`

---

<a id="db_pacotes"></a>
[<span style="font-size:14px;">Pacotes</span>](#menu)

<h3 style="color:red;">Comando *apt*</h3>

Remover completamente o programa:

```bash
sudo apt purge <package>
```
Fazer apenas o download do programa e suas dependências sem instalar:

```bash
sudo apt install --download-only <package>
```

OBS: Será salvo em `/var/cache/apt/archives`

<h3 style="color:red;">Comando *dpkg*</h3>

Listar todos os programas instalados:

```bash
sudo dpkg -l
```

<h3 style="color:red;">Ppa's</h3>

Baixar ppa pelo terminal:

```bash
sudo add-apt-repository ppa:<ppa_name>
```

Remover ppa pelo terminal:

```bash
sudo add-apt-repository -r ppa:<ppa_name>
```

---

<a id="db_programas"></a>
[<span style="font-size:14px;">Programas</span>](#menu)

<h3 style="color:red;">Instalar Wine</h3>

1. `sudo dpkg --add-architecture i386`
1. `wget -nc https://dl.winehq.org/wine-builds/winehq.key && sudo mv winehq.key /usr/share/keyrings/winehq-archive.key`
1. Verificar repo atual no site: https://wiki.winehq.org/Download
	1. `wget -nc https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources && sudo mv winehq-jammy.sources /etc/apt/sources.list.d/`
1. Verificar a branch desejada (stable pode não estar disponível)
	1. `sudo apt install --install-recommends winehq-(stable|devel) -y`
1. `winecfg` ou `sudo apt install wine -y`

<h3 style="color:red;">Instalar Plank</h3>

1. `sudo apt install chrome-gnome-shell plank -y`
1. https://extensions.gnome.org/extension/4198/dash-to-plank/

<h3 style="color:red;">Instalar VirtualBox (VB)</h3>

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

<h3 style="color:red;">Instalar Vagrant</h3>

1. `curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -`
1. `sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"`
1. `sudo apt update && sudo apt install vagrant`

---

<a id="db_sistema"></a>
[<span style="font-size:14px;">Sistema</span>](#menu)

<h3 style="color:red;">Comando *acpi*</h3>

Ver porcentagem da bateria (notebooks):

```bash
acpi
```

<h3 style="color:red;">Comando *parted*</h3>

Lista os discos na máquina (saber se é HDD ou SSD pelo modelo):

```bash
parted -l
```

<h3 style="color:red;">Gravador nativo do linux?</h3>

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

<h3 style="color:red;">Variáveis de ambiente (escopo global)</h3>
	
Mostrar variáveis de ambiente (do usuario corrente):
	
```bash
env
```

Criar variável de ambiente (escopo global):

```bash
export FOO="BAR"
```

<h3 style="color:red;">Mapear teclas e ações </h3>

Comando:

```bash
xev | sed -ne '/^KeyPress/,/^$/p'
```

<h3 style="color:red;">Dispositivos</h3>

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

<h3 style="color:red;">Reiniciar o sistema</h3>

Reboot:

```bash
reboot
```

Shutdown:

```bash
shutdown -r now
```

#### Systemctl

Leve:

```bash
systemctl reboot
```

Forçado:

```bash
systemctl reboot -i
```

<h3 style="color:red;">Fonts</h3>

#### Diretórios

Path de todos os usuários:

```bash
/usr/share/fonts
```

Path pessoal do usuário (${XDG_CONFIG}):

```bash
~/.local/share/fonts
```

#### Comandos

Listar todas as fontes:

```bash
fc-list
```

Atualizar o cache de fontes:

```bash
fc-cache
```

#### Instalação

Instalar no path do usuário:

```bash
cp *.ttf ~/.local/share/fonts/truetype/<directorie_font_name>/
```

Instalar no path global:

```bash
sudo cp *.ttf /usr/share/fonts/truetype/<directorie_font_name>/
```

---

<a id="db_sysadmin"></a>
[<span style="font-size:14px;">SysAdmin</span>](#menu)

<h3 style="color:red;">Comando *tree*</h3>

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

<h3 style="color:red;">Comando *du*</h3>

Mostra o tamanho dos direitos:

```bash
du -sch ./*
```

<h3 style="color:red;">Comando *df*</h3>

Mostra partições e tamanho dos discos:

```bash
sudo df -h
```

<h3 style="color:red;">Comando *ncdu*</h3>

Ver tamanho de diretorios (CLI):

```bash
ncdu [<path>]
```

<h3 style="color:red;">Comando *grep*</h3>

- i: *Case insensitive*
- n: Número da linhas da ocorrência
- o: Somente a ocorrência e não a linha toda da mesma
- E: Expressão regular extendida
- R: Recursividade em arquivos

```bash
grep -inoER '^(hello|world)' {/some/path/file.txt|/some/path/*}
```

<h3 style="color:red;">Comando *hostname*</h3>

Saber hostname:

```bash
hostname
```

Ip interno:

```bash
hostname -I
```

<h3 style="color:red;">Comando *ls*</h3>

Mostra o *inode* do arquivo:

```bash
ls -i ~/file.txt
```

<h3 style="color:red;">Comando *file*</h3>

Mostra o tipo do arquivo e seu path:

```bash
file ~/file.txt
```

<h3 style="color:red;">Comando *ln*</h3>

#### Hard link (link físico)

- Hard links não podem ser feitos por arquivos que estão em pontos de montagem separados.

- O hard link tem o mesmo inode do original e se o original for corrompido o link fica independente.

```bash
ln ~/path/to/file.txt ~/path/hard_link_name
```
		
#### Symlink (link simbólico)

- Tem que passar o path completo para esta operação.

- O link simbólico terá um inode diferente do arquivo original e se arquivo original for corrompido o link quebrará.

```bash
ln -s ~/path/to/file.txt ~/path/symlink_name
```

<h3 style="color:red;">Comando *update-alternatives*</h3>

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

<h3 style="color:red;">Comando *cal*</h3>

Calendário:

```bash
cal [<month>] [<year>]
```

<h3 style="color:red;">Comando *date*</h3>

Data/hora:

```bash
date
```

<h3 style="color:red;">Comando *sudo*</h3>

Passar senha de forma automática:

- -S: aceita que a STDIN seja diferente e espera receber no final da string uma nova linha

```bash
echo -e "<password>\n" | sudo -S <command>
```

#### Não guardar a senha em cache:

Direto na linha de comando:

```bash
sudo -k <command>
```

Definir permanentemente:

1. Edite o arquivo de alterações do sudoers:
	`sudo visudo -f /etc/sudoers.d/users`
1. Colocar o seguinte conteúdo:
	`Defaults:ALL timestamp_timeout=0`
	
<h3 style="color:red;">Comando *exec*</h3>

Usando o *exec* junto com algum comando, depois de executado a sessão de terminal corrente é encerrada:

```bash
exec <command>
```

<h3 style="color:red;">Comando *xdotool*</h3>

Minimizar tela do terminal corrente:

1. `var=$(xdotool getactivewindow)`
1. `xdotool windowminimize $var`

<h3 style="color:red;">Comando *su*</h3>

Trocar de usuário:

```bash
su <user>
```

Trocar para o usuário root sem senha definida:

```bash
sudo su - root
```

Rodar um comando como se estivesse logado como root:

```bash
su -c "<command>"
```

<h3 style="color:red;">Comando *cd*</h3>

##### Voltar para o diretorio anterior

Com o caracter **-**:

```bash
cd -
```

Com a variável **$OLDPWD**:

```bash
cd $OLDPWD
```

<h3 style="color:red;">Comando *head*</h3>

Mostrar *x* primeiras linhas de um arquivo:

```bash
head -5 /etc/passwd
```

<h3 style="color:red;">Comando *column*</h3>

Organizar a saida em colunas:

- -s: Delimitador
- -t: Cria a tabela

```bash
column -s ':' -t /etc/passwd
```

<h3 style="color:red;">Comando *du*</h3>

Mostra o tamanho de um arquivo ou pasta:

```bash
du -sh /path/to/file_or_folder
```

Mostra o tamanho de todos os arquivos de uma pasta com o total:

```bash
du -sch /path/to/folder/*
```

<h3 style="color:red;">Comando *tail*</h3>
 
Mostra a última linha do arquivo:

```bash
tail -1 file.txt
```

Monitora o arquivo em tempo real:

```bash
tail -f file.txt 
```

<h3 style="color:red;">Comando *ssh*</h3>

Instalação:

```bash
sudo apt install ssh openssh-server -y
```

#### Conexões

Apenas "CLI":

```bash
ssh user@192.168.0.1
```

Acessar "GUI":

```bash
ssh -X -C user@192.168.0.1
```

OBS: Caso dê algum erro de conexão com interface remova a pasta .Xauthority da *home*

```bash
rm -rfv ~/.Xauthority
```

<h3 style="color:red;">Comando *scp*</h3>

Local -> Remoto

```bash
scp -r /local/path user@192.168.0.1:/remote/path
```

Remoto -> Local

```bash
scp -r user@192.168.0.1:/remote/path /local/path
```

<h3 style="color:red;">Comando *gsettings*</h3>

Mudar tema via CLI:

```bash
gsettings set org.gnome.desktop.interface gtk-theme "theme_name"
```

Mudar icone via CLI:

```bash
gsettings set org.gnome.desktop.interface icon-theme "icon_name" 
```

<h3 style="color:red;">Comando *history*</h3>

Limpar histórico do terminal:

```bash
history -c
```

Não gravar comando no histórico (dê um espaço antes do comando):

```bash
 ls /home
```

#### Plus

Pesquisar algum comando no histórico:

```bash
ctrl+r
```

<h3 style="color:red;">Comando *yes*</h3>

Loop infinito de "echo" (por default printa "y" na tela)?:

```bash
yes
```

Passando alguma string:

```bash
yes "no"
```

<h3 style="color:red;">Comando *cat*</h3>

Mostra a quantidade de linhas:

```bash
cat -n file.md
```

Utilizando com *heredocument*:

```bash
cat << EOF > file.txt
```

<h3 style="color:red;">Comando *progress*</h3>

```bash
<command> | progress -m
```

<h3 style="color:red;">Comando *cut*</h3>

Pegar a coluna 1 e 7 do arquivo "/etc/passwd" pelo delimitador ":":

```bash
cut -d ':' -f 1,7 /etc/passwd
```

Pegar do 1º até o 3º caractere de cada linha:

```bash
cut -c 1-3 /etc/passwd
```

Mudar o delimitador padrão:

```bash
cut -d ' ' -f 3,4 --output-delimiter=',' arquivo.txt
```

<h3 style="color:red;">Comando *dpkg*</h3>

Instalar pacotes .deb:

```bash
sudo dpkg {--install|-i} package.deb
```

Saber arquitetura do sistema:

```bash
dpkg --print-architecture
```

Saber se há outra arquitetura disponível para ser habilitada:

```bash
dpkg --print-foreign-architectures
```

Adicionar arquitetura:

```bash
sudo dpkg --add-architecture i386
```

Remover arquitetura:

```bash
sudo dpkg --remove-architecture i386
```

<h3 style="color:red;">Comando *ss*</h3>

Verificar portas usadas no sistema:

```bash
sudo ss -ntpl
```

<h3 style="color:red;">Comando *trans*</h3>

Sintaxe:

```bash
trans -b en:pt-br 'The books on the table!'
```

Traduzir arquivos:

```bash
trans -b en:pt-br -i file.txt
```

<h3 style="color:red;">Comando *stat*</h3>

Ver info e metadados de arquivos:

```bash
stat arquivo.txt
```

<h3 style="color:red;">Comando *mktemp*</h3>

Gerar arquivos com nomes aleatórios:

```bash
mktemp XXXXXXX.tmp
```

<h3 style="color:red;">Comando *xclip*</h3>

#### Copiar para a área de transferência

Copiar:

```bash
<command> | xclip -selection clipboard
```

Removendo a *new line* (\n):

```bash
<command> | tr -d '\n' | xclip -selection clipboard
```

##### Alias'es

Definição:

```bash
alias cb="tr -d '\n' | xclip -selection clipboard"
```

Exemplo:

```bash
<command> | cb
```
	
#### Copiar somente para dentro da sessão do shell

Copiar:

```bash
<command> | xclip
```

Colar:

```bash
xclip -o
```

##### Alias'es

Para copiar:

```bash
alias c='xclip'
```

Para colar:

```bash
alias v='xclip -o'
```

Exemplo:

Para copiar:

```bash
<command> | c
```

Para colar:

```bash
<command> {`v`|$(v)}
```

<h3 style="color:red;">Matar processos no linux</h3>

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

<h3 style="color:red;">Busca de arquivos e diretorios</h3>

#### Comando *find*

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

#### Comando *locate*
	
Sintaxe:

```bash
locate file
```

Buscar por nome exato:

```bash
locate -b '\file.txt'
```

<h3 style="color:red;">Compactação de arquivos</h3>

#### Comando *tar*

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

#### Comando *zip*

Compactar em .zip:

```bash
zip target_folder.zip /folder/to/be/compressed_1 /folder/to/be/compressed_2 /file/to/be/compressed /for/compressed/multiples/*
```

Descompactar de .zip:

```bash
unzip compressed_folder.zip 
```

<h3 style="color:red;">Uso memória RAM</h3>

Comando *free*:

```bash
free -h
```

Comando *top*:

```bash
top
```

Comando *smem*:

```bash
smem -akt -P <program_name>
```

<h3 style="color:red;">Limpar memória cache</h3>

Comando:

```bash
sync; echo 3 > /proc/sys/vm/drop_caches
```

<h3 style="color:red;">Kernel do sistema</h3>

```bash
uname -r
```

<h3 style="color:red;">Rodar um comando em outra janela de terminal</h3>

#### Gnome-terminal

Abrindo em outra guia:

```bash
gnome-terminal -x sh -c "<command>; bash"
```

Abrindo em outra janela:

```bash
gnome-terminal -- sh -c "<command>; bash"
```

#### Terminator

Abrindo em outra janela:

```bash
terminator --command='<command>; bash'
```

<h3 style="color:red;">Rodar programas ou comandos em segundo plano</h3>

- Chamar o programa com *e comercial*:
	`<program> &`

- Dar `bg` com o programa em execução

- Dar `ctrl+z` com o programa em execução

Mostrar programas em segundo plano: 

```bash
jobs
```

Para trazer um programa para primeiro plano:

```bash
fg <program>
```

<h3 style="color:red;">Debugar scripts</h3>

Bash:

```bash
bash -x script.sh
```

Zsh:

```bash
zsh -xtrace script.sh
```

<h3 style="color:red;">Saber todos os programas que já foram instalados?</h3>

```bash
for history_file in $(ls ~/.*_history); do grep -Ei '(apt-get|apt) install' ${history_file}; done
```

<h3 style="color:red;">Atributos</h3>

Listar atributos:

```bash
lsattr
```

Adicionar atributo de imutabilidade:

```bash
sudo chattr +i file.txt
```

Removendo atributo de imutabilidade:

```bash
sudo chattr -i file.txt
```

Adicionar ou remover atributos recusivamente:

```bash
sudo chattr -R +i /path
```

<h3 style="color:red;">Manipulação de linhas</h3>

Excluir a última linha de um arquivo:

```bash
sed -i "$(wc -l < file.txt)d" file.txt
```

Recortar primeira linha de um arquivo:

```bash
head -1 file.txt > new_file.txt
```

Recortar primeira linha de um arquivo (para o mesmo arquivo):

```bash
echo $(head -1 file.txt) > file.txt
```

Recortar última linha de um arquivo:

```bash
tail -n 1 file.txt > new_file.txt
```

Recortar última linha de um arquivo (para o mesmo arquivo):

```bash
echo $(tail -n 1 file.txt) > file.txt
```

<h3 style="color:red;">Montagem/Desmontagem e ejeção de dispositivos</h3>

- X: Letra da partição
- Y: Número da partição

Montar:

```bash
sudo mount /dev/sdXY /mnt
```

Desmontar:

```bash
sudo umount /mnt
```

Ejetar:

```bash
sudo eject /dev/sdXY
```

<h3 style="color:red;">Manipulação de discos</h3>

- X: Letra do disco

#### Comando *fdisk*

Lista infos de todos os disco:

```bash
sudo fdisk -l
```

Lista infos de um disco específico:

```bash
sudo fdisk -l /dev/sdX
```

Criação de tabelas de partição e partições:

```bash
sudo fdisk /dev/sdX
```

#### Comando *mkfs*

Formatar em **ext4**:

```bash
sudo mkfs.ext4 /dev/sdX
```

Formatar em **fat32**:

```bash
sudo mkfs.fat -F 32 /dev/sdX
```

<h3 style="color:red;">Qemu</h3>

- X: Letra do disco
- -m: Memória RAM em MB
- -smp: Núcles do processador

Instalação:

```bash
sudo apt install qemu qemu-utils qemu-system-x86 -y
```

Criar disco:

```bash
qemu-img create -f qcow2 virtual_disk.qcow2 15G
```

#### BIOS (Legacy)

Subir VM:

```bash
qemu-system-x86_64 -enable-kvm -m 2048 -smp 2 -hda {virtual_disk.qcow2|/dev/sdX} -boot d -cdrom disk_image.iso
```

Iniciar o disco:

```bash
qemu-system-x86_64 -enable-kvm -m 2048 -smp 2 -hda {virtual_disk.qcow2|/dev/sdX}
```

#### UEFI

Dependência:

```bash
sudo apt install ovmf -y
```

Subir VM:

```bash
qemu-system-x86_64 -enable-kvm -bios /usr/share/ovmf/OVMF.fd -m 2048 -smp 2 -hda {virtual_disk.qcow2|/dev/sdX} -boot d -cdrom disk_image.iso
```

Iniciar o disco:

```bash
qemu-system-x86_64 -enable-kvm -bios /usr/share/ovmf/OVMF.fd -m 2048 -smp 2 -hda {virtual_disk.qcow2|/dev/sdX}
```

<h3 style="color:red;">Wi-fi CLI</h3>

#### Comando *iw*

Instalação:

```bash
sudo apt install wireless-tools -y
```

1. Verificar interfaces wireless:
	`iwconfig`
1. Verifique as redes disponíveis:
	`iwlist <interface> scan | grep -iF essid`
1. Rode o comando:
	`iwconfig <interface> essid <network_name> mode managed`
1. Gere o IP na rede:
	`dhclient <interface>`
1. Configure o arquivo *config file* de interfaces de rede:
	1. Edite o arquivo `/etc/network/interfaces` com seu editor a escolha:
		`sudo vim /etc/network/interfaces`
	1. Insira as seguintes linhas no arquivo:

```
auto wlan0
iface wlan0 inet dhcp
wpa-ssid <network_name>
wpa-psk <network_password>
```

6. Altere as permissões do arquivo pois deixará a senha exposta:
	`sudo chmod 600 /etc/network/interfaces`
1. Reinicie o serviço:
	`sudo service networking restart`

#### Comando *nmtui*

Instalação:

```bash
sudo apt install network-manager -y
```

Conectar rede wi-fi via CLI:

```bash
nmtui-connect
```

#### Comando *nmap*

Instalação:

```bash
sudo apt install nmap -y
```

Saber ips conectados a minha rede:

1. Saiba primeiro seu ip:
	`ip address`

1. Coloque no *nmap*:
	`sudo nmap -sn 192.168.0.1/24`

<h3 style="color:red;">Dispositivos de entrada</h3>

#### Alterar velocidade do ponteiro

Descobrir o código do dispositivo de entrada do *touch*:

```bash
xinput
```

Listar as propriedades do dispositivo grepando por *speed*:

```bash
xinput list-props <device_id> | grep -iF speed
```

Alterar o valor da respectiva propriedade:

```bash
xinput set-prop <device_id> <propertie_id> <value>
```

> Descobrir qual o range de valor para cada propriedade (*Accel Speed*: ['0.0'-'1.0'])

---

<a id="db_configuracao"></a>
[<span style="font-size:14px;">Configuração</span>](#menu)

<h3 style="color:red;">Comando *xrandr*</h3>

#### Mudar resolução da tela via terminal:

1. Verificar as saidas de vídeos possíveis:

```bash
xrandr
```

OBS: Guarda a informação do nome da sua saida de vídeos que por acaso pode ser DP1, VGA1 ou HDM1 por exemplo.

2. Caso a resolução desejada já esteja disponível, pode aplica-la

	1. Seta nova resolução:
		`xrandr -s 1920x1080`

1. Caso ainda não tenha a resolução desejada, adicione um novo modo com a desejada

	1. Pegando as cordenadas da tela informando a **resolução** e **hz** desejados:
		`cvt 1920 1080 90`
	1. Copie tudo o que estiver depois de *"Modeline "*:
		`"1920x1080_90.00"  269.00  1920 2064 2272 2624  1080 1083 1088 1140 -hsync +vsync`
	1. Agora criamos um novo modo com a informação coletada
		`xrandr --newmode "1920x1080_90.00"  269.00  1920 2064 2272 2624  1080 1083 1088 1140 -hsync +vsync`
	1. Agora adicionamos o novo modo criado ao *xrandr*:
		`xrandr --addmode Virtual1 1920x1080_90.00`
	1. Caso o passo anterior também já não sete a resolução de forma automática, setar manualmente o novo modo adicionado:
		`xrandr --output Virtual1 --mode 1920x1080_90.00`

##### Adicionar alterações de forma permanente

Adicione os comandos de criação, adição e definição do novo modo no *profile file*:

```
xrandr --newmode "1920x1080_90.00"  269.00  1920 2064 2272 2624  1080 1083 1088 1140 -hsync +vsync
xrandr --addmode Virtual1 1920x1080_90.00
xrandr --output Virtual1 --mode 1920x1080_90.00
```

<h3 style="color:red;">Variável *$PATH*</h3>

Adicionando diretórios ao *$PATH*:

```bash
export PATH=${PATH}:/home/user/scripts
```

OBS: Para adicionar permanentemente, insira o comando na última linha do rc do seu shell

<h3 style="color:red;">Data/Hora do sistema</h3>

Atualizando os dois manualmente:

```bash
sudo date -s "mes/dia/ano 13:30"
```

Atualizar hora automática:

```bash
sudo hwclock -s
```

<h3 style="color:red;">Layout do teclado</h3>

1. Edite o arquivo de configuração com seu editor de preferência:
	`sudo vim /etc/default/keyboard`
1. Altere o valor da variável *XKBLAYOUT* para o layout desejado (**abnt2** é o valor *br*):
	`XKBLAYOUT="br"`

<h3 style="color:red;">Mudar a "furtividade" de senhas</h3>

1. Edite o arquivo de alterações do sudoers:
	`sudo visudo -f /etc/sudoers.d/users`

1. Insira o conteúdo:
	`Defaults pwfeedback`

---

<a id="db_hardware"></a>
[<span style="font-size:14px;">Hardware</span>](#menu)

<h3 style="color:red;">Comando *lspci*</h3>

Saber qual a placa de vídeo:

```bash
lspci | grep -iF 'VGA'
```

<h3 style="color:red;">Mostra infos do sistema</h3>

Neofetch:

```bash
neofetch
```

Screenfecht:

```bash
screenfetch
```

<h3 style="color:red;">Infos do sistema</h3>

- `lshw`
- `inxi -Fxz`
- `hwinfo --short`

<h3 style="color:red;">Número de núcleos (cores) do processador</h3>

```bash
nproc
```

<h3 style="color:red;">Arquitetura do sistema</h3>

```bash
uname -m
```

<h3 style="color:red;">Interface gráfica atual</h3>

```bash
echo $XDG_CURRENT_DESKTOP
```

<h3 style="color:red;">Distro</h3>

Info geral da distro:

```bash
lsb_release -a
```

Somente o nome da distro:

```bash
lsb_release -cs
```

---

<a id="db_tutoriais"></a>
[<span style="font-size:14px;">Tutoriais</span>](#menu)

<h3 style="color:red;">Como inserir icones no "menu de aplicativos"</h3>

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

<h3 style="color:red;">Atualizar a versão da distro</h3>

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

<h3 style="color:red;">Mudar shell padrão</h3>

Mudando diretamente no arquivo:

```bash		
sudo vim /etc/passwd
```

Via linha de comando:

```bash
sudo chsh {--shell|-s} $(which zsh) {$(whoami)|${USER}}
```

<h3 style="color:red;">Alias'es (definir permanente)</h3>
	
1. Edite o rc do seu shell:

```bash
vim ~/.<shell>rc
```

2. Definina o *alias* na última linha do arquivo:

```bash
alias <shortcut_name>='<command>'
```

3. Recarregue o rc do seu shell:

```bash
source .bashrc
```

<h3 style="color:red;">Sistema de arquivos criptografado</h3>
	
1. Crie a privada que guardara os arquivos:

```bash
mkdir ~/private
```

2. Faça que apenas o dono tenha permissões sobre ela:

```bash
sudo chmod 600 ~/private
```

OBS: Primeiro faça o processo de montagem e depois coloque os arquivos dentro da pasta

3. Monte o sistema de arquivos com a pasta "*private*":

	1.  Montando a pasta:
		`mount -t ecryptfs ~/privado ~/privado`
	2. Escolha a opção **2**
	1. Digite a **senha**
	1. Escolha a opção **1**
	1. Escolha a opção **1** novamente
	1. Escolha **n**
	1. Escolha **n** novamente
	1. Escolha **yes**
	1. Escolha **yes** novamente

OBS: Coloque os arquivos na pasta

4. Desmonta a pasta (agora, efetivamente os arquivos estaram encriptados):

```bash
sudo umount ~/private
```

5. Monte novamente a pasta para conseguer ter acesso aos arquivos:

```bash
sudo mount -t ecryptfs ~/private ~/private -o key=passphrase,ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_passthrough=n
```

#### Alias'es

Para montar:

```bash
mountt() {
	sudo mount -t ecryptfs "$1" "$2"; 
}
```

Para montar:

```bash
remountt() {
	sudo mount -t ecryptfs "$1" "$2" -o key=passphrase,ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_passthrough=n
}
```

<h3 style="color:red;">Colocar programas no autostart (inicia junto com a sessão do usuário)</h3>

1. Crie um arquivo ".desktop" dentro da pasta "~/.config/autostart/"

1. Coloque nesse arquivo:

```
[Desktop Entry]
Type=Application
Name=program_name
Exec=/path/to/binary
StartupNotify=false
Terminal=false
```
	
Caso a pasta ainda não exista, basta cria-la:

```bash
mkdir ~/.config/autostart/
```

<h3 style="color:red;">Cron</h3>

#### Sintaxe e exemplo

Sintaxe:

```
m h dm m ds command
```

Exemplo de horario de segunda a sexta às 08:00:

```
0 8 * * 1,2,3,4,5
```

#### Utilização

1. Entrar no arquivo de configuração do cron para adicionar um novo:

```bash
crontab -e
```

2. Basta então inserir na última linha o comando

#### Editor padrão

Para mudar o editor do cron:

```bash
select-editor
```

<h3 style="color:red;">Caixas de diálogo</h3>

#### Notify-send

```bash
notify-send 'Atenção!' 'Reinicialização necessária.'
```

#### Zenity

#### Dialog

#### Whiptail

#### Toilet

<h3 style="color:red;">File Manager's</h3>

#### Thunar

##### Configurar "Open Terminal Here"

1. Entre em:
	`Edit » Configure custom actions... » Open Terminal Here » *engrenagem* » Command:`
1. Colocar o seguinte valor:
	`terminator --working-directory=%f`

---

<a id="ubuntu"></a>
## [> Ubuntu](#menu)

<h3 style="color:red;">Pesquisar pacotes</h3>

```
https://packages.ubuntu.com/
```

<h3 style="color:red;">Pesquisar manpages</h3>

Pesquisar na barrar de pesquisa da página:

```
https://manpages.ubuntu.com/manpages/
```

Pesquisar diretamente pela URL:

```
https://manpages.ubuntu.com/manpages/cgi-bin/search.py?q=<package_name>
```

<h3 style="color:red;">Pesquisar ppa's</h3>

```
https://launchpad.net/ubuntu/+ppas
```

---

<a id="git"></a>
## [> Git](#menu)

Renomear repositório remoto:

```bash
git remote rename <nome_atual> <novo_nome>
```

Pasta inacessível (pasta com *submodule*):

1. `git rm --cached <folder_name>`
1. `rm -rf <folder_name>/.git`
1. `git add .`
1. `git push origin master`

<h3 style="color:red;">Manipulação de branchs</h3>

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

<h3 style="color:red;">Visualização de log's</h3>

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

<h3 style="color:red;">Clonagem de repositórios</h3>

Clonar:

```bash
git clone <url>
```

Clonar de uma branch específica:

```bash
git clone -b <branch_name> <url>
```

<h3 style="color:red;">Manipular informações do usuário</h3>

```
~/.gitconfig
```

<h3 style="color:red;">Reverter commits</h3>

Apenas desfazer o commit (sem perder as alteraçẽos):

```bash
git reset --soft <hash_commit>
```

Desfazer os commits (sem manter as alterações):

```bash
git reset --hard <hash_commit>
```

<h3 style="color:red;">.gitignore</h3>

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

---

<a id="github_cli"></a>
## [> GitHub CLI](#menu)

Ver os repositórios remotos:

```bash
gh repo list
```

<h3 style="color:red;">Pull request's</h3>

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

---

<a id="arch_base"></a>
## [> Arch Base](#menu)

<h3 style="color:red;">PACMAN</h3>

Sincronização total/procura por atualização:

```bash
pacman -Syyu
```

Procura por um pacote:

```bash
pacman -Ss <package>
```

Instala um pacote:

```bash
pacman -S <package>
```

Apenas baixa o pacote e não o instala:

```bash
pacman -Sw <package>
```

Mostra informações de um pacote não instalado:

```bash
pacman -Si <package>
```

Mostra informações do pacote já instalado:

```bash
pacman -Qi <package>
```

Instala apenas as dependências:

```bash
pacman -Se <package>
```

Remove um pacote:

```bash
pacman -R <package>
```

Remove o pacote junto com as dependências não usadas por outros pacotes:

```bash
pacman -Rs <package>
```

<h3 style="color:red;">IWD</h3>

Editar o arquivo: /etc/iwd/main.conf

```
[General]
EnableNetworkConfiguration=true
[Network]
NameResolvingService=systemd
```

Habilitar e iniciar os seguintes serviços:

```bash
systemctl start iwd.service && systemctl enable iwd.service &&; \
systemctl start systemd-networkd.service && systemctl enable systemd-networkd.service; \
systemctl start systemd-resolved.service && systemctl enable systemd-resolved.service
```

---

<a id="estudos"></a>
## [> Estudos](#menu)

<h3 style="color:red;">Tipos de datas</h3>

- Access time
	- Explicação: data que o arquivo foi acessado ou lido pela última vez (sem modificações)
	- Exemplo: cat, head, vim, less

- Modify time
	- Explicação: data que o arquivo foi modificado pela última vez
	- Exemplo: editando o contúdo do arquivo, adicionando ou excluindo

- Change time
	- Explicação: data que o inode do arquivo é modificado
	- Exemplo: alterando permissões, propriedade, nome do arquivo ou número de links físicos
