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
	- [Any command](#db_any_command)
- [Ubuntu](#ubuntu)
- [Git](#git)
- [GitHub CLI](#github_cli)
- [Arch base](#arch_base)
- [Estudos](#estudos)

<a id="debian_base"></a>
## [> Debian base](#menu)

<a id="db_customizacao"></a>
[<span style="font-size:14px;">Customização</span>](#menu)

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

### Zsh

Colocar oh-my-zsh no root:

1. `sudo cp ${HOME}/.zshrc /root`
1. `sudo cp -r ${HOME}/.oh-my-zsh /root`

### Cursor

#### Instalar novo tema de cursor

Comando *[update-alternatives](#update-alternatives)*:

```bash
sudo update-alternatives --install /usr/share/icons/default/index.theme x-cursor-theme /path/to/folder/your/cursor/index.theme 722
```

OBS: O arquivo ".theme" do cursor deve conter no início da sessão a seguinte propriedade: `Inherits=<name_root_directory>`

#### Aplicar novo tema de cursor

Comando *[update-alternatives](#update-alternatives)*:

```bash
sudo update-alternatives --config x-cursor-theme
```

OBS: Precisa reiniciar a sessão para aplicar

---

<a id="db_pacotes"></a>
[<span style="font-size:14px;">Pacotes</span>](#menu)

### Comando *apt*

Remover completamente o programa:

```bash
sudo apt purge <package>
```
Fazer apenas o download do programa e suas dependências sem instalar:

```bash
sudo apt install --download-only <package>
```

OBS: Será salvo em `/var/cache/apt/archives`

### Comando *dpkg*

Listar todos os programas instalados:

```bash
sudo dpkg -l
```

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

<a id="db_programas"></a>
[<span style="font-size:14px;">Programas</span>](#menu)

### Instalar Wine

1. `sudo dpkg --add-architecture i386`
1. `wget -nc https://dl.winehq.org/wine-builds/winehq.key && sudo mv winehq.key /usr/share/keyrings/winehq-archive.key`
1. Verificar repo atual no site: https://wiki.winehq.org/Download
	1. `wget -nc https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources && sudo mv winehq-jammy.sources /etc/apt/sources.list.d/`
1. Verificar a branch desejada (stable pode não estar disponível)
	1. `sudo apt install --install-recommends winehq-(stable|devel) -y`
1. `winecfg` ou `sudo apt install wine -y`

### Instalar Plank

1. `sudo apt install chrome-gnome-shell plank -y`
1. https://extensions.gnome.org/extension/4198/dash-to-plank/

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

### Instalar Vagrant

1. `curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -`
1. `sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"`
1. `sudo apt update && sudo apt install vagrant`

### Instalar AbiWord

1. Instale as dependências:

```bash
sudo apt install libfribidi-dev libglib2.0-dev libwv-dev libxslt1-dev libgio2.0-cil-dev libgtk3.0-cil-dev libgtk-3-dev librsvg2-dev libabiword-3.0 libboost-dev -y
```

2. Baixe, compile e instale o programa:

```bash
mkdir /tmp/abiword && cd /tmp/abiword && wget 'http://www.abisource.com/downloads/abiword/3.0.5/source/abiword-3.0.5.tar.gz' && tar -zxvf abiword-3.0.5.tar.gz && cd abiword-3.0.5 && ./configure && sudo make -j8 && sudo make install
```

---

<a id="db_sistema"></a>
[<span style="font-size:14px;">Sistema</span>](#menu)

### Comando *acpi*

Ver porcentagem da bateria (notebooks):

```bash
acpi
```

### Comando *parted*

Lista os discos na máquina (saber se é HDD ou SSD pelo modelo):

```bash
parted -l
```

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

### Variáveis de ambiente (escopo global)

Mostrar variáveis de ambiente (do usuario corrente):

```bash
env
```

Criar variável de ambiente (escopo global):

```bash
export FOO="BAR"
```

### Mapear teclas e ações

Comando *xev*:

```bash
xev | sed -ne '/^KeyPress/,/^$/p'
```

Comando *xmodmap*:

```bash
xmodmap -pke
```

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

### Reiniciar o sistema

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

### Fonts

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

### Comando *tree*

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

### Comando *du*

Mostra o tamanho dos direitos:

```bash
du -sch ./*
```

### Comando *df*

Mostra partições e tamanho dos discos:

```bash
sudo df -h
```

### Comando *ncdu*

Ver tamanho de diretorios (CLI):

```bash
ncdu [<path>]
```

### Comando *grep*

- i: *Case insensitive*
- n: Número da linhas da ocorrência
- o: Somente a ocorrência e não a linha toda da mesma
- E: Expressão regular extendida
- R: Recursividade em arquivos

```bash
grep -inoER '^(hello|world)' {/some/path/file.txt|/some/path/*}
```

### Comando *hostname*

Saber hostname:

```bash
hostname
```

Ip interno:

```bash
hostname -I
```

### Comando *ls*

Mostra o *inode* do arquivo:

```bash
ls -i ~/file.txt
```

### Comando *file*

Mostra o tipo do arquivo e seu path:

```bash
file ~/file.txt
```

### Comando *ln*

Hard link (link físico)

- Hard links não podem ser feitos por arquivos que estão em pontos de montagem separados.

- O hard link tem o mesmo inode do original e se o original for corrompido o link fica independente.

```bash
ln ~/path/to/file.txt ~/path/hard_link_name
```

Symlink (link simbólico)

- Tem que passar o path completo para esta operação.

- O link simbólico terá um inode diferente do arquivo original e se arquivo original for corrompido o link quebrará.

```bash
ln -s ~/path/to/file.txt ~/path/symlink_name
```

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

### Comando *cal*

Calendário:

```bash
cal [<month>] [<year>]
```

### Comando *date*

Data/hora:

```bash
date
```

### Comando *sudo*

Passar senha de forma automática:

- -S: aceita que a STDIN seja diferente e espera receber no final da string uma nova linha

```bash
echo -e "<password>\n" | sudo -S <command>
```

#### Não guardar a senha em cache

Direto na linha de comando:

```bash
sudo -k <command>
```

Definir permanentemente:

1. Edite o arquivo de alterações do sudoers:
	`sudo visudo -f /etc/sudoers.d/users`
1. Colocar o seguinte conteúdo:
	`Defaults:ALL timestamp_timeout=0`

#### Arquivo **sudoers**

- Sempre editar o arquivo com o comando `visudo`
- Caso precise fazer alguma alteração nesse arquivo, altere o `/etc/sudoers.d`

Para criar um novo arquivo de config para poder manipular as configs:

```bash
sudo visudo -f /etc/sudoers.d/users
```
Para dizer que tal usuário pode executar somente alguns comandos como sudo:

```bash
user ALL=/usr/bin/dmesg,/usr/sbin/fdisk
```

Para não precisar de senha:

```bash
user ALL=NOPASSWD:/usr/bin/dmesg,/usr/sbin/fdisk
```

### Comando *exec*

Usando o *exec* junto com algum comando, depois de executado a sessão de terminal corrente é encerrada:

```bash
exec <command>
```

### Comando *xdotool*

Minimizar tela do terminal corrente:

1. `var=$(xdotool getactivewindow)`
1. `xdotool windowminimize $var`

### Comando *su*

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

### Comando *cd*

#### Voltar para o diretorio anterior

Com o caracter **-**:

```bash
cd -
```

Com a variável **$OLDPWD**:

```bash
cd $OLDPWD
```

### Comando *head*

Mostrar *x* primeiras linhas de um arquivo:

```bash
head -5 /etc/passwd
```

### Comando *column*

Organizar a saida em colunas:

- -s: Delimitador
- -t: Cria a tabela

```bash
column -s ':' -t /etc/passwd
```

### Comando *du*

Mostra o tamanho de um arquivo ou pasta:

```bash
du -sh /path/to/file_or_folder
```

Mostra o tamanho de todos os arquivos de uma pasta com o total:

```bash
du -sch /path/to/folder/*
```

### Comando *tail*

Mostra a última linha do arquivo:

```bash
tail -1 file.txt
```

Monitora o arquivo em tempo real:

```bash
tail -f file.txt
```

### Comando *ssh*

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
ssh {-X|-Y|-C} user@192.168.0.1
```

OBS: Caso dê algum erro de conexão com interface remova a pasta .Xauthority da *home*

- `rm -rfv ~/.Xauthority`

#### Comando *ssh-keygen*

Remover *fingerprint* depreciado:

```bash
ssh-keygen [-f /home/${USER}/.ssh/known_hosts] -R <host>
```

### Comando *scp*

Local -> Remoto:

```bash
scp -r /local/path user@192.168.0.1:/remote/path
```

Remoto -> Local:

```bash
scp -r user@192.168.0.1:/remote/path /local/path
```

### Comando *gsettings*

Mudar tema via CLI:

```bash
gsettings set org.gnome.desktop.interface gtk-theme "theme_name"
```

Mudar icone via CLI:

```bash
gsettings set org.gnome.desktop.interface icon-theme "icon_name"
```

### Comando *history*

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

### Comando *yes*

Loop infinito de "echo" (por default printa "y" na tela)?:

```bash
yes
```

Passando alguma string:

```bash
yes "no"
```

### Comando *cat*

Mostra a quantidade de linhas:

```bash
cat -n file.md
```

Utilizando com *heredocument*:

```bash
cat << EOF > file.txt
```

### Comando *progress*

```bash
<command> | progress -m
```

### Comando *cut*

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

### Comando *dpkg*

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

### Comando *ss*

Verificar portas usadas no sistema:

```bash
sudo ss -ntpl
```

### Comando *stat*

Ver info e metadados de arquivos:

```bash
stat arquivo.txt
```

### Comando *mktemp*

Gerar arquivos com nomes aleatórios:

```bash
mktemp XXXXXXX.tmp
```

### Comando *shuf*

Embaralhar linhas do arquivo:

```bash
shuf file.txt
```

Embaralhar, pegar a última linha e excluila:

```bash
random_word=$(shuf file.txt | tail -1); echo $random_word; sed -in "/${random_word}/d" file.txt
```

### Comando *dd*

Criar pendrive bootavel:

```bash
sudo dd if=/path/to/isos/iso.file of=/dev/sdX bs=256159 conv=fdatasync status=progress; sync
```

### Comando *sed*

Substituir nova linha por algum caracter:

```bash
sed -z's/\n/; /g' file.txt
```

### Comando *xargs*

- `cat file.txt | xargs sudo apt install -y`
- `xargs -a file.txt sudo apt install -y`
- `find ./ -iname '*.mp3' | xargs rm -f`

OBS: Pega a saida do pipe e concatena no final do comando que está a frente dele.

### Comando *shc*

- -o: Output, pode mudar o nome e path de saida
- -r: Deixa portável para outras distros
- -f: Informa qual o arquivo que será compilado

Compilar (transformar o script em binário):

```bash
shc -rf script.sh [-o binary.sh]
```

Compilar com data de expiração e informando uma mensagem:

```bash
shc -e 01/01/1991 -m 'Expirou, contate "rhuan.pksf@gmail.com".' -rf script.sh [-o binary.sh]
```

Será gerado dois arquivos, o binário propriamente dito e o código fonte em C que pode ser exlcuido ou você pode compila-lo também com `gcc script.sh.x.c`.

### Comando *xclip*

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

### Busca de arquivos e diretorios

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

### Compactação de arquivos

#### Comando *tar*

Compactar em .tar.gz:

```bash
tar -zcvf target_folder.tar.gz /file/to/be/compressed /folder/to/be/compressed/ /for/compressed/multiples/*
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
tar -xvf compressed_folder.tar.xz
```

#### Comando *zip*

Compactar:

```bash
zip target_folder.zip /file/to/be/compressed /folder/to/be/compressed/ /for/compressed/multiples/*
```

Descompactar:

```bash
unzip compressed_folder.zip
```

#### Comando *xz*

Compactar:

```bash
xz -vz /file/to/be/compressed
```

Descompactar:

```bash
xz -vd compressed_file.xz
```

### Uso memória RAM

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

### Limpar memória cache

Comando:

```bash
sync; echo 3 > /proc/sys/vm/drop_caches
```

### Kernel do sistema

```bash
uname -r
```

### Rodar um comando em outra janela de terminal

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

### Rodar programas ou comandos em segundo plano

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

### Debugar scripts

Bash:

```bash
bash -x script.sh
```

Zsh:

```bash
zsh -xtrace script.sh
```

### Saber todos os programas que já foram instalados?

```bash
for history_file in $(ls ~/.*_history); do grep -Ei '(apt-get|apt) install' ${history_file}; done
```

### Atributos

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

### Manipulação de linhas

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

### Montagem/Desmontagem e ejeção de dispositivos

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

#### MTP (media transfer protocol) (Android)

##### Comando *jmtpfs*

Programas necessários:

```bash
sudo apt install jmtpfs -y
```

Saber informação do *device*:

```bash
sudo jmtpfs -l
```

Montar:

```bash
sudo jmtpfs /mount/point -device=<bus_number>,<device_number> -o allow_other
```

Desmontar:

```bash
sudo umount /mount/point
```

##### Comando *gio*

Programas necessários:

```bash
sudo apt install gvfs-fuse gvfs-backends -y
```

Pegar informação do nome do path *device*:

```bash
gio mount -li | grep -iF activation_root
```

Montar:

```bash
gio mount '<device_path_name>'
```

Desmontar:

```bash
gio mount -u '<device_path_name>'
```

### Manipulação de discos

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

Programas necessários para `exfat`:

```bash
sudo apt install exfat-fuse -y
```

Formatar em **ext4**:

```bash
sudo mkfs.ext4 /dev/sdX
```

Formatar em **fat32**:

```bash
sudo mkfs.fat -F 32 /dev/sdX
```

Formatar em **exfat**:

```bash
sudo mkfs.exfat /dev/sdX
```

### Qemu

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

### Wi-fi CLI

#### Comando *nmcli*

Programa necessário:

```bash
sudo apt install network-amanger -y
```

Listar redes dispníveis:

```bash
nmcli device wifi list ifname wlp2s0
```

Conectar em rede simples (comum WPA2):

```bash
nmcli device wifi connect <ssid> password <password> ifname <network_interface>
```

Conectar em rede empresarial (enterprise WPA2 EAP):

```bash
$ nmcli con add type wifi ifname wlan0 con-name <connection_name> ssid <ssid>
$ nmcli con edit id <connection_name>
nmcli> set ipv4.method auto
nmcli> set wifi-sec.key-mgmt wpa-eap
nmcli> set 802-1x.eap peap
nmcli> set 802-1x.phase2-auth mschapv2
nmcli> set 802-1x.identity <username>
nmcli> set 802-1x.password <password>
nmcli> set 802-1x.ca-cert <certificate>
nmcli> set 802-1x.anonymous-identity <anonymous_identity>
nmcli> save
nmcli> activate
```

Simplesmente trocar de rede:

```bash
nmcli device wifi connect <ssid>
```

- Gerenciador simples gráfico do network-manager:
	`nm-applet`

- Editor simples gráfico do network-manager:
	`nm-connection-editor`

#### Comando *iw*

Instalação:

```bash
sudo apt install wireless-tools -y
```

OBS: Caso a interface esteja *down*: `ip link set <interface> up`

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

### Dispositivos de entrada

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

### Label de partições

Litar dispositivos e pontos de montagem com informações extras como LABEL e UUID:

```bash
lsblk --fs
```

#### Formatar adicionando a label:

Programas necessários para `exfat`:

```bash
sudo apt install exfat-fuse -y
```

- X: Letra da partição
- Y: Número da partição

Para ext4:

```bash
sudo mkfs.ext4 -L "label_name" /dev/sdXY
```

Para fat32:

```bash
sudo mkfs.fat -F 32 -n "label_name" /dev/sdXY
```

Para exfat:

```bash
sudo mkfs.exfat -L "label_name" /dev/sdXY
```

#### Saber ou renomear

Programas necessários para `exfat`:

```bash
sudo apt install exfat-fuse -y
```

- X: Letra da partição
- Y: Número da partição

Saber (ext4):

```bash
sudo e2label /dev/sdXY
```

Mudar (ext4):

```bash
sudo e2label /dev/sdXY label_name
```

Saber (fat32):

```bash
sudo mlabel -i /dev/sdXY -s ::
```

Mudar (fat32):

```bash
sudo mlabel -i /dev/sdXY ::label_name
```

Saber (exfat):

```bash
sudo exfatlabel /dev/sdXY
```

Mudar (exfat):

```bash
sudo exfatlabel /dev/sdXY "label_name"
```

### Shell

Saber shell atual:

```bash
ps -o comm= $$
```

<a id="forense"></a>
### Forense

#### Comando *shred*

- -v: Verboso
- -n: Número de vezes que passando sobrescrevendo com conteúdo randômico
- -z: Jogar zeros no final do procedimento
- -u: Remove o arquivo no final do procedimento

Sobrescrever o bloco (apagar o arquivo):

```bash
shred [-v|-n N|-z|-u] ./file.txt
```

Alias:

```bash
alias rms='shred -zuv'
```

OBS: Por padrão o comando shred sobrescreve o conteúdo do blocl 3x com conteúdo randômico.

#### Comando *sleuthkit*

Verificar partições e seus blocos:

```bash
sudo mmls /dev/sdX
```

Verificar tipo de tabela de partição:

```bash
sudo mmstat /dev/sdX
```

Verificar todos os arquivo de determinado disco a partir do bloco:

```bash
sudo fls -o <block_start> /dev/sdX
```

OBS: Os marcados com "**\***" são arquivos a serem recuperados.

Recuperar:

```bash
sudo icat -o <block_start> /dev/sdX <inode_file> > /tmp/recovered-file.txt
```

#### Comando *testdisk*

Programas necessários:

```bash
sudo apt install testdisk -y
```

Chame o comando e siga o procedimento para recuperação dos arquivos:

1. `Create`
1. `/dev/sdXY`
1. `{DOS|GTP}`
1. `Analyse`
1. `Quick Search`
1. `P`
1. `c`
1. `C`

OBS: Depois da opção "**P**", ler as opções dos comandos.

#### Comando *photorec*

Programas necessários:

```bash
sudo apt install testdisk -y
```

Chame o comando e siga o procedimento para recuperação completa de HD:

```bash
photorec
```

##### Recuperação de HDD/SSD?

1. Boot pela *iso live*
1. Conecte o HD externo que receberá os arquivo recuperados do HD comrrompido
1. Crite uma pasta no HD alvo que guardará os arquivos recuperados
1. Inicie o procedimento com o *photorec*

---

<a id="db_configuracao"></a>
[<span style="font-size:14px;">Configuração</span>](#menu)

### Comando *xrandr*

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
	1. Agora criamos um novo modo com a informação coletada:
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

### Variável *$PATH*

Adicionando diretórios ao *$PATH*:

```bash
export PATH=${PATH}:/home/user/scripts
```

OBS: Para adicionar permanentemente, insira o comando na última linha do rc do seu shell

### Data/Hora do sistema

Atualizando os dois manualmente:

```bash
sudo date -s "mes/dia/ano 13:30"
```

Atualizar hora automática:

```bash
sudo hwclock -s
```

### Layout do teclado

#### Config file

1. Edite o arquivo de configuração com seu editor de preferência:
	`sudo vim /etc/default/keyboard`
1. Altere o valor da variável *XKBLAYOUT* para o layout desejado (**abnt2** é o valor *br*):
	`XKBLAYOUT="br"`

#### Comando *setxkbmap*

Comando:

```bash
setxkbmap -layout br [-model abnt2] [-variant abnt2]
```

### Mudar a "furtividade" de senhas

1. Edite o arquivo de alterações do sudoers:
	`sudo visudo -f /etc/sudoers.d/users`

1. Insira o conteúdo:
	`Defaults pwfeedback`

---

<a id="db_hardware"></a>
[<span style="font-size:14px;">Hardware</span>](#menu)

### Comando *lspci*

Saber qual a placa de vídeo:

```bash
lspci | grep -iF 'VGA'
```

### Mostra infos do sistema

Neofetch:

```bash
neofetch
```

Screenfecht:

```bash
screenfetch
```

### Infos do sistema

- `lshw`
- `inxi -Fxz`
- `hwinfo --short`

### Número de núcleos (cores) do processador

```bash
nproc
```

### Arquitetura do sistema

```bash
uname -m
```

### Interface gráfica atual

```bash
echo $XDG_CURRENT_DESKTOP
```

### Distro

Info geral da distro:

```bash
lsb_release -a
```

Somente o nome da distro:

```bash
lsb_release -cs
```

### Fechar a tampa do notebook e não suspender

1. Editar o arquivo de configuração:
	`sudo vim /etc/systemd/logind.conf`

2. Descomente e deixe o valor das seguintes variáveis iguais:
	- `HandleLidSwitch=ignore`
	- `HandleLidSwitchExternalPower=ignore`
	- `HandleLidSwitchDocked=ignore`

3. Restarte o serviço responsável:
	`sudo systemctl restart systemd-logind.service`

---

<a id="db_tutoriais"></a>
[<span style="font-size:14px;">Tutoriais</span>](#menu)

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

### Mudar shell padrão

Mudando diretamente no arquivo:

```bash
sudo vim /etc/passwd
```

Via linha de comando:

```bash
sudo chsh {--shell|-s} $(which <shell>) {$(whoami)|${USER}}
```

OBS: Depois de realizar o procedimento reinicie a sessão.

### Alias'es (definir permanente)

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

### Sistema de arquivos criptografado

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

### Colocar programas no autostart (inicia junto com a sessão do usuário)

1. Crie um arquivo ".desktop" dentro da pasta `~/.config/autostart/`

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

### Cron

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

#### Problemas

Para alguns tipos de scripts pode ser que seja necessário a instalação do pacote **dbus-x11** (caso nos logs do cron acuse):

```bash
sudo apt install dbus-x11 -y
```

Para alguns tipos de scripts pode ser que seja necessário explicitar a variável **$DISPLAY** junto com o comando do cron (quando há a necessidade de printar notificações ou interações GUI?):

```bash
* * * * * export DISPLAY=:0; /absolute/path/to/script.sh
```

### Criar UEFI *iso file* a partir de uma iso BIOS

Instalação dos programas:

```bash
sudo apt install mkisofs xorriso isolinux p7zip-full p7zip-rar -y
```

1. Crie uma pasta para descompatar a iso dentro:
	`mkdir /tmp/uefi_iso_folder`
1. Mova a iso para dentro da pasta criada:
	`mv /path/to/iso_file.iso /tmp/uefi_iso_folder/`
1. Entre na pasta da iso:
	`cd /tmp/uefi_iso_folder`
1. Descompacte a iso:
	`7z x iso_file.iso`
1. Exclua a iso:
	`rm ./iso_file.iso`
1. Saia da pasta:
	`cd ../`
1. Crite a iso hybrida:

```bash
xorriso -as mkisofs \
	-o ./iso_file_uefi.iso \
	-c boot.cat \
	-b isolinux.bin \
	-no-emul-boot -boot-load-size 4 -boot-info-table \
	-isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
	-eltorito-alt-boot -e boot/grub/efi.img \
	-no-emul-boot -isohybrid-gpt-basdat \
	./uefi_iso_folder/
```

OBS:

- Os arquivo das opções **-c**, **-b** e **-e** estão implicitamente já dentro da pasta aonde descompactamos a iso (no exemplo em: `/tmp/uefi_iso_folder/`)
- A opção **-isohybrid-mbr** que busca o arquivo `isohdpfx.bin`, você pode confirmar se na sua distro ele ficou no mesmo caminho com o seguinte comando: `find / \( -path /proc -o -path /sys \) -prune -o -iname 'isohdpfx.bin' 2>&- | sed -E '/sys|proc/d'`
- A opção **-o** é o nome da nova iso que vai ser gerado e o seu caminho

### Instalçao e atualização do *grub*

Programas necessários:

```bash
sudo apt install grub-common grub-efi-amd64 grub-efi-amd64-bin grub-efi-amd64-signed grub2-common -y
```

#### Instalação

Instalar o grub no disco (DOS/Mbr):

```bash
sudo grub-install --target=x86_64-pc /dev/sda --root-directory=/
```

Instalar o grub no disco (GPT):

```bash
sudo grub-install --target=x86_64-efi /dev/sda --efi-directory=/boot/efi
```

#### Configuração

Gerar arquivo de configuração:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

#### Atualização

Atualizar o grub:

```bash
sudo update-grub
```

#### Reinstalar o grub (via *live*)

##### GPT

Se a tabela de partição do principal for GPT, boota UEFI:

1. `mount /dev/sda2 (root) /mnt/`
1. `monta /dev/sda1 (esp) /mnt/boot/efi`
1. `monta --bind /dev/ /mnt/dev/`
1. `monta --bind /proc/ /mnt/proc/`
1. `monta --bind /sys/ /mnt/sys/`
1. `monta --bind /var/ /mnt/var/`
1. `monta --bind /sys/firmware/efi/efivars/ /mnt/sys/firmware/efi/efivars/ (se não pegar a variáveis efi)`

1. `chroot /mnt`

1. `update-grub`
1. `grub-install --target=x86_64-efi /dev/sda --efi-directory=/boot/efi`

##### DOS/Mbr

Se a tabela de partição do principal for DOS/Mbr, boota BIOS/Legacy:

1. `monta /dev/sda1 (root) /mnt/`
1. `monta --bind /dev/ /mnt/dev/`
1. `monta --bind /proc/ /mnt/proc/`
1. `monta --bind /sys/ /mnt/sys/`
1. `monta --bind /var/ /mnt/var/`

1. `chroot /mnt`

1. `update-grub`
1. `grub-install --target=x86_64-pc /dev/sda --root-directory=/`

OBS: Independente do processo, depois caso ainda não boote (modo de emergência?) verificar o fstab.

#### os-prober

Path:

```
/etc/default/grub
```

Variável do os-prober:

```bash
GRUB_DISABLE_OS_PROBER=false
```

### Compilar da fonte

Programas necessários (fora as libs de cada particular):

```bash
sudo apt install build-essential -y
```

1. Executar o **"configure"** que veio na pasta do código fonte com "**./**":

```bash
./configure
```

OBS: Se retornar algum erro referente a falta de lib, simplesmente instale-a (sempre na versão dev da lib).

2. Execute o comando "**make**" no diretório do fonte em questão aonde está o "**Makefile**" que foi gerado a partir do "**configure**":

```bash
sudo make -j8
```

OBS: Se acusar algum erro de lib, instale-a e limpe o **make** com `sudo make clean all` e execute o `./configure` novamente.

3. Instale de fato o programa com:

```bash
sudo make install
```

### Ventoy

Criar pendrive bootavel com ventoy:

```bash
sudo ./Ventoy2Disk.sh -g -i /dev/sdx
```

Opções:

```
Ventoy2Disk.sh CMD [ OPTION ] /dev/sdX
  CMD:
    -i   install ventoy to sdX (fail if disk already installed with ventoy)
    -I   force install ventoy to sdX (no matter installed or not)
    -u   update ventoy in sdX

  OPTION: (optional)
   -r SIZE_MB  preserve some space at the bottom of the disk (only for install)
   -s          enable secure boot support (default is disabled)
   -g          use GPT partition style, default is MBR style (only for install)
```

Pc com secure boot (precisa fazer o procedimento somente a primeira vez):

```
OK -> "any key" -> Enroll Key From Disk -> VTOYEFI -> ENROLL_THIS_KEY_IN_MOKMANAGER.cer-> Cotinue -> Yes -> Reboot
```

OBS: O binário do ventoy tem que rodar estando na pasta com seus arquivos

### Multipass

Programas necessários:

```bash
sudo snap install multipass
```

Criar e já subir a *vm*:

```bash
multipass launch {<ubuntu_version>|<image_name>} --name <vm_name>
```

Listagem das *vm's*:

```bash
multipass list
```

Listar *vm's* disponíveis para *lauchear*:

```bash
multipass find
```

Executar comandos na *vm* "por fora":

```bash
multipass exec <vm_name> -- <command>
```

Logar no shell da *vm*:

```bash
multipass shell <vm_name>
```

Parar *vm*:

```bash
multipass stop <vm_name>
```

Deletar *vm* (quando estiver parada):

```bash
multipass delete <vm_name>
```

Atualiza a listagem das *vm's*:

```bash
multipass purge
```

### Update-alternatives

Instalando um novo programa no *update-alternatives*:

- link: link simbólico genérico já usado
- name: propriedade do update-alternative que está modificando
- path: caminho absoluto do programa original
- priority: prioridade de utilização sobre outros

```bash
sudo update-alternatives --install <link> <name> <path> <priority>
```

Exemplo de **análise** via print:

![instalacao_novo_update_alternatives](/assets/images/instalacao_novo_update_alternatives.png)

Link de exemplos de instalação e utilização com [cursores](#cursor) e somente de utilização para [editor de texto padrão](#editor-de-texto-padrão) e [terminal padrão](#terminal-padrão).

### Instalar Slax

Instalação padrão:

1. Crie uma partição para colocar o Slax, que seja fat32 e que seja tabela de partição de preferencia que seja MSDOS
1. Copia todos os arquivos do Slax para a partição
1. Rode o script de instalação do Slax dentro de /boot da pasta do Slax

Fazendo instalação no pendrive (mesmo proscedimento?):

1. Crie tabela de partição MSDOS
1. Crie uma partição do tamanho que quiser e formate em fat32 ou ext4
1. Extraia a iso do Slax
1. copie todo o conteúdo dela para dentro da partição
1. Vá para a pasta aonde a partição foi montada
1. Rode: `sudo bash ./slax/boot/bootinst.sh`

### File Manager's

#### Thunar

Configurar "Open Terminal Here":

1. Entre em:
	`Edit » Configure custom actions... » Open Terminal Here » *engrenagem* » Command:`
1. Colocar o seguinte valor:
	`terminator --working-directory=%f`

Adicionar pastas em "Palces":

1. `*botão direito na pasta* » Send To » Side Pane (Create Shortcurt)`

### Caixas de diálogo

#### Notify-send

```bash
notify-send 'Atenção!' 'Reinicialização necessária.'
```

#### Zenity

#### Dialog

#### Whiptail

#### Toilet

---

<a id="db_any_command"></a>
[<span style="font-size:14px;">Any command</span>](#menu)

### Comando *yt-dlp*

```bash
yt-dlp -S "ext:mp4,res:1080" <url>
```

### Comando *trans*

Sintaxe:

```bash
trans -b en:pt-br 'The books on the table!'
```

Traduzir arquivos:

```bash
trans -b en:pt-br -i file.txt
```

### Comando *jq*

Pretty Printer Formatter for JSON files:

Completo:

- `jq . file.json`
- `cat file.json | jq`
- `jq . file.json > pretty.json`
- `curl -fsSL --request GET --url 'https://jsonplaceholder.typicode.com/posts' --header 'Content-Type: application/json' | jq`

Mimificado:

- `jq -c < file.json`
- `cat file.json | jq -c`

### Manipulação de .pdf

#### Comando *wkhtmltopdf*

Programas necessários:

```bash
sudo apt install wkhtmltopdf -y
```

Fazer download de página web para pdf:

```bash
wkhtmltopdf '<page_url>' /output/path/to/file.pdf
```

#### Comando *pdftk*

Mesclar pdfs:

```bash
pdftk *.pdf /output/path/to/file.pdf
```

### Extrair arquivo iso

Programas necessários:

```bash
sudo apt install p7zip-full p7zip-rar -y
```

Extração:

```bash
7z x file.iso
```

---

<a id="ubuntu"></a>
## [> Ubuntu](#menu)

### Pesquisar pacotes

Ubuntu:

```
https://packages.ubuntu.com/
```

Gnome:

```
https://download.gnome.org/sources/
```

### Pesquisar manpages

Pesquisar na barrar de pesquisa da página:

```
https://manpages.ubuntu.com/manpages/
```

Pesquisar diretamente pela URL:

```
https://manpages.ubuntu.com/manpages/cgi-bin/search.py?q=<package_name>
```

### Pesquisar ppa's

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

### Flag's

Colocar tag em commits (da para clonar de um commit específico):

```bash
git tag -a -m "first tag" nametag 12a34b5
```

Remover tag:

```bash
git tag -d nametag
```

#### Clonando a partir

1. Clonar de uma tag:

```bash
git clone -b nametag 'git@github.com:rhuan-pk/teste.git'
```

2. Logo depois de clonar dessa forma, pode ser que clone sem branch, nesse caso:

```bash
git switch -c newbranch
```

---

<a id="github_cli"></a>
## [> GitHub CLI](#menu)

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

---

<a id="arch_base"></a>
## [> Arch Base](#menu)

### Pacman

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

### Iwd

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

---

### Arquivos removidos

Quando removemos algum arquivo, na verdade o que acontece é que o bloco no disco fica liberado para ser gravado outro conteúdo por cima ([conteúdo relacionado](#forense)).

---

### "/" no final da passagem de algum PATH

Estou fazendo esse artigo pois eu tive essa dúvida recentemente... em que casos e porque era ou não necessário a utilização da "/" no final de algum path na hora de passar na linha comdando? Por fim, em conversa com colegas da comunidade **slackjeff** e outros, fiz esses testes por conta própria e achei que poderia ser a dúvida de outros também.

No final desse post eu dei minha conclusão **PESSOAL**, não tenho LPIC 3, sou apenas um *jovem padawan* em evolução ainda, então, caso tenho cometido algum deslize, estou totalmente aberto a correções.

Para realizar os mesmo teste, basta cirar e entrar na pasta `/tmp/tmp` como segue na *gif* de exemplo:

![barra_final_path](/assets/gifs/barra_final_path.gif)

Deixarei o script que montei para o teste [nesse link](), basta executa-lo estando dentro de `/tmp/tmp`.

#### SEM a "/" no final e com uma PASTA já existente.

Path atual: `/tmp/tmp`

Conteúdo path atual: `file.txt, tmp/`
Conteúdo pasta já existente (tmp/):

Comando:

```bash
cp ./file.txt ./tmp
```

Retorno:

Conteúdo path atual: `file.txt, tmp/`
Conteúdo da pasta já existente (tmp/): `file.txt`

**RESULTADO**: Como já existia o arquivo "tmp" (no path atual que é para aonde estou copiando ele) e era uma pasta, copiou para dentro dela.

#### SEM a "/" no final e com um ARQUIVO já existente (tmp).

Path atual: `/tmp/tmp`
Conteúdo path atual: `file.txt, tmp`

Conteúdo de **file.txt**: `"hello world?"`
Conteúdo de **tmp**:

Comando:

```bash
cp ./file.txt ./tmp
```

Retorno:

Conteúdo path atual: `file.txt, tmp`

Conteúdo de **file.txt**: `"hello world?"`
Conteúdo de **tmp**: `"hello world?"`

**RESULTADO**: Como já existia o arquivo "tmp" (no path atual que é para aonde estou copiando ele) e era um arquivo, ele sobrescreveu o conteúdo.

#### SEM a "/" no final e sem nenhum ARQUIVO ou PASTA já existente.

Path atual: `/tmp/tmp`
Conteúdo path atual: `file.txt`

Conteúdo de **file.txt**: `"hello world?"`

Comando:

```bash
cp ./file.txt ./tmp
```

Retorno:

Conteúdo path atual: `file.txt, tmp`

Conteúdo de **file.txt**: `"hello world?"`
Conteúdo de **tmp**: `"hello world?"`

**RESULTADO**: Como não existia o arquivo "tmp" (no path atual que é para aonde estou copiando ele), ele criou o arquivo.

#### COM a "/" no final e com uma PASTA já existente.

Path atual: `/tmp/tmp`

Conteúdo path atual: `file.txt, tmp/`
Conteúdo pasta já existente (tmp/):

Comando:

```bash
cp ./file.txt ./tmp/
```

Retorno:

Conteúdo path atual: `file.txt, tmp/`
Conteúdo da pasta já existente (tmp/): `file.txt`

**RESULTADO**: Como já existia o arquivo "tmp" (no path atual que é para aonde estou copiando ele) e era uma pasta, copiou para dentro dela.

#### COM a "/" no final e com um ARQUIVO já existente (tmp).

Path atual: `/tmp/tmp`
Conteúdo path atual: `file.txt, tmp`

Conteúdo de **file.txt**: `"hello world?"`
Conteúdo de **tmp**:

Comando:

```bash
cp ./file.txt ./tmp/
```

Retorno:

```bash
cp: failed to access './tmp/': Not a directory
```

Conteúdo path atual: `file.txt, tmp`

Conteúdo de **file.txt**: `"hello world?"`
Conteúdo de **tmp**:

**RESULTADO**: Como já existia o arquivo "tmp" (no path atual que é para aonde estou copiando ele) porém, como não era uma pasta, retornou erro e não copiou.

#### COM a "/" no final e sem nenhum ARQUIVO ou PASTA já existente.

Path atual: `/tmp/tmp`
Conteúdo path atual: `file.txt`

Conteúdo de **file.txt**: `"hello world?"`

Comando:

```bash
cp ./file.txt ./tmp/
```

Retorno:

```bash
cp: cannot create regular file './tmp/': Not a directory
```

Conteúdo path atual: `file.txt`

Conteúdo de **file.txt**: `"hello world?"`

**RESULTADO**: Como não existia o arquivo "tmp" (no path atual que é para aonde estou copiando ele) e não era uma pasta, retornou erro e não copiou.

#### Conclusão:

Quando usamos "**/**" ao passar algum *path*, deixamos explícito que o alvo é uma **pasta/diretório** e não um arquivo **comum/regular**.

Porém, se usamos sem a "**/**", em tese, deixamos explícito que é um arquivo **regular** (já que com a "**/**" dizemos que **é**), mas, dependendo da situação, se o alvo for mesmo um diretório e não especificarmos a "**/**", ele conseguirá executar a ação (levando em consideração é claro que o esperado fosse que o alvo seja uma pasta mesmo).
