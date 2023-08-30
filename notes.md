<a id="menu"></a>
# >>> Comandos Aleatoriamente Úteis !

- [Debian Base](#debian_base)
	- [Customização](#db_customizacao)
	- [Pacotes](#db_pacotes)
	- [Programas](#db_programas)
	- [Sistema](#db_sistema)
	- [SysAdmin](#db_sysadmin)
	- [GNU/Linux && Bash](#db_gnulinux-bash)
	- [Configuração](#db_configuracao)
	- [Hardware](#db_hardware)
	- [Tutoriais](#db_tutoriais)
	- [Any Commands](#db_any_commands)
- [Ubuntu](#ubuntu)
- [Git](#git)
- [GitHub CLI](#github_cli)
- [Arch Base](#arch_base)
- [Android](#android)
- [Miscellaneous](#miscellaneous)
- [Estudos](#estudos)

<a id="debian_base"></a>
## [> Debian base](#menu)

<a id="db_customizacao"></a>
[<span style="font-size:14px;">Customização</span>](#menu)

### Manipulando Variável _PS1_ (_PROMPT_ 1)

Exibir _branch_ no terminal (**bash**):

```bash
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[0;35m\]$(__git_ps1)\[\033[00m\[\n\$ '
```

Cor para usuário **root** (**bash**):

```bash
export PS1='\[\033[01;31m\]\u@\h\[\033[01;37m\]:\[\033[00m\]\[\033[01;34m\]\w\[\033[01;37m\]$\[\033[00m\] '
```

Valores:

- `\u`: usuário atual;
- `\h`: nome da máquina (host);
- `\H`: nome da máquina completo;
- `\w`: diretório de trabalho atual;
- `\W`: diretório de trabalho atual com o nome base (último segmento) apenas;
- `$(__git_ps1 "%s")`: branch atual caso esteja em um repositório git, se não, não exibe nada;

OBS: para setar permanentemente, adicione essa script na última linha do arquivo ~/.bashrc (tanto na home do usuario normal quanto na home do root);

### ZSH

Setar _oh-my-zsh_ no **root**:

1. `sudo cp ${HOME}/.zshrc /root`
1. `sudo cp -r ${HOME}/.oh-my-zsh /root`

### Cursor

#### Instalar Novo Tema de Cursor

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

<a id="db_pacotes"></a>
[<span style="font-size:14px;">Pacotes</span>](#menu)

### Comando _apt_

Remover completamente o programa:

```bash
sudo apt purge <package>
```
Fazer apenas o download do programa e suas dependências sem instalar:

```bash
sudo apt install --download-only <package>
```

OBS: será salvo em `/var/cache/apt/archives`.

#### Chaves de Repo

Adicionar chave de repo diretamente pelo fingerprint da mesma:

```bash
sudo apt-key adv --keyserver <keyserver> --recv-keys <fingerprint>
```

_URL's_ de repositórios de chaves:

- <hkp://p80.pool.sks-keyservers.net:80>;
- <hkp://keyserver.ubuntu.com:80>;

### Comando *dpkg*

Listar todos os programas instalados:

```bash
sudo dpkg -l [<package>]
```

Listar todos os binários do pacote:

```bash
sudo dpkg -L <package>
```

Saber a qual pacote perterce determinado binário:

```bash
sudo dpkg -S <binary>
```

```bash
sudo dpkg -S <binary> | grep /usr/bin/<binary>
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

### Comando *wajig*

Programas necessários:

```bash
sudo apt install wajig -y
```

Saber o tamanho dos pacotes instalados

```bash
wajig large
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

### Instalar grub-customizer

1. Configure o repositório:

```bash
echo "deb https://ppa.launchpadcontent.net/danielrichter2007/grub-customizer/ubuntu `lsb_release -cs` main" | sudo tee /etc/apt/sources.list.d/grub-customizer.list
```

2. Baixe a chave púlica do repositório:

```bash
curl -fsSL 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x59dad276b942642b1bbd0eaca8aa1faa3f055c03' | sudo gpg --dearmor --output /etc/apt/trusted.gpg.d/grub-customizer.gpg
```

3. Atualize os repositórios:

```bash
sudo apt update
```

4. Instale o pacote:

```bash
sudo apt install -y grub-customizer
```

_pipeline_:

```bash
echo "deb https://ppa.launchpadcontent.net/danielrichter2007/grub-customizer/ubuntu `lsb_release -cs` main" | sudo tee /etc/apt/sources.list.d/grub-customizer.list && curl -fsSL 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x59dad276b942642b1bbd0eaca8aa1faa3f055c03' | sudo gpg --dearmor --output /etc/apt/trusted.gpg.d/grub-customizer.gpg && sudo apt update; sudo apt install -y grub-customizer
```

_REFERENCELINKS_:

- <https://launchpad.net/~danielrichter2007/+archive/ubuntu/grub-customizer>.

---

<a id="db_sistema"></a>
[<span style="font-size:14px;">Sistema</span>](#menu)

### Comando _acpi_

Ver porcentagem da bateria (_notebooks_):

```bash
acpi --battery
```

### Mapear Teclas e Ações

Comando _xev_:

```bash
xev | sed -ne '/^KeyPress/,/^$/p'
```

Comando _xmodmap_:

```bash
xmodmap -pke
```

### Dispositivos

#### _xinput_

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

OBS: descobrir qual o range de valor para cada propriedade (_Accel Speed_: ['0.0'-'1.0'])

#### _lsusb_

Listagem dos dispositivos:

```bash
lsusb
```

### Reiniciar o Sistema

_Reboot_:

```bash
reboot
```

_Shutdown_:

```bash
shutdown -r now
```

#### _systemctl_

Leve:

```bash
systemctl reboot
```

Forçado:

```bash
systemctl reboot -i
```

### Manipulação de Discos

- X: letra do disco;
- Y: número da partição;

#### Comando _fdisk_

Lista _infos_ de todos os discos:

```bash
sudo fdisk -l
```

Lista _infos_ de um disco específico:

```bash
sudo fdisk -l /dev/sdX
```

_Shell_ interativo do **fdisk** para manipulação avançadas da tabela de partiçẽos e partiçẽos:

```bash
sudo fdisk /dev/sdX
```

_REFERENCELINKS_:

- [MBR partitions types¹](https://en.wikipedia.org/wiki/Partition_type);
- [MBR partitions types²](https://tldp.org/HOWTO/Partition-Mass-Storage-Definitions-Naming-HOWTO/x190.html);
- [GPT partitions types](https://en.wikipedia.org/wiki/GUID_Partition_Table#Partition_type_GUIDs);

- [fdisk (archwiki)](https://wiki.archlinux.org/title/fdisk);

#### Comando _sfdisk_

_Backup_ do esquema de partições do _device_:

```bash
sfdisk -d /dev/sdX > ./partition_layout.dump
```

Restaurar _layout_ de partições _backupiado_:

```bash
sfdisk /dev/sdX < ./partition_layout.dump
```

Mover partições (alterar o valor de início e fim dos blocos):

```bash
echo '+<sectors>,' | sfdisk --move-data <device> -N <partition_number>
```

OBS: nesse caso, com o sinal de `+`, move-se o ínicio do setor para o valor de setores passados em `<sectors>`.

Reordernar partições (caso alguma tenha sido excluida ou tinha sido criada no meio de outros):

```bash
sfdisk -r /dev/sdX
```

_REFERENCELINKS_:

- [_reread/resort partitions_](https://serverfault.com/questions/36038/reread-partition-table-without-rebooting) (em caso mudança de na ordenação das partições);

#### Aumentar (_grow_) e "Encolher" (_shrink_) Partições

> "If you are growing a partition, you have to first resize the partition and then resize the filesystem on it, while for shrinking the filesystem must be resized before the partition to avoid data loss."

##### _Growing_

1. Aumente a partição (com `parted` no modo interativo):

```bash
(parted) resizepart <partition_number> <end_size>
```

2. Aumente o sistema de arquivos (`ext*`):

```bash
resize2fs /dev/sdXY <new_size>
```

##### _Shrinking_

1. Diminua o sistema de arquivos (`ext*`):

```bash
resize2fs /dev/sdXY <new_size>
```

2. Diminua a partição (com `parted` no modo interativo):

```bash
(parted) resizepart <partition_number> <end_size>
```

3. Informe ao **kernel** sobre a mudança:

```bash
resizepart <device> <parition_number> <new_size>
```

_OBSERVATIONS_:

- _unit of measurement_:
	- `parted`: `MB, GB` or `10%`.
	- `resize2fs`: `K`, `M`, `G` and `T`.
	- `resizepart`: `512-byte` _sectors_.

- caso a partição seja `exfat` realize somente o passo 2?

#### Formulas de cálculo entre MB/GB e SETORES

- SECTORS » MB: `<sectors>/2/1024`
- SECTORS » GB: `<sectors>/2/1024^2`

- MB » SECTORS: `<megabytes>*1048576/512`
- GB » SECTORS: `<gigabytes>*(1048576*1024)/512`

#### Comando _parted_

Lista os discos na máquina:

```bash
parted -l
```

#### Formatação e Gerenciamento de Labels de Partições:

Programas necessários para `fat32`:

```bash
sudo apt install mtools -y
```

Programas necessários para `exfat`:

```bash
sudo apt install exfat-fuse -y
```

##### Comando _mkfs_

Formatar **fat32**:

- `-n`: adiciona label na formatação.

```bash
sudo mkfs.fat -F 32 [-n <label_name>] /dev/sdXY
```

Formatar **ext4**:

- `-L`: adiciona label na formatação.

```bash
sudo mkfs.ext4 [-L <label_name>] /dev/sdXY
```

Formatar **exfat**:

- `-L`: adiciona label na formatação.

```bash
sudo mkfs.exfat [-L <label_name>] /dev/sdXY
```

##### Saber ou Renomear Labels

###### `ext4`

Saber:

```bash
sudo e2label /dev/sdXY
```

Renomear:

```bash
sudo e2label /dev/sdXY label_name
```

###### `fat32`

Saber:

```bash
sudo mlabel -i /dev/sdXY -s ::
```

Renomear:

```bash
sudo mlabel -i /dev/sdXY ::label_name
```

###### `exfat`

Saber:

```bash
sudo exfatlabel /dev/sdXY
```

Renomear:

```bash
sudo exfatlabel /dev/sdXY label_name
```

### _Runlevels_/_Targets_

_Runleveis_ são os níveis de execução do sistema, cada **Runlevel** diz ao sistema em qual "camada" o sistema deve operar, qual o seu estado atual.

> Como também é um recurso de segurança do Linux, um dos critérios para saber se um devido processo deve ser executado ou não são justamente os _Runlevel's_?

Originalmente criado no _SysV init system_, o _Systemd_ trás o mesmo conceito só que trabalhando com outra conveção, por exemplo, o equivalente aos _Runleveis_ no _Systemd_ são os **Targets**.

Os _Runlevel's_ variam de 0 - 6:

| RUNLEVEL | MODE               | ACTION                                                     |
| :------- | :----------------- | :--------------------------------------------------------- |
| 0        | `Halt`             | Shuts down system.                                         |
| 1        | `Mono-User`        | Recovery mode, does not configure network, only root user. |
| 2        | -                  | -                                                          |
| 3        | `Multi-User`       | Starts system without GUI.                                 |
| 4        | -                  | -                                                          |
| 5        | `Graphical Server` | Starts system with GUI.                                    |
| 6        | `Reboot`           | Reboots the system.                                        |

Na tabela convertendo _Runlevel's_ para _Targets_:

| Traditional Runlevel | New Target Name  -  Symbolically Link     |
| :------------------- | :---------------------------------------- |
| Runlevel 0           | _runlevel0.target_ -> `poweroff.target`   |
| Runlevel 1           | _runlevel1.target_ -> `rescue.target`     |
| Runlevel 2           | _runlevel2.target_ -> `multi-user.target` |
| Runlevel 3           | _runlevel3.target_ -> `multi-user.target` |
| Runlevel 4           | _runlevel4.target_ -> `multi-user.target` |
| Runlevel 5           | _runlevel5.target_ -> `graphical.target`  |
| Runlevel 6           | _runlevel6.target_ -> `reboot.target`     |

#### Files and Directories

Diretório dos _targets_:

```
/lib/systemd/system/
```

#### Commands

Verificar o **runlevel** atual:

```bash
runlevel
```

Verificar qual _target_ padrão está definido para o _systemd_:

```bash
systemctl get-default
```

Listar todos os _targets_ disponíveis no sistema:

```bash
systemctl list-units --type=target --all
```

Mudar o _target_ (**runlevel**) padrão:

```bash
systemctl set-default multi-user.target
```

Mudar o _target_ (**runlevel**) somente para o próximo _boot_:

```bash
systemctl isolate rescue.target
```

Chamar **runlevel**:

```bash
telinit <runlevel_number>
```

_REFERENCELINKS_:

- [Base Content](https://www.youtube.com/watch?v=NQ1j441a0sU);

- [Runlevel's and Targets (from RedHat)](https://access.redhat.com/articles/754933).

---

<a id="db_sysadmin"></a>
[<span style="font-size:14px;">SysAdmin</span>](#menu)

### Comando *tree*

- -a: lista também arquivos ocultos.
- -F: na saida coloca uma `/` no final do nome do arquivo caso seja um diretório.
- -L <value>: limita a quantidade de níveis de diretórios na buscar.
- -C: *seta* "*color always*".
- -p: coloca na saida as permissões dos arquivos.
- -P <pattern>: retorna o que casar com o padrão (aceita coringas).

```bash
tree [<options>]
```

Buscar o caminho de somente um arquivo:

```bash
tree /path --matchdirs --prune -P pattern2search
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

- -i: *Case insensitive*.
- -r: Recursividade não seguindo symlinks.
- -n: Número da linhas da ocorrência.
- -E: Expressão regular extendida.
- -R: Recursividade seguindo symlinks.
- -A \<number\>: Quantidade de linhas a baixo da *match line* para ser exibida.
- -o: Somente a ocorrência e não a linha toda da mesma.
- -v: Inverte a ocorrência, todas as linhas que não casaram.
- -s: Suprime somente as mensagens de erro.
- -I: Rejeita arquivos binários na busca.

```bash
grep -irnE '^(hello|world)' {/some/path/file.txt|/some/path/}
```

#### Opção *exclude*

Exclude em arquivos:

```bash
grep --exclude=*file_{3,4}* -inrE '(match)' ./
```

Exclude em diretórios:

```bash
grep --exclude-dir={dir_1,dir_2} -inrE '(match)' ./
```

OBS: irá excluir todos os arquivos/diretórios independente do nível da pasta que o grep estiver percorrendo que casar com a cadeia do `exclude` passado a partir da pasta *root* passada.

### Comando *hostname*

Saber hostname:

```bash
hostname
```

Ip interno:

```bash
hostname -I
```

### Comando _ls_

- `-a`: exibe todos arquivos ocultos;
- `-A`: exibe todos arquivos ocultos exceto `.` e `..`;
- `-l`: forma longa (tipo de arquivo, dono, grupo, tamanho, _mtime_);
- `-h`: saída humana (mostra o tamanho com valor convertido);
- `-t`: ordena pelo _mtime_;
- `-i`: mostra o _inode_ dos arquivos;
- `-d`: não expande diretórios em busca com _globs_;
- `-F`: caso o arquivo seja uma pasta coloca uma "/" no final;
- `--color={auto|never|always}`: mudar status da cor na saída.

Lista arquivos e/ou diretórios:

```bash
ls [--color={auto|never|always}] [-aAlhtidF] /path/to/any
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

- -S: aceita receber entrada via *pipe* (*STDIN*) e espera receber no final da string uma nova linha.
- -k: reseta ou não salva a senha no cache
- -v: valida ou atualiza o tempo de cache da senha

#### Passar senha de forma automática

Alta usabilidade em scripts:

```bash
echo -e "<password>\n" | sudo -S <command>
```

#### Tempo do cache da senha

Reseta o tempo de cache:

```bash
sudo -k
```

Rodar o comando sem guardar a senha em cache:

```bash
sudo -k <command>
```

Definir zero cache permanentemente:

1. Edite o arquivo de alterações do sudoers:
	`sudo visudo -f /etc/sudoers.d/users`
1. Colocar o seguinte conteúdo:
	`Defaults:ALL timestamp_timeout=0`

#### Validação da senha e refresh do cache

Dentro de scripts: caso queria validar a senha do usuário e sem precisar rodar o sudo com algum comando:

```bash
read -rsp 'Entre com a senha: ' password
echo -e "${password}\n" | sudo -Sv
```

Dentro de script ou mesmo fora: atualizar o cache da senha:

```bash
sudo -v
```

#### Arquivo *sudoers*

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

### Comando _ssh_

Instalação:

```bash
sudo apt install -y ssh
```

#### Arquivos

Pastas de configuração:

```bash
# Pasta geral de configuração
/etc/ssh/

# Pasta de configuração do usuário (cliente)
/etc/ssh/ssh_config.d/

# Pasta de configuração do usuário (servidor)
/etc/ssh/sshd_config.d/
```

Arquivos de coniguração:

```bash
# Arquivo geral de configuração do usuário (cliente)
/etc/ssh/ssh_config

# Arquivo geral de configuração do usuário (servidor)
/etc/ssh/sshd_config
```

#### Conexões

Apenas "CLI":

```bash
ssh user@192.168.0.1
```

Acessar "GUI":

```bash
ssh -X user@192.168.0.1
```

OBS: Caso dê algum erro de conexão com interface remova a pasta .Xauthority da *home*: `rm -rfv ~/.Xauthority`

**Medidas de segurança**:

- Aumentar a porta de conexão:
	`Port <port_number>`.

- Tempo de inatividade (em segundos) até tomar *dc* (*disconect*):
	- `ClientAliveInterval <value>`.
	- `ClientAliveCountMax 0`.

- Não permitir senha vazias:
	`PermitEmptyPasswords no`.

- Não permitir o acesso direto ao *root user*:
	`PermitRootLogin no`.

- Explicitar o protocolo mais a tual a ser usado:
	`Protocol 2`.

- Caso queria retirar a autênticação por senha para poder logar somente com chaves:
	`PasswordAuthentication no`.

- Máximo de tentativas de conexão:
	`MaxAuthTries <tries_number>`.

_REFERENCELINKS_:

- <https://manpages.debian.org/unstable/openssh-server/sshd_config.5.en.html>.

#### _ssh keys/agents_

Criar ssh key:

```bash
ssh-keygen -t rsa -b 4096
```

Iniciar um agente *ssh* (quando algo buscar por uma chave é o *ssh-agent* que irá fornecer):

```bash
eval `ssh-agent -s`
```

OBS: Essa forma passada é a forma oficial descrita no manual do *ssh*. outros meios de iniciar o *ssh-agent* seria `ssh-agent -s` ou `exec ssh-agent bash`.

Adicionar chave ao agente:

```bash
ssh-add -k ~/.ssh/id_rsa
```

Verificar as chaves publicas adicionadas no agente:

```bash
ssh-add -l
```

Ver o *pid* e o *socket* do agente:

```bash
printenv SSH_AGENT_PID SSH_AUTH_SOCK
```

Remover *fingerprint* depreciado:

```bash
ssh-keygen [-f /home/${USER}/.ssh/known_hosts] -R <host>
```

Adicionar sua chave num servidor:

```bash
ssh-copy-id -i <identity_file> [-p <port>] <user>@<host>
```

Pegar as chaves pública de um servidor:

```bash
ssh-keyscan [-p <port>] [-t {rsa|,dsa|,ecdsa|,ed25519}] <server_ip> >> ~/.ssh/know_hosts
```

Trocar a senha de alguma chave:

```bash
ssh-keygen -pf ~/.ssh/key_file
```

##### Adicionar a chave ao *ssh-agent* automáticamente.

1. De forma manual (mais segura?):

	- Deixe a chave ssh criptografada (com algum utilitário como *toplip*, *gpg* ou algum de sua escolha).
	- Iniciado a sessão, descriptografe a chave.
	- Faça o processo manual de colocar a chave no agente.

2. De forma automática (usando o keychain):

	- Configure o arquivo `~/.ssh/config`.
	- Instale o *keychain*.
	- Configure o *keychain* no `~/.bash_profile`.

Exemplo de configuração para o *ssh* (`~/.ssh/config`):

```bash
Host *
	UseKeychain yes
	AddKeysToAgent yes
	IdentityFile ~/.ssh/id_rsa
```

Exemplo de configuração `keychain` (`~/.bash_profile`):

```bash
/usr/bin/keychain --clear ~/.ssh/id_rsa
. ~/.keychain/$(hostname)-sh
```

_CONSIDERATIONS_:

Quando criamos as chaves *ssh* para o **git** por exemplo, não necessariamente precisamos adiciona-la ao *ssh-agent*, pois, caso você tente dar algum clone ou push (utilizando conexão *ssh* obviamente), por padrão o protocolo procurará se existe alguma chave no *default path* do *ssh* (`~/.ssh/id_rsa`). Quando for manipular o respositório **git**, será encontrado a chave privada e será pedido sua senha (é claro que, caso tenha a chave adicionada ao *ssh-agent*, ele nem se quer irá pedir a senha, a autênticação será automática).

#### Banners

Para mostrar mensagem antes de se logar precisa colocar a mensagem no *banner*:
	`sudo vim /etc/ssh/banner`

Depois coloque o caminho do *banner* na variável dentro do arquivo de configuração:
	`Banner /etc/ssh/banner`

#### Tips

_Auto accept_ novo host:

```bash
ssh -o StrictHostKeychecking=no <user>@<host>
```

#### Troubleshooting

A versão 9 e posterior do _openssh_ agora usar o `ssh.socket` como gatilho para o daemon (`ssh.service`) e por exemplo a porta é ouvido pelo que diz o `ssh.socket`, nesse caso, o que resolve é desabilitar o `ssh.socket`, remover o arquivo que força a sua chamada e habilitar o `ssh.service`:

1. `sudo systemctl disable --now ssh.socket`
1. `sudo rm -f /etc/systemd/system/ssh.service.d/00-socket.conf`
1. `sudo systemctl enable --now ssh.service`

_pipeline_:

```bash
sudo systemctl disable --now ssh.socket && sudo rm -f /etc/systemd/system/ssh.service.d/00-socket.conf && sudo systemctl enable --now ssh.service
```

### Comando *gpg*

Gerar chave gpg (o geramento da chave não gera nenhuma saida e é guardada automáticamente no chaveiro gpg, para podermos acessa-la, logo, é só via exportamento):

```bash
gpg --full-generate-key
```

Listar chaves públicas:

```bash
gpg -k
```

Listar chaves privadas:

```bash
gpg -K
```
Fingerprint das cahves (16 últimos dígitos da chave):

```bash
gpg --fingerprint
```

Gerar certificado de revogação:

```bash
gpg --gen-revoke <key_id> > /path/to/revocation.crt
```

Exportar chave pública (gerar o arquivo da chave pública):

```bash
gpg --export --armor <key_id> > any_pub_key
```

Exportar chave privada (gerar o arquivo da chave privada):

```bash
gpg --export-secret-key --armor <key_id> > any_secret_key
```

Criptografar de forma simétrica a chave (*password* única):

```bash
gpg --symmetric /path/to/file.any
```

Descriptografar de forma simétrica a chave (*password* única):

```bash
gpg --decrypt /path/to/file.any
```

Importar chave pública para o chaveiro:

```bash
gpg --import /path/to/key_file.any
```

Assinar texto de entrada com chave de forma limpa (sem criptográfia):

```bash
gpg --clear-sign > /path/to/file.asc
```

Assinar texto de entrada com chave de forma suja (com criptográfia):

```bash
gpg --sign > /path/to/file.asc
```

Assinar arquivo com chave de forma limpa (sem criptográfia):

```bash
gpg --clear-sign /path/to/file.any
```

Assinar arquivo com chave de forma suja (com criptográfia):

```bash
gpg --sign /path/to/file.any
```

Valida a integridade do arquivo (verifica se a assinatura do arquivo condiz com o conteúdo):

```bash
gpg --verify /path/to/file.any
```

Descriptografar já validando a integridade da mensagem ou arquivo:

```bash
gpg --output /path/to/file.decrypted --decrypt /path/to/file.any
```

Criptografar de forma asimétrica (*pair of keys*):

```bash
gpg --encrypt --recipient <pub_key_id> /path/to/file.any
```

Descriptografar de forma asimétrica (*pair of keys*):

```bash
gpg --output /path/to/file.decrypted --decrypt /path/to/file.any
```

OBS: Nesse caso você não precisa informar o recipiente privado (a chave privada) pois em tese ela já está em seu chaveiro privado.

Mudar o "nível de segurança da chave":

- `gpg --edit-key <key_id>`
- `gpg> trust`
- *choice*
- `gpg> save`

Desempacote blindagem ASCII e empacota blindando em OpenPGP (*output redirecting and pipe entring accepted*):

```bash
gpg --dearmor /path/to/armored_key.asc
```

_OBSERVATIONS_:

- todos os redirecionamento de arquivo feitos podem ser substituídos pelo arugmneto do próprio comando (`--output /path/to/file.any`), logo isso implica que se não passado o argumento próprio ou o redirecionamento do arquivo, a STDOUT é a padrão (a tela).

- todos os argumentos `<key_id>` podem ser substituídos pelos meio de identificação da chave, por exemplos, *e-mail* ou *fingerprint* da mesma.

- todos os comandos que pedem a senha via GUI, podem ser substituídos a entrada para CLI adicionando os parâmetros: `--batch --passphrase <password>`

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

Habilitar/Desabilitar a o bloquei de tela (e a suspenção) quando escurece a tela:

```bash
gsettings set org.gnome.desktop.screensaver lock-enabled {true|false}
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
sed -z 's/\n/; /g' /path/to/file.txt
```

Buscar as linhas que casam com o primeiro grupo de pattern (o que estiver depois de `s/`) e o retorno será somente o *match* de `(.*)`:

```bash
sed -nE 's/^some_string\(to_match\) (.*)/\1/p' /path/to/file.txt
```

OBS: dessa forma é como se o `sed` buscasse a linha e já a recortasse (equivalente a uma pipeline de `grep | cut | sed | tr`), apesar de que o utilizador pode ficar limitado ao uso de *regex* pois os metacaracteres `.*` serão expandidos e não utilizado para a busca.

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

### Comando *curl*

- -f: caso *request* retorne algum código de erro, suprime a saida (*body response*).
- -s: silência o **curl**, suprime o progresso ou mensagens de erro, porém, mostra a *response* normalmente.
- -S: mostra o erro, caso ele ocorra enquanto a saida está silênciada (`-s`).
- -L: tentar encontrar a nova *url* caso a que esteja batendo tenha caido.
- -o: informa o nome de saida do arquivo.
- -d: *put* no *field* informado.
- -k: desabilita verificações de segurança (*SSL* e etc).
- -u <user>:<password>: para fazer autênticação única.
- -v: modo verboso.
- -i: retorna o cabeçalho da requisição.

Sintaxe comum para download:

```bash
curl [-o /path/to/save.any] -fsSL <url>
```

Popular *field* no *html* de determinado endereço:

```bash
curl -d <field_name>='<message>' <url>
```

Sintaxe básica para request:

```bash
curl -fsSL --request <method> --url <url> --header 'Content-Type: application/json' [--data '<json>']
```

Arquivos na request:

```bash
curl <url> -X POST -H 'Content-Type: multipart/form-data' -F 'file=@/path/to/file.zip'
```

Requisição com "multipart/form-data":

```bash
curl -X POST -H 'Content-Type: application/x-www-form-urlencoded' -d '<field>=<value>' <url>
```

### Comando *wget*

- -P: diretório alternativo para salvar o arquivo.
- -O: mudar o nome de saida do arquivo.
- -c: continua um download que foi interrompido.

Sintaxe comum para download:

```bash
wget [-P /path/to/save/|-O altered_name.any] <url>
```

OBS:

- As opções `-P` e `-O` não podem ser usadas juntas.
- Opção `-c`: simplesmente inicie novamente o download com esta opção estando na mesma pasta que está o arquivo imcompleto.

### Comando *journalctl*

Monitorar algum *.service* do sistema:

- -x: deixa visualmente a saida mais legível (pretty).
- -f: fica seguindo/escutando novos logs do *deamon* (equivalente ao `tail -f`).
- -u: especifique o nome da unidade.

```bash
sudo journalctl -xfu <name_service>.service
```

### Comando *trap*

Comando *built-in* do sistema que intercepta os sináis passsado por parâmetro do *script* no qual ele foi chamado.

```bash
#!/bin/bash

trap "echo 'O programa foi encerrado!'" SIGINT SIGTSTP SIGTERM SIGKILL EXIT

read -p "Entre: " input
echo "${input}"

trap - SIGINT SIGTSTP SIGTERM SIGKILL EXIT
```

No caso de exemplo, é chamando o comando de armadilha no qual é acionado quando o *script* que está rodando receber um dos sináis passado a partir do segundo argumento. Quando o mesmo é acionado, é executado o que está como primeiro parâmetro passado para o `trap` comando.

Depois de se utilizar das trativas de armadilha, podemos resetar as funções padrões que o *script* teria antes de alterarmos seu comportamento chamando um `-` como primeiro argumento e partir do segundo, da mesma forma, todos os sinais usados.

### Comando *systemctl*

- --type: filtra pelo tipo de unidade.
- --state: filtra pelo estádo da unidade.

Listar todas as unidades do sistema:

```bash
systemctl list-units [--type service] [--state running]
```

- --reverse: mostra as dependências reversas (quais serviços dependem deste).

Listar todas as dependências de uma unidade:

```bash
systemctl list-dependencies [--reverse] <service_name>.service
```

### Comando *sysctl*

Troca a porcentagem de uso de disco (que está sobrando) para que a *swap* seja ativada:

```bash
sudo sysctl vm.swappiness=<value_that_is_left>
```

OBS: No caso, se quiser que a *swap* seja ativa com 90% de uso de disco, defina o valor para 10.

### Comando *passwd*

Alterar a senha de um usuário:

```bash
sudo passwd <user>
```

Limpar a senha de um usuário:

```bash
sudo passwd -d <user>
```

Bloquear a senha de um usuário:

```bash
sudo passwd -l <user>
```

Desbloquear a senha de um usuário:

```bash
sudo passwd -u <user>
```

OBS:

- Simplesmente limpar a senha do usuário o fara ficar sem senha, ou seja, ele ficará sem esse token de autênticação (*e.g.* se tentar logar na conta do usuário, não pedirá a senha).

- Bloquear e desbloquear a senha de uma usuário implica somente da senha do mesmo, ou seja, caso bloqueamos a senha de um usuário, ele poderá fazer login por outro tipo de *token* (algum tipo de chave por exemplo).

- Caso queira "bloquear"/"desativar" a conta do usuário, poderá limpar a sua senha (*-d*) e depois bloea-la (*-l*), depois dessa combinação, só podera logar pelo usuário de forma direta criando uma nova senha para o mesmo.

### Comando *losetup*

Listar todos os dispositivos de bloco:

```bash
sudo losetup -a
```

#### Desmontar e remover um *loop device*

1. Desmontar o dispoitivo de bloco:

```bash
sudo umount /dev/loop9
```

2. Desanexar os arquivos referentes a essa dispotivo de bloco:

```bash
sudo losetup -d /dev/loop9
```

3. Remova o *loop device*:

```bash
sudo rm /dev/loop9
```

### Comando *basename*

Listar somente o nome do arquivo passando o *path* completo:

```bash
basename /path/to/file.any
```

Listar com múltiplos *paths*:

```bash
basename -a /first/path/to/file.any /second/path/to/file.any
```

OBS: com a opção `-a` do comando é possível usa-lo com `xargs` *command*.

Cortar a extensão do arquivo na hora de printar:

```bash
basename -s .any /path/to/file.any
# file
```

### Comando *dirname*

Imprime somente o caminho caminho absoluto de um path completo passado:

```bash
dirname /path/to/file.any
# /path/to
```

### Comando *id*

Lista o *id* o grupo dono e os grupos participantes do usuário corrente:

```bash
id
```

Retorna somente o *id* do usuário corrente:

```bash
id -u
```

Retorna somente o grupo dono do usuário corrente:

```bash
id -g
```

Retorna o nome do usuário com determinado *id*:

```bash
id -nu 1000
```

### Comando *rsync*

Sintaxe:

```bash
rsync [<options>] </folder/origin_1> </folder/origin_2/> </file/origin_3> <destiny>
```

- -r: modo recursivo.
- -v: modo verboso.
- -h: aumenta a legibilidade.
- -a: aplica recursividade, preserva permissões, usuários, grupos e timestamp (*inode*).
- -z: comprime os dados trafegados deixando o tamanho do *payload* menor porém consumindo mais processamento.
- -e 'ssh -p <port>': mudar a porta padrão (22) de conexão.
- --exclude=<pattern>: exclui arquivos ou diretórios pelo padrão passado aceitando *glob* ou de forma absoluta (*regex*?).
- --delete: caso algum arquivo da fonte não exista mais no destino, no destino também é excluído.

Exemplo:

```bash
rsync -ahv --delete --exclude=initial-folder/ --exclude=*.mp4 ~/others ~/misc /tmp/backup/
```

_OBSERVATIONS_:

- o destino ou origem aceita o modo de login de protocolo ssh (`user@host:/path`).

- caso a pasta de destino não exista o *rsync* criará automáticamente.

- opção `--exclude` é única para cada arquivo que deseja não sincronizar?

- no *rsync* `/path/to/folder` representa o próprio arquivo, ou seja, na hora de fazer a cópia, copiará a pasta *folder* com os arquivos dentro, porém, se copiar `/path/to/folder/` não está pegando o *basename* mas somente os arquivos dentro de *folder*.

- por *default* caso utilize o *rsync* com os mesmos *paths* de origem e destino ele simplesmente faz a sincronia dos arquivos (copia somente oque foi alterado, ou seja, o que há de novo) e preserva do destino os que já foram excluídos da fonte (ver opção `--delete`).

### Comando *lsof*

Listar portas abertas:

```bash
sudo lsof -nPi | grep -F LISTEN
```

Listar porta específica:

```bash
sudo lsof -i :<port>
```

### Comando _firejail_

Instalação:

```bash
sudo apt install -y firejail
```

Executa o _shell_ padrão em _sandbox_:

```bash
firejail
```

Executar a aplicação em _sandbox_:

```bash
firejail <program_name>
```

Lista os processos executando com `firejail`:

```bash
firejail --list
```

Executar o programa o impedindo de se conectar com a internet (o aplicativo não vê a interface de rede):

```bash
firejail --protocol=unix <program_name>
```

Executa o firejail criando uma nova e vazia pasta pessoal para o _root_ e para o usuário regular:

```bash
firejail [--name=<sandbox>] --private
```

Listagem de diretórios dentro da caixa de areia:

```bash
firejail --ls=<sandbox> ~/some/path/[file.any]
```

Copiar arquivo de dentro da caixa de areia:

```bash
firejail --get=<sandbox> ~/some/path/[file.any]
```

#### Troubleshooting

Problemas com áudio usando `pulseauido` como driver:

1. `mkdir -pv ~/.config/pulse`
1. `cp -v /etc/pulse/client.conf ~/.config/pulse`
1. `echo 'enable-shm = no' >> ~/.config/pulse/client.conf`

_pipeline_:

```bash
mkdir -pv ~/.config/pulse && cp -v /etc/pulse/client.conf ~/.config/pulse && echo 'enable-shm = no' >> ~/.config/pulse/client.conf
```

_OBSERVATIONS_:

- o `firejail` isola a aplicação da sua home porém, não do restante do sistema de arquivos (pois em tese não se precisa pois já pertence ao **root**);
- por padrão, caso o _firejail_ não tenha um perfil específico para a aplicação que executará, ele usurá um perfil genérico (pode haver problemas);

_REFERENCELINKS_:

- <https://easylinuxtipsproject.blogspot.com/p/sandbox.html>;

### Comando _kill_

Mata o processo pelo _id_:

```bash
kill -KILL <process_id>
```

Mata todos os processos com tal nome:

```bash
killall -KILL <process_name>
```

Verificar algum processo (signal 0 apenas verifica se o processo está vivo ou não):

```bash
kill -0 <process_id>
```

### Comando _nslookup_

Resolver _hostnames_/domínios:

```bash
nslookup <hostname/doamin>
```

### Comando _arp-scan_

Instalação:

```bash
sudo apt install -y arp-scan
```

Descobrir os _ip's_ conectados na rede local:

```bash
sudo arp-scan --localnet
```

### Comando _dig_

Instalação:

```bash
sudo apt install -y dnsutils
```

Resolver algum domínio especificando o servidor remoto:

```bash
dig [+short] @<ip_dns_server> <domain_to_search> <record_type>
```

OBS: o comando **dig** aceita os tipos de registro `A`, `MX` e `SOA`.

_REFERENCELINKS_:

- [Content Base](https://www.certificacaolinux.com.br/comando-linux-dig/);
- [Reconds Types](https://www.cloudflare.com/pt-br/learning/dns/dns-records/).

### Comando _ip_

Verificar as interfaces de redes com saida formatada e _highlightada_:

```bash
ip -br -c a
```

Verificar qual interface de rede está se comunicando com a _internet_:

```bash
ip route
```

OBS: caso esteja conectado a _internet_ em mais de uma interface de rede ao mesmo tempo, pode ser que tenha mais de uma definida como `default`, nesse caso, o que mede qual está se comunicando de fato é a que tem a métrica (`metric`) de menor valor.

### Comando _readlink_

Retorna o caminho original de um link simbólico (_soft link_):

```bash
readlink -f </path/to/softlink>
```

### Comando _efibootmgr_

- -v: aplica verbosidade.

Instalação:

```bash
apt install efibootmgr
```

Listagem das entradas de boot:

```bash
efibootmgr [-v]
```

Remover entrada de boot:

```bash
efibootmgr -b <boot_id> -B
```

Adicionar nova entrada de boot:

```bash
efibootmgr -c -d /dev/sdX -p Y -l '\path\to\<some>x64.efi' -L 'New Boot Entry'
```

### Comando _less_

Fazer com que a busca seja **case insensitive** (estando no estado de comando do less (com o _prompt_ "`:`")):
- Para buscas simples: `-i`;
- Para buscas também com padrões: `-I`.

### Comando _read_

- `-r`: traz o texto _raw_ (não interpreta caracteres de escape, "\n" por exemplo);
- `-e`: Na prática, não interpreta por exemplo teclas de movimentação, ou seja, consegue andar pelo texto com as setas (e consequentemente esses caracteres não são capturas pelo **read**);
- `-t`: _Seta_ um _timeout_ para cancelamento do comando;
- `-a`: A entrada será um _array_, ou seja, a cada espaço, um novo índice;
- `-p`: Imprime uma mensagem antes do cursor;
- `-i`: Caso utilizando ReadLine (opção `-e`, coloca uma mensagem padrão na caixa de _input_).

```bash
read -re -t 3 -a ARRAY -p 'Your name: ' -i 'Linus Torvalds'
```

_OBSERVATIONS_:

- Caso você precise printar algum caracter de escape ou algum tipo de formatação do texto para pedir a entrada do usuário e queira fazer com `echo -ne "\nInput: "; read -e foo`. Isso pode não soar como o esperado pois o texto printado (na mesma linha) antes da execução do `read` será literalemente apagado caso você use o `backspace` até o final. Para contornar isso, é necessário a presença da opção `-p` do `read`, nem que seja para simplesmente printar o ": " final: `echo -ne "\nInput"; read -e -p ': ' foo`.

### Comando _ffmpeg_

Aumentar a velocidade de um vídeo:

```bash
ffmpeg -i /path/to/video.any -filter:v "setpts=<value>*PTS" -an /path/to/output.any
```

OBS: "_<value>_" pode variar de 0 até 1, sendo que 1 é a velocidade normal, logo, 0.75 é 25% mais rápido, 0.5 é 50% e assim sucessivamente.

_REFERENCELINKS_:

- [Blog do Viva o Linux](https://www.vivaolinux.com.br/dica/Como-aumentar-ou-reduzir-a-velocidade-de-um-video-via-linha-de-comando).

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

### Saber meu *ip externo*

Com *curl* na *ipecho*:

```bash
curl -L http://ipecho.net/plain
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

Buscar for arquivos e excluílos:

```bash
find ~/ -not \( -path '*/.*' -prune -o -path '*/folder' -prune \) -iname '*confli*' -exec rm -i '{}' \; 2>&-
```

Excluir vários paths da busca e limitar a recursivedade:

```bash
find ./ -maxdepth 2 \( -path ./first/path -o -path ./second/path \) -prune -o -name '*file*'
```

Buscar por links simbólicos quebrados e excluílos:

```bash
find ./ -xtype l -exec rm -fv '{}' \;
```

_OBSERVATIONS_:

- pastas para o parâmetro `-path` não pode contem `/` no final;
- para qualquer tipo de _match pattern_ (inclusive para diretórios) é aceito _wildcards_, exemplo: `find ./ \( -path '*/folder' -o -path '*/.folder' \) -prune -o -name '*f?le*'`;

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

#### Comando _tar_

- `-z`: para manipulação de arquivos `.gz`;
- `-c`: para criar arquivos compactados;
- `-v`: modo verboso (printa na tela o processamento);
- `-f`: informa qual é o arquivo para para aquela operação;
- `-x`: para fazer extração de arquivos `.tar`;
- `-C`: para descompactar em outra pasta;
- `-t`: para fazer listagem de arquivos comprimidos;

##### _.tar.gz_

Compactar em `.tar.gz`:

```bash
tar -zcvf target_folder.tar.gz /file/to/compressed.any /folder/to/compressed/
```

Descompactar de `.tar.gz`:

```bash
tar [-C /folder/to/decompress/] -zxvf compressed_folder.tar.gz
```

##### _.tar.xz_

Compactar em `.(tar|tbz2).(xz|bz2)`:

```bash
tar -cvf target_folder.tar.gz /file/to/compressed.any /folder/to/compressed/
```

Descompactar de `.(tar|tbz2).(xz|bz2)`:

```bash
tar [-C /folder/to/decompress/] -xvf compressed_folder.tar.xz
```

##### _.tar.\*_

Ver conteúdo de `.tar.*`:

```bash
tar -tf compressed_folder.tar.gz
```

#### Comando _zip/unzip_

- `-d`: especifica a pasta para ser descompactado;
- `-l`: listar o conteúdo do arquivo compactado;
- `-r`: faz ser recursivo a compressão (caso não passe o glob `*` na pasta especificada);

Compactar:

```bash
zip [-r] target_folder.zip /file/to/compressed.any /folder/to/compressed/*
```

Descompactar:

```bash
unzip [-d /path/to/decompress/] compressed_folder.zip
```

Ver o conteúdo:

```bash
unzip -l compressed_folder.zip
```

#### Comando _xz_

- `-z`: para criar arquivos compactados;
- `-d`: para descompactar arquivos;
- `-v`: modo verboso (printa na tela o processamento);

Compactar:

```bash
xz -vz /file/to/be/compressed
```

Descompactar:

```bash
xz -vd compressed_file.xz
```

#### Comando _7z_

- `x`: para descompactar arquivos;

Descompactar:

```bash
7z x compressed_file.any
```

#### Comando _gzip_

- `-d`: para descompactar arquivo;
- `-k`: descompacta o arquivo e ainda mantem um cópia do compactado;

Compactar:

```bash
gzip /file/to/compact.any
```

Descompactar:

```bash
gzip -d [-k] /gzip/file/to/decompress.gz
```

OBS: `gzip` igualmente os _xz_, "auto compacta" o arquivo.

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

### Qemu

- X: Letra do disco;
- -m: Memória RAM em MB;
- -smp: Núcles do processador;
- -nographic: Executar em _background_.

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

#### Conectar Via SSH (configurar _network_ entre _host_ e _guest_):

```bash
qemu-system-x86_64 -enable-kvm -m 2048 -smp 2 -hda {virtual_disk.qcow2|/dev/sdX} -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::2222-:22
```

#### Clonagem de Disco Virtual

```bash
qemu-img convert -pO qcow2 /path/to/base-disk.qcow2 /path/to/output-disk.qcow2
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
	`sudo nmap -sA 192.168.0.1/24`

Saber quais portas estão sendo usadas por qual serviço na sua máquina:

```bash
sudo nmap -sV localhost
```

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

### Shell

Saber shell atual:

```bash
ps -o comm= $$
```

### Prioridade no Tempo de CPU para Comandos e Processos

Toda a prioridade de tempo de _CPU_ é feito com base em "_nice_" (legal)... quanto mais "_legal_" um processo é, mais ele disponibiliza tempo de _CPU_ para outros processos.

Os valores de _nice_ vareiam de:

- `-20` (processo com **MAIOR prioridade**);

até

- `+19` (processo com **MENOR prioridade**).

#### Comando _nice_

Comando _nice_ especifica o valor de _nice_ de um processo no seu lançamento.

Sem valor de _nice_ especificado, por padrão é atribuido `+10`:

```bash
nice apt update &
```

Especifique o valor de _nice_ com a flag `-n`:

```bash
nice -n -15 yes | docker system prune
```

#### Comando _renice_

Comando _renace_ altera o valor de _nice_ de um processo já em execução.

Alterar o valor _nice_ de um processo

```bash
renice +5 30018
```

Passar esse mesmo valor _nice_ para outros _PID's_ usuários, e grupos:

```bash
renice +19 30019 -p 30020 -u user -g group
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
shred [-v|-z|-u|-n <number_of_times>] ./file.txt
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

### Verificação do HASH de Arquivos

#### Comando _sha256sum_

Pegar o _hash_ de algum arquivo:

```bash
sha256sum /path/to/file.any
```

#### Comando _md5sum_

Pegar o _hash_ de algum arquivo:

```bash
md5sum /path/to/file.any
```

### Conversão de Arquivos

#### Utilitários do ImageMagick

Instalação:

```bash
apt install imagemagick
```

_OBERSAVTIONS_:

- Se erro de não permissão devido a policita para pdf's:

```bash
sed -Ei 's,(<policy domain="coder" rights=").*(" pattern="PDF" />),\1read|write\2,' /etc/ImageMagick-?/policy.xml
```

- As converções funcionaram entre tipos de imagem, _jpg to png_, _png to jpg_ e também _pdf to image_.

##### Comando _convert_

IMAGE to PDF:

```bash
# one to one
convert /path/to/image.any /path/to/out.pdf

# many to one
convert /path/to/folder/*.any /path/to/single-out.pdf

# multiples, one to one
for file in /path/to/folder/*.any; do convert "$file" "${file%.*}.pdf"; done
```
##### Comando _mogrify_

IMAGE to PDF:

```bash
# one to one
mogrify -format pdf /path/to/image.any

# multiples, one to one
mogrify -format pdf /path/to/folder/*.any
```

#### Comando _pdftoppm_

Instalação:

```bash
apt install poppler-utils
```

PDF to IMAGE:

```bash
# one to one
pdftoppm -png /path/to/file.pdf /path/to/file.pdf

# multiples, one to one
find /folder/to/search -maxdepth 1 -type f -name -name '*.pdf' -exec pdftoppm -png '{}' '{}' \;
```

# Como Matar Um ou Muitos "Programas"

Use case:

> Qual o comando CLI para matar um processo? Eu abri varias abas no edge, e o PC meio q travou. Oque fazer nesse cenario?

## kill e killall

Você terá duas formas de fazer isso, pelo **_PID_** do processo ou pelo seu **nome**. Em ambos os casos você teria que saber mais ou menos o nome do comando que executou esse programa.

### kill

Se for pelo **_PID_**, você pode executar:

```sh
kill -9 <PID>
```

`<PID>` será trocado pelo _PID_ do processo e o parâmetro `-9` fará o processo ser morto de forma forçada.

### killall

Se for pelo _nome_, você pode executar:

```sh
killall <name>
```

`<name>` será trocado pelo nome do processo.

OBS: O `killall` irá matar todos os processos daquele comando.

---

Bom, depois de saber como matar um processo pelo seu **_PID_** ou matar todos os processos de um comando pelo seu **nome**, deve estar surgindo uma dúvida na sua cabeça: Beleza, mas como eu vou saber o nome do programa que eu quero fechar ou se quer saber o seu **_PID_**?

Existem várias maneiras mas aqui vai algumas...

1. Suposição: É a forma mais rápida e simples. Se o programa que quer fechar é o **Edge**, tem uma grande chance do nome do seu binário ser "edge" mesmo (ou algo muito parecido).

1. Usando o "Tab": Junto com a dica número 1 você pode usar o recurso do Tab que autocompleta o comando para você. No caso se quiser testar se existe algum comando no sistema que se chame "edge" ou parecido, você pode digitar "edg" e apertar Tab para ver se o seu _shell_ irá completar algo para você. Se tiver várias opções e no meio delas existir algo como "edge-browser", não restará dúvidas que esse é o nome do programa que quer matar.

1. Comando `pgrep`: Eses é o utulitário do sistema para listagem dos processos (no qual você pode passar somente parte do nome para a busca). Seguindo o exemplo do **Edge**, podiramos executar `pgrep -l edge` e todos os comandos com esse nome serão listados junto os _PID's_ e dessa forma você saberá o nome completo do comando que está buscando (caso já não seja "edge" mesmo).

---

<a id="db_gnulinux-bash"></a>
[<span style="font-size:14px;">GNU/Linux && Bash</span>](#menu)

### Variáveis de ambiente (escopo global)

Mostrar variáveis de ambiente (do usuario corrente):

```bash
env
```

Criar variável de ambiente (escopo global):

```bash
export FOO="BAR"
```

### Proteção de variáveis com aspas

Protejer ou não variáveis na hora da sua utilização:

```bash
function() {

	# does not work as expected
	argument=$1
	cd $argument

	# does not work as expected
	argument="$1"
	cd $argument

	# work as expected
	argument=$1
	cd "$argument"

	# work as expected
	argument="$1"
	cd "$argument"

}

function '/any/pathway/to/folder/with/compound name'
```

OBS: quando por exemplo em scripts ou em função, alguma variável recebe algum argumento por parâmetro, se esse argumento for "composto" (uma _string_ que contenha espaços), apesar de que obviamente você precisa protejer esse argumento ou espacar o espaço em branco, do lado de dentro, a variável não precisa receber esse parâmetro protegendo ele, mas em qualquer momento posterior que essa variável expandir (na hora de sua utilização), terá sim que protejela.

### Caracteres de Escape para Cores


```bash
echo $'\033[00;31m <string> \033[00m'
echo $'\e[31m <string> \e[m'
```

### Expansão de variáveis (parâmetros)

#### `#`, `##`, `%`, `%%`

```bash
$ variable=https://sub.domain.xyz/downloads/archive.tar.gz

$ echo ${variable#*/}
> /sub.domain.xyz/downloads/archive.tar.gz

$ echo ${variable##*/}
> archive.tar.gz

$ echo ${variable%/*}
> https://sub.domain.xyz/downloads

$ echo ${variable%%/*}
> https:
```

### Bash Glob's estendidos.

| Glob         | Descrição                                               |
| ------------ | ------------------------------------------------------- |
| `?(pattern)` | Corresponde a uma ocorrência do padrão.                 |
| `*(pattern)` | Corresponde a qualquer número de ocorrências do padrão. |
| `+(pattern)` | Corresponde a pelo menos uma ocorrência do padrão.      |
| `@(pattern)` | Corresponde exatamente a uma ocorrência do padrão.      |
| `!(pattern)` | Corresponde a tudo, exceto o padrão.                    |

### Zsh Glob's estendidos.

| Glob          | Descrição                        |
| ------------- | -------------------------------- |
| `^foobar`     | Nega o padrão.                   |
| `^(foo\|bar)` | Nega os padrões.                 |
| `foo~bar`     | Aceita "foo" e nega "bar".       |
| `(foo)#`      | Zero ou mais ocorrências de foo. |
| `(foo)##`     | Uma ou mais ocorrências de foo.  |

### Classes Unix

| Classes    | Descrição                                                             |
| ---------- | --------------------------------------------------------------------- |
| [:alnum:]  | Alfabéticos e númericos `[a-z A-Z 0-9]`.                              |
| [:alpha:]  | Alfabéticos `[a-z A-Z]`.                                              |
| [:blank:]  | Caractere em branco, espaço ou tab `[\t]`.                            |
| [:cntrl:]  | Caracteres de controle `[\x00-\x1F-\x7F]`.                            |
| [:digit:]  | Números `[0-9]`.                                                      |
| [:graph:]  | Qualquer caractere visível (ou seja, exceto em branco) `[\x20-\x7E].` |
| [:lower:]  | Letras minúsculas `[a-z]`.                                            |
| [:upper:]  | Letras maiúsculas `[A-Z]`.                                            |
| [:print:]  | Caracteres visíveis (ou seja, exceto os de controle) `[\x20-\x7E]`.   |
| [:punct:]  | Pontuação `[-!"#$%&'()*+,./:;?@[\\\]_{\|}~]`.                         |
| [:space:]  | Espaço em branco `[\t\r\n\v\f]`.                                      |
| [:xdigit:] | Número hexadecimais `[0-9 a-f A-F]`.                                  |

| Classes   | Abreviação |
| --------- | ---------- |
| [:digit:] | \d.        |
| [:alnum:] | \w.        |
| [:space:] | \s.        |

### Expansão de Variáveis

| Expansão          | Descrição                                                   |
| ----------------- | ----------------------------------------------------------- |
| `${var[@]}`       | Imprime todos os elementos do array em strings protegidas.  |
| `${var[*]}`       | Imprime todos os elementos do array em uma única expressão. |
| `${var[P]}`       | Imprime o elemento na posição ‘P’.                          |
| `${#var[@]}`      | Imprime o total de elementos do array.                      |
| `${!var[@]}`      | Imprime os índices do array.                                |
| `${var[@]:N}`     | Imprime todos os elementos a partir da posição ‘N’.         |
| `${var[@]:N:M}`   | Imprime ‘M’ elementos a partir da posição ‘N’.              |
| `${var[@]: -N}`   | Imprime os últimos ‘N’ elementos.                           |
| `${var[@]: -N:M}` | Imprime ‘M’ elementos a partir da última ‘N’ posição.       |

### Sinais de Processos

| POSIX Signals  | Descrição                                                                                                                                     |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| '01' (SIGHUP)  | Terminal do processo foi desconectado ou o processo encerrado (alguns deamons usam esse sinal para recarregar as configurações do processo).  |
| '02' (SIGINT)  | Interrompe o processo e aguarda o próximo comando do usuário,lançado no ctrl+c.                                                               |
| '03' (SIGQUIT) | Força o core dumped do processo e o termina, lançado no ctrl+\.                                                                               |
| '05' (SIGTRAP) | Enviado esse sinal para o processo quando ocorre uma exceção ou quando cai numa trap.                                                         |
| '09' (SIGKILL) | Quando enviado ao processo causa seu encerramente imediato, diferentemente do SIGTERM e SIGINT esse sinal não pode ser capturado ou ignorado. |
| '15' (SIGTERM) | Quando enviado ao processo causa seu encerramento, porém, pode ser capturado ou ignorado pelo processo.                                       |
| '18' (SIGCONT) | Enviado esse sinal para que o processo "reinicie", volte ao estado de running depois de SIGSTOP ou SIGTSTP.                                   |
| '19' (SIGSTOP) | Quando enviado, o processo é pausado pelo sistema para ser resumido futuramente e pode apenas receber os sinais SIGKILL e SIGCONT.            |
| '20' (SIGTSTP) | Sua diferença para o SIGSTOP é que quando pausado o processo ainda pode manipulado, lançado no ctrl+z.                                        |

| Processes States             | Descrição                                                                                                                        |
| ---------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| 'D' (UNINTERRUPTABLE\_SLEEP) | Processo dorme e aguarda alguma entrada, nesse estado se interrompido pode causar problemas.                                     |
| 'R' (RUNNING & RUNNABLE)     | Processo está compra para ser executado ou já está em execução.                                                                  |
| 'S' (INTERRRUPTABLE\_SLEEP)  | Processo dorme e aguarda alguma entrada, nesse estado "pode ser" interrompido com segurança.                                     |
| 'T' (STOPPED)                | Processo está pausado porém ainda pode ser manipulado ou resumido (ctrl+z » SIGTSTP).                                            |
| 'Z' (ZOMBIE)                 | Processo que foi encerrado porém ainda está na tabela de processos, significa que ainda pode estar finalizando alguma atividade. |

### Ordem de Chamada dos Arquivos de Inicialização

#### Usando Console de Texto

1. `/etc/environment`:
    - OBS: independete (carregado pelo **PAM**).

1. `/etc/profile`:
    - OBS: independete (carregador pelo **Bash**).

1. `~/.bash_profile`:
    - OBS: caso esse exista, os próximos não são carregados a menos que no mesmo seja feito o carregamento explícito.

1. `~/.bash_login`:
    - OBS: mesmo caso do anterior.

1. `~/.profile`:
    - OBS: mesmo caso do anterior.

#### Usando GUI

1. `/etc/environment`;
    - OBS: independente (carregado pelo **PAM**).

1. `~/.xsessionrc`.
    - OBS: independente (carregador pelo servidor gráfico (**X**));
    - OBS: pode conter a chamada dos _shell's startup files_.

_REFERENCELINKS_:

- [Environment Variables (from Debian wiki)](https://wiki.debian.org/EnvironmentVariables).

### HEREDOC

Normal:

```bash
cat << EOF
	$SHELL
EOF
```

Modo _raw_ (sem escapes ou expanções):

```bash
cat << \EOF
	$SHELL
EOF
```

_In line_:

```bash
eval $'cat << eof\nhello\neof'
eval $'read foo << eof\nhello\neof'
```

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

#### Mescar Monitores

Liste os monitores disponíveis:

```bash
xrandr --listactivemonitors
# ou utilize a pipeline:
# xrandr --listactivemonitors | sed -nE 's/.*  (.*)$/\1/p' | tr '\n' ',' | sed 's/,$//'
```

Execute o comando:

```bash
xrandr --setmonitor MERGE-1 auto VGA-1,HDMI-1
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

### Volume e Saida de Som do Sistema

#### Comando _amixer_

**Sintaxe de como alterar o volume**:

```bash
amixer set <controller> <percentage_with_signal>
```

Aumentar o volume:

```bash
amixer set {Master|Speaker} 5%+
```

Diminuir o volume:

```bash
amixer set {Master|Speaker} 5%-
```

**Sintaxe de como mutar/desmutar**:

```bash
amixer set <controller> <commnad>
```

Mutar:

```bash
amixer set {Master|Speaker} mute
```

Desmutar:

```bash
amixer set {Master|Speaker} unmute
```

Alternar:

```bash
amixer set {Master|Speaker} toggle
```

#### Mudar saida de som

Listar saidas de som disponíveis:

```bash
pacmd list-cards | grep -F output:
```

Setar novo dispositivo de saida:

```bash
pactl set-card-profile 0 <card_profile>
```

OBS: o perfil do cartão do dispositivo de saida tem a sintaxe `output:<profile_name>[:<profile_variant>]` e.g. `output:analog-stereo+input:analog-stereo` ou somente `output:analog-stereo`.

_REFERENCELINKS_:

- <https://askubuntu.com/questions/539768/how-can-i-change-audio-output-to-hdmi-from-command-line>;

### Mudar a "furtividade" de senhas

1. Edite o arquivo de alterações do sudoers:
	`sudo visudo -f /etc/sudoers.d/users`

1. Insira o conteúdo:
	`Defaults pwfeedback`

### Desabilitar suspenção na *blank screen*

```bash
gsettings set org.gnome.desktop.screensaver lock-enabled {true|false}
```

### Aceitar EULA automáticamente

```bash
echo 'ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select {true|false}' | sudo debconf-set-selections
```

### GRUB

#### Menu

Definir que o menu apareça no *boot*:

1. Edite o arquivo `/etc/default/grub`.
1. Na linha `GRUB_TIMEOUT_STYLE`:
	`GRUB_TIMEOUT_STYLE=false`

Defina o *timeout* do menu:

1. Edite o arquivo `/etc/default/grub`.
1. Na linha `GRUB_TIMEOUT`:
	`GRUB_TIMEOUT=30`

Defina a image de *backgrond* do menu:

1. Edite o arquivo `/etc/default/grub`.
1. Caso não exista a variável `GRUB_MENU_PICTURE` declare com `export`:
	`export GRUB_MENU_PICTURE="/path/to/wallpaper.{jpg,png}"`

ou

1. Copie a imagem de *wallpaper* para dentro de `/boot/grub/`.

OBS:

- para todas as operações que envolvam o *grub* atualize ele com `sudo update-grub`.

- as imagens que *grub* aceita para definir como *background* são imagens *jpg* ou *png* de 256 cores.

---

<a id="db_hardware"></a>
[<span style="font-size:14px;">Hardware</span>](#menu)

### Comando *lscpu*

- --extended: forma a saida do comando
	- core: mostra somente os cores
	- cpu: mostra somente as threads

Lita informação a respeito do processador:

```bash
lscpu [--extended=cpu,core]
```

### Comando *nproc*

Número de núcleos (threads) do processador:

```bash
nproc
```

### Comando *uname*

Versão do Kernel:

```bash
uname -r
```

Arquitetura do sistema:

```bash
uname -m
```

### Comando *lsb_release*

Infos geral da distro:

```bash
lsb_release -a
```

Somente o nome da distro:

```bash
lsb_release -cs
```

### Infos do sistema

#### Comandos

- `lshw -short`
- `hwinfo --short`
- `inxi -Fxz`

#### Scripts

- `neofetch`
- `screenfetch`

OBS: todos os comandos caso nao estejam, podem ser instalados com: `sudo apt install <command_name> -y`.

### Interface gráfica atual

```bash
echo $XDG_CURRENT_DESKTOP
```

### Fechar a tampa do notebook e não suspender

1. Editar o arquivo de configuração:
	- `sudo vim /etc/systemd/logind.conf`

2. Descomente e deixe o valor das seguintes variáveis iguais:
	- `HandleLidSwitch=ignore`
	- `HandleLidSwitchExternalPower=ignore`
	- `HandleLidSwitchDocked=ignore`

3. Restarte o serviço responsável:
	- `sudo systemctl restart systemd-logind.service`

### Placa de vídeo

Comando *lshw*:

```bash
lshw -c video | grep -iF product
```

Comando *lspci*:

```bash
lspci -k | grep -E '(VGA|3D|Display)'
```

### Mover/Cortar/Diminuir partições

- Extender partição com o espaço disponível: `sudo growpart /dev/sdXY`.

- Mover partição de lugar (para trás ou para frente): `echo '<operator><size><multiplier>,' | sudo sfdisk --mode-data /dev/sdX -N <partition_number>`.

- Aumentar/Diminuir tamanho da partição: `echo ',<operator><size><multiplier>' | sudo sfdisk /dev/sdX -N <partition_number>`.

- Aplicar alterações de *resize*: `sudo resize2fs /dev/sdXY`.

### _Natural Scrolling_?

```bash
synclient VertScrollDelta=-79
synclient HorizScrollDelta=-79
```

---

<a id="db_tutoriais"></a>
[<span style="font-size:14px;">Tutoriais</span>](#menu)

### Como inserir icones no "menu de aplicativos"

1. Crie um arquivo .desktop em `/usr/share/applications/`:

```bash
sudo touch /usr/share/applications/file_name.desktop
```

OBS: pode ser criado para o usuário no seu `~/.local/`:
	`touch ~/.local/share/applications/file_name.desktop`

2. Edite o arquivo criado inserindo as seguintes linhas:

```
[Desktop Entry]
Type=Application
Name=App Name
Icon=appname
Exec=/path/to/application/binary
```

OBS: o ícone deve ser guardado no diretório `/usr/share/pixmaps/<appname>.{png|xpm}`, para que possamos pssar simplesmente o nome do ícone sem a extensão no atributo `Icon` do *dot file* (caso necessário, também pode-se passar o caminho absoluto).

#### Criar link simbólico na área de trabalho

1. Crie um arquivo no seu `~/Desktop/`:

```bash
touch ~/Desktop/file_name.desktop
```

2. Edite o arquivo criado inserindo as seguintes linhas:

```
[Desktop Entry]
Type=Link
Name=App Name
Icon=appname
URL=/usr/share/applications/file_name.desktop
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
sudo do-release-upgrade [--allow-third-party] -d
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

Programas necessários:

```bash
sudo apt install ecryptfs-utils -y
```

1. Crie a pasta privada que guardara os arquivos:

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

### Programas Autostart (da sessão do usuário)

Caso a pasta ainda não exista, basta cria-la:

```bash
mkdir ~/.config/autostart/
```

#### Programas com interface e para programas para rodar me _background_

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

#### Programas que rodam via linha de comando que precisam do terminal ativo

1. Crie um arquivo ".desktop" dentro da pasta `~/.config/autostart/`

- Para `gnome-terminal`:

```
[Desktop Entry]
Type=Application
Name=scriptmain
Exec=gnome-terminal -- sh -c 'sleep 5; script; sh'
Hidden=false
NoDisplay=false
```

- Para `terminator`:

```
[Desktop Entry]
Type=Application
Name=scriptmain
Exec=terminator --command='sleep 5; script; sh'
Hidden=false
NoDisplay=false
```

### Criar serviços (*systemd units*) que inicia junto com a sessão

Path:

```
/etc/systemd/system/<service_name>.service
```

Sintaxe básica de um *dot file* `.service`:

```
[Unit]
Description=<unit_description>

[Service]
WorkingDirectory=</folder/script/run/ove/r>
ExecStart=</path/to/interpreter> </path/to/script.any>
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
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

1. `monta /dev/sda2 (root) /mnt/`
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
sudo ./Ventoy2Disk.sh -i -s /dev/sdX
```

Opções:

```
Usage:  Ventoy2Disk.sh CMD [ OPTION ] /dev/sdX
  CMD:
   -i  install Ventoy to sdX (fails if disk already installed with Ventoy)
   -I  force install Ventoy to sdX (no matter if installed or not)
   -u  update Ventoy in sdX
   -l  list Ventoy information in sdX

  OPTION: (optional)
   -r SIZE_MB  preserve some space at the bottom of the disk (only for install)
   -s/-S       enable/disable secure boot support (default is enabled)
   -g          use GPT partition style, default is MBR (only for install)
   -L          Label of the 1st exfat partition (default is Ventoy)
   -n          try non-destructive installation (only for install)
```

Pc com secure boot (precisa fazer o procedimento somente a primeira vez):

```
OK -> "any key" -> Enroll Key From Disk -> VTOYEFI -> ENROLL_THIS_KEY_IN_MOKMANAGER.cer-> Cotinue -> Yes -> Reboot
```

OBS:

- O binário do ventoy tem que rodar estando na pasta com seus arquivos.
- Link para a [página de download](https://www.ventoy.net/en/download.html).

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

### Configurar touchpad (*X11 config file*)

1. crie a pasta do X11 que pega as confs:

```bash
sudo mkdir -p /etc/X11/xorg.conf.d
```

2. crie o arquivo de config do tochpad?

```bash
sudo touch /etc/X11/xorg.conf.d/90-touchpad.conf
```

3. coloque as informações dentro do arquivo:

```bash
Section "InputClass"
	Identifier "touchpad"
	Driver "libinput"
	Option "Tapping" "true"
	Option "NaturalScrolling" "true"
	Option "ScrollMethod" "twofinger"
EndSection
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

![instalation-new-update-alternatives](/.assets/images/instalation-new-update-alternatives.png)

Link de exemplos de instalação e utilização com [cursores](#cursor) e somente de utilização para [editor de texto padrão](#editor-de-texto-padrão) e [terminal padrão](#terminal-padrão).

### Empacotamento *debian* (criar .deb)

1. Criar a seguinte hierarquia de diretórios:

```bash
mkdir -p /path/to/your/projects/hello_0_0_amd64/{DEBIAN,usr/bin}/
```

2. Criar os arquivos de controle e os scripts de instalação.

```bash
touch /path/to/your/projects/hello_0_0_amd64/DEBIAN/{control,preinst}
```

2.1. coloque as informações a respeito do pacote no arquivo *control*:

```bash
Package: hello
Version: 0.0
Architecture: all
Essential: no
Priority: optional
Maintainer: rhuan-pk
Description: Just a "hello".
```

2.2. coloque o script de pŕe instalação no arquivo *preinst*:

```bash
#!/bin/bash
[ -f /usr/bin/hello ] && sudo rm -fv /usr/bin/hello
```

2.3. Dê permissão de execução para os scripts.

3. Compile o binário e coloque em `/path/to/your/projects/hello_0_0_amd64/usr/bin/`.

4. *Builde* o pacote:

```bash
dpkg-deb --build ./hello_0_0_amd64/
```

### _Downgrade_ (broke/bug packages) de Pacotes

1. Instale o **gdb** para ajudar a identificar o pacote defeituoso:
    `apt install gdb`

1. Execute o **gdb** com o comando que gerá o erro:
```bash
$ gdb <program>
(gdb) r <args>
```

3. Descubra de qual pacote é determinado arquivo que dá o erro:
    `dpkg -S /path/to/file/error`

1. Inclua o repositório anterior no qual o pacote existia sem o _bug_ no `/etc/apt/sources.list`:
    `deb https://deb.debian.org/debian testing main`

1. Atualize a lista de repositórios:
    `apt update`

1. Veja agora as versões antigas do programa:
    `apt policy <program>`

1. Instale a versão antiga:
    `apt install <program>/testing`

1. Marque o programa para ser "segurado" e não ser atualizado junto com o próximo `upgrade` do sistema:
    `apt-mark hold <program>`

1. Depois que o programa estiver correto pode tira-lo da marcação _hold_:
    `apt-mark unhold <program>`

OBS: da para verificar se o _bug_ já foi reportado pesquisando pelo nome do programa (pego com `dpkg -S`) no _site_ <https://tracker.debian.org/> e caso de fato haja o _bug_ em aberto você pode se inscrever para receber seu _reports_ enviando qualquer mensagem para **\<code\>-subscribe@bugs.debian.org**.

_REFERENCELINKS_:

- <https://www.youtube.com/watch?v=x2JQaXfI-pI>;

### Tmux

Ele trabalha com sessões e dentro de cada sessão você pode ter várias janelas (*tabs*) e dentro dessas janelas ainda há a possiblidade de *split*.

Caracteríscas:

- Tecla modificadora: `^b` (`ctrl+b`)

Programas necessários:

```bash
sudo apt install tmux -y
```

Iniciar uma nova sessão:

```bash
tmux
```
#### Dentro da sessão

- Nova janela:
	`${mod}+c`

- Ir para próxima janela:
	`${mod}+n`

- Voltar para janela anterior:
	`${mod}+p`

- Ir para a janela por índice:
	`${mod}+<number>`

- *Split* horizontal:
	`${mod}+"`

- *Split* vertical:
	`${mod}+%`

- Mudar entre as *splits*:
	`${mod}+<arrows>`

- *Desatachar* a sessão (deixa a sessão em *background* e pode retornar posteriormente):
	`${mod}+d`

- Renomear a sessão:
	`${mod}+$`

- Renomear a janela:
	`${mod}+,`

- Alternar entre *full screen* da *slipt*:
	`${mod}+z`

- Menu interativo de sessões:
	`${mod}+s`

- Menu interativo de janelas (e sessões também caso tenha mais que uma):
	`${mod}+w`

- Mostra a hora:
	`${mod}+t`

#### Fora da sessão

- Listar todas as sessões:
	`tmux ls`

- *Atachar* a sessão (pegar a sessão novamente):
	`tmux attach -t <id_session>`

OBS: Caso duas pessoas compartilhem a mesma sessão tmux você terá um bash compartilhado.

- Criar e entrar na sessão já passando o nome:
	`tmux new-session -s <name_session>`

- Criar e **NÃO** entrar na sessão já passando o nome:
	`tmux new-session -s <name_session> -d`

- Matar sessão específica:
	`tmux kill-session -t <id_session>`

- Matar todas as sessões:
	`tmux kill-server`

- Aumentar o tamanho do _scrollback buffer_:
    `tmux set-option -g history-limit 999999\; new-session`

### Vim

- `ctrl+w v`: split vertical;
- `ctrl+w s`: split horizontal;
- `ctrl+w w`: navega entre as janelas;
- `:e /path/to/file.any`: abre o arquivo no caminho passado;
- `:term`: abre uma janela dedicada a ser um terminal;
- `:vertical :term`: abre uma janela dedicada a ser um terminal esplitado na vertical;
- `:! pwd`: executa um comando e volta para o vim;
- `:r! pwd`: executa um comando e seu retorno vai direto para o arquivo que está sendo editado;
- `ctrl+w e`: *scroll* de linha a linha para baixo;
- `ctrl+w y`: *scroll* de linha a linha para cima;
- `:reg`: faz a listagem do histórico de *deletes/yanks* (*"reg"* é a abreviação de *"register"*);
- `<register_name>p`: cola um registro específico do histórico;
- `%d`: limpa o arquivo (deleta todas as linhas);
- `<begin_number>,<end_number>d`: deleta o range de linhas informados;
- `dgg`: deleta da linha atual até o início do arquivo;
- `.,$d`: deleta da linha atual até o final do arquivo;
- `:g/<string>/d`: deleta todas as linhas que contenham a *string* passada;
- `:g!/<string>/d`: deleta todas as linhas que NÃO contenham a *string* passada;
- `g/^$/d`: deleta todas as linhas em branco :);
- `/<string>\c`: pesquisa com case insensitive;
- `/<string>\C`: pesquisa com case sensitive.

### Swapfile

Criar _swap_ como arquivo:

1. Caso tenha a swap on em algum arquivo ou dispositivo, desative-a:
	`sudo swapoff /swapfile`

1. Remova o antigos arquivo de swap (se for o caso):
	`sudo rm /swapfile`

1. Define o novo arquivo com o tamanho de _swap_ que queira ter:
	`sudo fallocate -l 4G /swapfile`

1. Altere as permissões do arquivo:
	`sudo chmod 600 /swapfile`

1. Formate o arquivo:
	`sudo mkswap /swapfile`

1. Ligue a swap a partir desse novo arquivo:
	`sudo swapon /swapfile`

Depois de feito a configuração, configure o **fstab** para reconhecer e ligar a _swap_ no próximo boot automáticamente.

Adicione a linha em `/etc/fstab`:

```bash
/swapfile none swap sw 0 0
```

OBS: o espaço entre os argumentos são meramente identáveis.

### Chroot

Para fazer o `chroot` correto (o sistema alvo será o sistema para qual fazremos o *chroot*):

1. Monte a raiz do sistema alvo:
	`sudo mount /dev/sdXY /mnt`

2. Monte todas as outras partições físicas do sistema alvo (menos a *ESP* e *SWAP* caso tenha) **em baixo** da partição *root* montada:

```bash
sudo mount /dev/sdXY /mnt/boot/
sudo mount /dev/sdXY /mnt/home/
```

3. Faça o *bind* dos diretórios que só são populados quando o sistema está em execução:

```bash
sudo mount --bind /dev/ /mnt/dev/
sudo mount --bind /proc/ /mnt/proc/
sudo mount --bind /sys/ /mnt/sys/
```

4. Copie o arquivo de resolução de interface de rede (caso precise de *internet*) para o sistema alvo (faça *backup* do original antes):

```bash
sudo cp -L /etc/resolv.conf /mnt/etc/
```

5. Finalize entrando no sistema alvo :):
```bash
sudo chroot /mnt/ /bin/bash
```

### GRUB

Possibilidades de correções do sistema pelo GRUB.

#### Shell (`c`)

Colocar paginação na saida:

```
grub> set pager=1
```

Listar os HD's e partições:

```
grub> ls
```

Listar o conteúdo dos HD's:

```
grub> ls (hd0,msdos5)/boot
```

Ver o conteúdo de arquivos:

```
grub> cat (hd0,msdos5)/etc/fstab
```

Setar kernel para boot:

1. Escolha um kernel disponível em `/boot` e seu ponto de montagem (pego no fstab (*device* ou *UUID*)):

```
grub> linux (hd0,msdos5)/boot/vmlinuz-5.10.0-10-amd64 root=/dev/sda1
```

2. Escolha o initrd disponível também em `/boot` (módulos compatíveis com o *kernel*):

```
grub> linux (hd0,msdos5)/boot/initrd-5.10.0-10-amd64
```

3. Por fim, de boot no sistema:

```
grub> boot
```

#### Editor (`e`)

Carregar o **bash** antes de subir o sistema:

1. No final da linha que inicia com `linux`:

	1. Apagar do `ro` para frente.
	2. Colocar no lugar: `rw init=/bin/bash`.

2. Pressione `F10` para bootar as alterações temporárias.

3. Depois que fizer o que precisa, inicie o sistema com `exec /sbin/init`.

### Kernel panic (recovery trying)

1. *Starte* o *host* em pânico para saber qual versão do *kernel* está sendo iniciada.

1. Caso consiga inicar o *host* com *recovery mode*, o faça, se não [chroot](#chroot) nele com *live USB*.

1. Reconstrua o *initramfs*: `sudo mkinitramfs -o /boot/initrd.img-<kernel_version> <kernel_version>`.

1. Atualize o *grub*: `sudo update-grub`.

1. Atualize o *initramfs*: `sudo update-initramfs -u`.

1. `reboot`.

### Instalações

#### Slax

Instalação padrão:

1. Crie uma partição para colocar o Slax, que seja fat32 e que seja tabela de partição de preferencia que seja MSDOS.
1. Copia todos os arquivos do Slax para a partição.
1. Rode o script de instalação do Slax dentro de /boot da pasta do Slax.

Fazendo instalação no pendrive (mesmo proscedimento?):

1. Crie tabela de partição MSDOS.
1. Crie uma partição do tamanho que quiser e formate em fat32 ou ext4.
1. Extraia a iso do Slax.
1. copie todo o conteúdo dela para dentro da partição.
1. Vá para a pasta aonde a partição foi montada.
1. Rode: `sudo bash ./slax/boot/bootinst.sh`.

#### FydeOS (ChromeOS)

Instalalção padrão:

1. Boot from image.
1. `ctrl + alt + f2`.
1. Entrar na sessão:
	1. Login: chronos
	1. Senha:
1. Rode: `sudo /usr/sbin/chromeos-install --dst /dev/sda`.

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

#### Toilet

#### Yad

##### Status code return

- *ok button*: `0`.
- *cancel button*: `1`.
- per *timeout*: `70`.
- `esc` *or* `kill`: `252`.

##### Opções de dialogo

- `--about`: dialogo de *about* do próprio *yad* (#*PIOO*).
- `--app`: dialogo padrão (equivalente a simplesmente `> yad`? #*PIOO*).
- `--calendar`: dialogo de calendário; **retorno**: a data no formato `mm/dd/yyyy`.
- `--color`: dialogo de seleção de cor; **retorno**: a cor em *hexa* (`#ffffff`).
- `--dnd`: dialogo de *drag and drop* (#*PIOO*).
- `--entry`: dialogo para entrada de texto; **retorno**: o texto informado.
- `--icons`: define o ícone da barra de título da tela de dialogo (#*PIOO*).
- `--file`: dialogo para seleção de arquivos do sistema; **retorno**: o *path* do arquivo selecionado.
- `--font`: dialogo para seleção de fontes do sistema; **retorno**: a especificação da fonte (`<name> <type> <thickness> <size>`).
- `--form`: base de uma tela para montar formulários (#*PIOO*).
- `--list`: base de uma tela para montar listagens de itens (#*PIOO*).
- `--multi-progress`: múltiplas barras de carregamento (#*PIOO*).
- `--botebook`: "".
- `--notification`: "".
- `--print`: dialogo de impressão (#*PIOO*).
- `--progress`: barra de carregamento (#*PIOO*).
- `--text-info`: dialogo para textos informativos (#*PIOO*).
- `--scale`: dialogo de escolha de valor de 0 a 100 (*like* potenciômetro); **retorno**: o valor selecionado.

##### Opções gerais

- `--title=<title>`: *seta* o título da janela.
- `--window-icon=<icons_path_?>`: *seta* o ícone da janela.
- `--width=<size>`: *seta* a largura da janela.
- `--height`: *seta* a altura da janela.
- `--posx=<number>`: *seta* a posição da janela no eixo *x* (pode ser negativo).
- `--posy=<number>`: *seta* a posição da janela no eixo *y* (pode ser negativo).
- `--geometry=<WIDTHxHEIGHT+X+Y>`: *seta* toda a posição e tamanho da janela num único parâmetro.
- `--timeout=<timeout>`: *seta* o tempo de expiração da janela.
- `--timeout-indicator=<position>`: *seta* o lugar aonde a barra de tempo limite irá aparecer na janela e os valores possíveis são: *top*, *bottom*, *left* ou *right*.
- `--kill-parent=[<signal>]`: envia o número ou o prefixo do *SIGNAL* para o processo pai, *SIGTERM* é o *SIGNAL* *default*.
- `--text=<string>`: *seta* um texto na janela.
- `--text-align=<type>`: *seta* a justificação do texto da janela e os valores possíveos são: *left*, *right*, *center* or *fill*.
- `--image=<image_path>`: *seta* a imagem ou ícone da janela.
- `--icon-theme=<theme>`: *seta* o tema *GTK* dos ícones ao invés do padrão.
- `--keep-icon-size`: deixa fíxo o tamanho dos ícones e não responsivo.
- `--button=<button>:<id>`: adiciona um botão de dialogo, `<id>` é um código de saida ou comando e `<button>` pode ser um nome de item de estoque *yad* para botões predefinidos (como `yad-close` ou `yad-ok`) ou texto em um formulário `LABEL[!ICON[!TOOLTIP]]` onde `!` é um separador de itens.
- `--no-buttons`: retira todos os botões.
- `--buttons-layout=<type>`: *seta* o *layout* do botão e os valores possíveis são: *spread*, *edge*, *start*, *end* ou *center*, *default* é *end*.
- `--no-escape`: desabilita o escape (não fecha o dialogo com a tecla `esc`).
- `--center`: *spawna* a janela do centro da tela.
- `--maximized`: *spawna* a janela maximizada.
- `--fullscreen`: *spawna* no `F11`.
- `--skip-taskbar`: não mostra a janela na *taskbar*.

OBS: a marcação `#PIOO` significa: *"para interagir com outros objetos"*.

##### STOCK ITEMS

| ID           | Label text | Iconname         |
| :----------- | :--------- | :--------------- |
| yad-about    | About      | help-about       |
| yad-add      | Add        | list-add         |
| yad-apply    | Apply      | gtk-apply        |
| yad-cancel   | Cancel     | gtk-cancel       |
| yad-clear    | Clear      | document-clear   |
| yad-close    | Close      | window-close     |
| yad-edit     | Edit       | gtk-edit         |
| yad-execute  | Execute    | system-run       |
| yad-no       | No         | gtk-no           |
| yad-ok       | OK         | gtk-ok           |
| yad-open     | Open       | document-open    |
| yad-print    | Print      | document-print   |
| yad-quit     | Quit       | application-exit |
| yad-refresh  | Refresh    | view-refresh     |
| yad-remove   | Remove     | list-remove      |
| yad-save     | Save       | document-save    |
| yad-search   | Search     | system-search    |
| yad-settings | Settings   | gtk-preferences  |
| yad-yes      | Yes        | gtk-yes          |

#### Whiptail

##### Info box

A caixa de informações é um tipo simples de caixa de diálogo de texto que é exibida para o usuário.

```bash
whiptail --title 'Example Title' --infobox 'This is an example info box.' 8 70
```

Neste exemplo, o `title` é exibido na parte superior da caixa. A `infobox` é o corpo da caixa de diálogo e os dois argumentos finais são a altura e a largura da caixa.

Há um bug que faz com que a Caixa de Informações não seja exibida em alguns *shells*. Se este for o caso, você pode definir a emulação do terminal para algo diferente e funcionará.

```bash
TERM=ansi whiptail --title 'Example Title' --infobox 'This is an example info box.' 8 70
```

##### Message box

A caixa de mensagem é muito semelhante à caixa de informações, no entanto, espera que o usuário pressione o botão OK para continuar após o prompt.

```bash
whiptail --title 'Example Title' --msgbox 'This is an example message box. Press Ok to continue.' 8 70
```

##### Yes/No box

A entrada sim/não faz o que diz na lata. Ele exibe um prompt com as opções de sim ou não e reposta é dada pelo código de retorno do comando.

```bash
# A simple if/then to do different things based on if yes or no is pressed.
if (whiptail --title 'Example Title' --yesno 'This is an example yes/no box.' 8 70); then
    echo 'yes'
else
    echo 'no'
fi
```

##### Input box

A caixa de entrada adiciona um campo de entrada para o texto a ser digitado. Se o usuário pressionar enter, o botão *Ok* será pressionado. Se o usuário selecionar *Cancel*, então é exitado do dialogo. O que o usuário passar no *input* é retornado pelo comando.

```bash
# The `3>&1 1>&2 2>&3` is a small trick to swap the stderr with stdout.
# Meaning instead of return the error code, it returns the value entered.
COLOR=$(whiptail --title 'Example Dialog' --inputbox 'What is your favorite color?' 8 78 blue 3>&1 1>&2 2>&3)

# Now to check if the user pressed "Ok" or "Cancel"
exit_status=$?

if [ $exit_status -eq 0 ]; then
    echo "User selected \"Ok\" and entered ${COLOR}."
else
    echo 'User selected "Cancel".'
fi

echo "(Exit status was ${exit_status}.)"
```

##### Text box

Uma caixa de texto é semelhante à caixa de mensagem, mas obtém o corpo do texto de um arquivo especificado. Adicione `--scrolltext` se o arquivo for maior que a janela exibida.

```bash
echo "Welcome to Bash ${BASH_VERSION}." > ./test_textbox.txt

# <filename> <height> <height>
whiptail --textbox ./test_textbox.txt 12 80
```

##### Password box

Uma caixa de senha é uma caixa de entrada com os caracteres exibidos como asteriscos para ocultar sua entrada.

```bash
PASSWORD=$(whiptail --title 'New Password' --passwordbox 'Enter your new password:' 8 70 3>&1 1>&2 2>&3)

# Now to check if the user pressed "Ok" or "Cancel"
exit_status=$?

if [ $exit_status -eq 0 ]; then
    echo "User selected \"Ok\" and entered ${PASSWORD}."
else
    echo 'User selected "Cancel".'
fi

echo "(Exit status was ${exit_status}.)"
```

##### Menus

A caixa de diálogo do menu pode mostrar uma lista de itens dos quais o usuário pode selecionar um único item. O valor adicional `16` ao lado da altura e largura é o total de linhas que podem ser exibidas antes que o menu se torne rolável.

```bash
whiptail --title 'Menu example' --menu 'Choose an option:' 25 78 16 \
'*** Back ***' 'Return to the main menu.' \
'* Add User' 'Add a user to the system.' \
'* Modify User' 'Modify an existing user.' \
'* List Users' 'List all users on the system.' \
'* Add Group' 'Add a user group to the system.' \
'* Modify Group' 'Modify a group and its list of members.' \
'* List Groups' 'List all groups on the system.'
```

Os valores são uma lista de opções de menu no formato ``tag item``, onde tag é o nome da opção que é impressa em *stderr* quando selecionada, e item é a descrição da opção de menu.

Se você estiver apresentando um menu muito longo e quiser fazer o melhor uso da tela disponível, poderá calcular o melhor tamanho de caixa por.

```bash
eval `resize`
whiptail ... $LINES $COLUMNS $((${LINES}-8)) ...
```

##### Check list

A janela da lista de verificação é um menu multi-selecionável onde um único ou vários itens da lista podem ser seleccionados.

```bash
whiptail --title 'Check List Example' --checklist "Choose user's permissions:" 20 78 4 \
'NET_OUTBOUND' '__ Allow connections to other hosts' ON \
'NET_INBOUND' '__ Allow connections from other hosts' OFF \
'LOCAL_MOUNT' '__ Allow mounting of local devices' OFF \
'REMOTE_MOUNT' '__ Allow mounting of remote devices' OFF
```

Quando o usuário confirma suas seleções, uma lista de opções é impressa no *stderr*.

##### Radio list

Uma lista de rádio é uma caixa de diálogo onde o usuário pode selecionar uma opção de uma lista. A diferença entre uma lista de rádio e um menu é que o usuário seleciona uma opção (usando a barra de espaço em whiptail) e depois confirma essa escolha pressionando *Ok*.

```bash
whiptail --title 'Radio List Example' --radiolist "Choose user's permissions:" 20 78 4 \
'NET_OUTBOUND' '__ Allow connections to other hosts' ON \
'NET_INBOUND' '__ Allow connections from other hosts' OFF \
'LOCAL_MOUNT' '__ Allow mounting of local devices' OFF \
'REMOTE_MOUNT' '__ Allow mounting of remote devices' OFF
```

##### Progress gauge

Syntax: `whiptail --gauge <text> <height> <width> [<percent>]`

Também lê por cento de stdin:

```bash
#!/bin/bash
{
    for ((i=0;i<=100;i+=5)); do
        sleep 0.1
        echo $i
    done
} | whiptail --gauge 'Please wait while we are sleeping...' 6 50 0
```

---

<a id="db_any_commands"></a>
[<span style="font-size:14px;">Any commands</span>](#menu)

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

### Comando *mocp*

Programas necessários:

```bash
sudo apt install moc -y
```

Player de música CLI:

- --theme|-T: *seta* o tema do `mocp` (com base nos nomes listados em `/usr/share/moc/themes/` ou `~/.moc/themes/`)

```bash
mocp [--theme|-T <theme_name>] [/path/to/folders/music/]
```

**Funções das teclas dentro do TUI**:

- return: reproduz a música em foco/volta para o início
- S: reprodução aleatória
- R: repetição da música
- n: próxima música
- space|p: pausa/despausa a música
- alt+[1-9]: seta o volume para o *value*\*10
- q: sai da tela do moc e o deixa em background (só chamar `mocp` novamente para retomar)
- Q: quita por completo
- ?: help menu

### Comando *mplayer*

Programas necessários:

```bash
sudo apt install mplayer -y
```

#### Vídeo

Player de vídeo mínimo:

```bash
mplayer /path/to/video.any
```

**Funções das teclas dentro do TUI**:

- *: aumenta o volume
- /: diminui o volume
- arrow{right|left}: vai para frente ou para trás no tempo
- q: quita do programa

#### Câmera

Player de câmera mínimo:

- *X*: deve ser trocado pelo número do device correspondente

```bash
mplayer tv:///dev/videoX &>/dev/null
```

### Comando _ngrok_

#### Criar túnel para conexão SSH

1. Instalação (caso falhe pode ser o _link_ que quebrou):
	`curl -fsSL https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz | sudo tar -C /usr/local/bin/ -zxvf -`

1. Configuração (da sua conta _web_ do **ngrok**):
	`ngrok config add-authtoken <api_token>`

1. Iniciar o _revers proxy_:
	`ngrok tcp 22`

Depois de iniciado, uma das linhas incia com "_Forwarding_" aonde:

```bash
tcp://0.tcp.us.ngrok.io:00000 -> localhost:00000
```

O domínio disponibilizado pelo **ngrok** é:
	`tcp://<DOMAIN>:00000`

E a porta disponibilizado pelo **ngrok** é:
	`tcp://0.tcp.us.ngrok.io:<PORT>`

Agora basta fazer a conexão como:

```bash
ssh -p <ngrok_port> <your_user>@<ngrok_domain>
```

_tips_:

- Iniciar o **ngrok** em background:

```bash
nohup ngrok tcp 22 &>/dev/null &
```

- Pegar as infos de _url's_ e endereços locais _bindados_:

```bash
curl -sS http://127.0.0.1:4040/api/tunnels | jq -C | grep -E '(public_url|addr)'
```

- Matar todas as seções do **ngrok**:

```bash
kill -KILL `ps -o pid -C ngrok | tail -n +2`
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

Programas necessários:

```bash
sudo apt install pdftk -y
```

Mesclar pdfs:

```bash
pdftk ./*.pdf cat output /output/path/to/file.pdf
```

_Splitar_ (cortar) pdf:

```bash
# Pega da página 7 até a página 22.
pdftk /path/to/input.pdf cat 7-22 output /path/to/output.pdf

# Pega da página 3 até a penúltima página.
pdftk /path/to/input.pdf cat 3-r2 output /path/to/output.pdf

# Pega as 3 últimas páginas.
pdftk /path/to/input.pdf cat r3-r1 output /path/to/output.pdf
```

### comando *highlight-pointer*

Instalação:

```bash
sudo apt install libx11-dev libxext-dev libxfixes-dev libxi-dev -y \
&& git clone 'https://github.com/swillner/highlight-pointer' \
&& cd ./highlight-pointer/ \
&& make \
&& sudo mv -v ./highlight-pointer /usr/local/bin/
```

Uso de exemplo:

```bash
nohup highlight-pointer \
	--show-cursor \
	-o 3.75 \
	-r 24.75 \
	-c '#303030' \
	-p '#a41313' \
	-t 5 \
	--auto-hide-cursor \
	--auto-hide-highlight \
&
```

### Comando _figlet_

Instalação:

```bash
sudo apt install -y figlet
```

_Printar_ a menssagem como _banner_:

```bash
figlet [-f <fontname>] "TEXT FOR BANNER"
```

Adicionar fontes:

1. Ir para a pasta de recursos:
	`cd /usr/share/`

1. Baixar o _repo_ com as fontes:
	`git clone 'https://github.com/xero/figlet-fonts'`

1. Substituir as fontes originais:
	`sudo mv ./figlet-fonts/* ./figlet/`

1. Remover o repo com as fontes:
	`sudo rm -rf ./figlet-fonts/`

_pipeline_:

```bash
cd /usr/share/ && sudo git clone 'https://github.com/xero/figlet-fonts' && sudo mv ./figlet-fonts/* ./figlet/ && sudo rm -rf ./figlet-fonts/
```

Mostrar as fontes do **figlet**:

```bash
showfigfonts
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

### Default web browsers availables:

goods:

- `angelfish`;
- `epiphany-browser`;
- `falkon`;
- `konqueror`;

bads:

- `alice`;
- `dillo`;
- `hv3`;
- `netsurf-gtk`;
- `surf`;

### Gravador nativo do _gnome-shell_?

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

<a id="git"></a>
## [> Git](#menu)

### *Quick Start*

1. `git add ./`
1. `git commit -m 'commit message'`
1. `git push origin branchname`

### Branchs

#### Listagem de branchs

Locais:

```bash
git branch [--list|-l]
```

Remotas:

```bash
git branch {--remotes|-r} {--list|-l}
```

Locais e remotas:

```bash
git branch {--all|-a}
```

Detalhamento das branchs:

```bash
git branch -vva
```

Mostra além das branchs remotas, outras infos:

```bash
git remote show <remote_name>
```

#### Troca de branchs

Com *checkout*:

- -b: cria uma nova branch.

```bash
git checkout [-b] <branch_name>
```

Com *switch*:

- -c: cria uma nova branch.

```bash
git switch [-c] <branch_name>
```

OBS: casp seja passado a opção de criação de branch na hora de mudar para ela, será criado essa nova branch e seguida mudado para ela.

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

### Commits

#### Resetar commits

Resetar o commit sem perder as alterações colocando elas na _worktree_:

```bash
git reset <commit_hash>
```

Resetar o commit sem perder as alterações voltando elas para o _index_ (_staged area_):

```bash
git reset --soft <commit_hash>
```

Desfazer o commit por completo (sem manter as alterações):

```bash
git reset --hard <commit_hash>
```

#### Editar mensagem

Editar a mensagem do último commit:

```bash
git commit --amend -m 'new message'
```

OBS: depois que realizar o comando, aparecerá um "commit extra", porém, simplesmente *pushe* a nova alteração forçando que esse novo commit já e sobrescrito: `git push -f origin <branch_name>`.

#### Cherry Pick

Trazendo um _commit_ específico para a branch:

```bash
git cherry-pick <commit_hash>
```

Somente aplicando as alterações do _commit_:

```bash
git cherry-pick --no-commit <commit_hash>
```

Trazendo o _commit_ e edita a mensagem antes de concluir:

```bash
git cherry-pick --edit <commit_hash>
```

OBS: estando na _branch_ que vai receber as alterações.

_REFERENCELINKS_:

- https://www.atlassian.com/git/tutorials/cherry-pick
- https://git-scm.com/docs/git-cherry-pick

#### Squash

_Squashear commits_ da mesma branch com `rebase`:

```bash
git rebase -i {HEAD*|<commit_hash>}
```

### Merge

"Dry Run":

1. Faça o "_merge_ falso":
	`git merge --no-commit --no-ff <branch_name>`

1. Caso tenha alguma alteração, veja com:
	`git diff --cached`

OBS: caso precise desafzer algum merge: `git merge --abort`.

### Rebase

Caso tenha acabado de criar um novo galho porém foi a partir da base errada:

```bash
git rebase -if upstream/main
```

OBS: caso necessário exclua todos os _commits_ (`b` _mark_) para mudar para a outra base de forma limpa.

### Stash

- `-u`: _stashear_ arquivos não traqueados;
- `-m <message>`: _stashear_ com mensagem específica;
- `-p`: _patch_ dos arquivos;

_Stashear_ todos os arquivos:

```bash
git stash [-u]
```

_Stashear_ todos com alguma mensagem específica:

```bash
git stash save '<menssage>'
```

_Stashear_ arquivos específicos:

```bash
git stash push [-u] [-m '<message>'] <path/to/folder/or/file.any>
```

Mostrar por completo o log do stash (modo `--patch` e arquivos não traqueados):

```bash
git stash show -up stash@{<stash_id>}
```

### Log's

- --all: caso sua branch esteja atrás, mostra logs dos ramos a frente também.
- --oneline: mostra o log de forma resumida, um por linha.
- --patch: mostras as alteraçẽos feitas nos commits.
- --graph: dsenha uma gráfo da time line dos logs.

Mostra o log de commits:

```bash
git log [--all|--oneline|--patch|--graph]
```

OBS: todas as opções podem ser usadas ao mesmo tempo ou não (divirta-se).

Rastrear um único arquivo pelos *commits*:

```bash
git log --folow [-p] <file_name>
```

### Blame

Mostra quem fez as alterações (autor do commit) em determinado arquivo:

- -w: remove espaços em branco.
- -L: limita a faixa de linhas.

```bash
git blame [-w|-L 1,12] <file_name>
```

### Clonagem

Clonar repositório remoto:

```bash
git clone <url>
```

Clonar repositório remoto de uma branch ou tag específica:

```bash
git clone -b {<branch_name>|<tag_name>} <url>
```

OBS: caso clone por algum tag, pode ser que essa tag esteja num vínculada a um hash que não está apontado por nenhuma branch, nesse caso, se faz necessário cria uma branch logo depois que clonar: `git switch -c newbranch`

### Submodule

Adicionar um novo _submodule_:

```bash
git sobmodule add {./path/to/another/local/repo|<remote_url>}
```

Iniciar os _submodules_ de um repositório clonado (estando na raiz do repositório local):

```bash
git sobmodule init
```

_Updatar_ os submódulos:

```bash
git sobmodule update
```

Caso o _submodule_ não esteja apontando para a HEAD do seu repectivo remoto, você pode resolver isso entrando na pasta do submódulo e realizando um `pull` ou diretamente da sua raiz:

```bash
git submodule update --remote
```

Para retirar o _submodule_ do `.git/config`, que é da onde o comando de `update` puxa os _submodules_:

```bash
git submodule deinit <submodule_folder>
```

Clonar repositórios com submódulos já inicializando e atualizando-os:

```bash
git clone --recurse-submodules <remote_url>
```

_OBSERVATIONS_:

- toda vez que fizer alterações nos submódulos, deve-se commitar.

- `git submodule init` refaz a configuração dos submódulos com base no `.gitmodules` caso algum seja retirado do `.git/config`.

- arquivos e pastas:
	- `.gitmodules`: arquivo de configuração que mapeia os submódulos dentro do repo (gerado a partir do `git submodules init`).
	- `.git/config`: dentro do arquivo de configuração do _repo_ local é criado uma sessão com os submódulos para serem _updatados_.
	- `.git/modules`: é a pasta que vão os múdulos baixados por _url_.

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

Setar o `.gitignore` global:

```bash
git config --global core.excludesfile ~/.gitignore
```

Caso algum arquivo seja ignorado deve-se remove-lo do índice:

```bash
git rm --cached file.txt
```

Adicionar no índice algum arquivo que esteja sendo ignorado:

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

### Tag's

Colocar tag em commits (da para clonar de um commit específico):

```bash
git tag <tag_name> <commit_hash>
```

Remover tag local:

```bash
git tag -d <tag_name>
```

Remover tag remota:

```bash
git push origin :refs/tags/<tag_name>
```

### Repos

#### Remotes

Renomear repositório remoto:

```bash
git remote rename <nome_atual> <novo_nome>
```

#### Forks

Sincronizar repo local com upstream:

1. Add remote repo:
	`git remote add upstream <url>`;

1. Fetch infos:
	`git fetch upstream`;

1. Change to target branch (if needed):
	`git switch main`;

1. Merge with upstream:
	`git merge upstream/main`;

### Authentication

#### Credential Helper

_Setar_ o arquivo de configuração:

```bash
echo 'https://<user>:<token>@<domain>' >> ~/.git-credentials
```

Cache:

```bash
git config --global credential.helper cache
# or seting the time
git config --global credential.helper 'cache --timeout=28800'
```

Store:

```bash
git config --global credential.helper store
```

Limpar a senha do cache:

```bash
git credential-cache exit
```

_Desetar_ a configuração global:

```bash
git config --global --unset credential.helper {cache|store}
```

### Troubleshooting

#### Pasta inacessível (pasta com *submodule*)

1. `git rm --cached <folder_name>`
1. `rm -rf <folder_name>/.git`
1. `git add .`
1. `git push origin main`

#### Listar somente os arquivos com conflito no `--rebase`:

```bash
git status --short | sed -n 's/AA //p'
```

#### Depois de alterar o nome da branch default no remoto:

1. `git branch -m master main`
1. `git fetch origin`
1. `git branch -u origin/main main`
1. `git remote set-head origin -a`
1. `git remote prune origin`

_pipeline_:

```bash
git branch -m master main && git fetch origin && git branch -u origin/main main && git remote set-head origin -a && git remote prune origin
```

### Any others

#### Sintaxe de URL's:

http:

```bash
https://<user>:<token>@<domain>/<user>/<repo>.git
```

ssh:

```bash
git@<domain>:<user>/<repo>.git
```

latest release:

```bash
https://github.com/<user>/<repo>/releases/latest/download/<filename>
```

#### Certificados de Segurança

Desabilitar verificação de SSL do git:

```bash
git config --global http.sslverify false
```

#### Copiar/Pegar as Modificações de Um Arquivo de Outra Branch

```bash
git checkout <other_branch> -- ./path/to/{folder|file.any}
```

#### Git Playground

<http://git-school.github.io/visualizing-git/>

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

<a id="android"></a>
## [> Android](#menu)

### Instalção de GSI (ROM)

Programas necessários:

```bash
sudo apt install -y adb fastboot [android-sdk-platform-tools-common]
```

1. No sistema **android** ainda rodando:

	1. Ativar depuração *USB*.

	1. Ativar desbloqueio de *OEM*.

1. Entrar na tela do *bootloader* (ligar o dispositivo em modo de *fastboot*).

1. Conectar via *USB* o dispositvo android no *OS*.

1. Na linha de comando:

	1. `fastboot reboot fastboot`.

	1. `fastboot flash system </path/to/descompressed/image.img>`.

		- Caso esse passo dê algum erro refente a falta de espaço, execute o comando:

			`fastboot delete-logical-partition product_<letter_partition>`.

		- E reexecute o comando de *flash system*.

1. Em alguns casos é necessário executar o *vbmeta* para desbloquear o *boot* que acabará sendo bloqueado por algumas marcas de dispositivos:

	1. Entre no *bootloader* padrão do device pelos botões de controle ou:
		`fastboot reboot bootloader`.

	1. `fastboot flash vbmeta </path/to/vbmeta.img>`.

	1. `fastboot erase userdata`.

	1. `fastboot erase metadata`.

	1. `fastboot reboot`.

Tips:

- A primeira inicialização pode ser *bugada* e simplesmente depois de um *reboot* já não tera mais?

- Instalar o aplicativo **Table Info** para saber infos importantes ao que diz respeito a qual ROM customizada instalar no dispositivo.

_REFERENCELINKS_:

- [repositório trable](https://github.com/phhusson/treble_experimentations/).

- [vbmeta](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqa2FlYmZLZjMtSVVzWnUzUkxYSFhNUkg4VVFfZ3xBQ3Jtc0tsMS15VFNteXlJdm1LYnJqSGhINXh4RkRqWjF2YUFsRXRHQVdjdks5bTBzMlREdkNPckIzQ25EMUJISGFacjlna1g5NjlQQVo3UGN5ckFkX184S2ZNamxfVm9rTmxHOWxkVXlENjFkTWVjeXhxakgzcw&q=https%3A%2F%2Fdl.google.com%2Fdevelopers%2Fandroid%2Fqt%2Fimages%2Fgsi%2Fvbmeta.img&v=PFDeme_gPGc).

---

<a id="miscellaneous"></a>
## [> Miscellaneous](#menu)

### Markdown

Quebra de linha:

```md
&nbsp;
```

Links de referência:

```md
[repo]: https://github.com/rhuanpk/linux

This is the link of my [personal repo][repo].

And [here][repo] too.
```

---

<a id="estudos"></a>
## [> Estudos](#menu)

### Tipos de datas

- Access time:
	- Explicação: data que o arquivo foi acessado ou lido pela última vez (sem modificações).
	- Exemplo: cat, head, vim, less.

- Modify time:
	- Explicação: data que o arquivo foi modificado pela última vez.
	- Exemplo: editando o contúdo do arquivo, adicionando ou excluindo.

- Change time:
	- Explicação: data que o inode do arquivo é modificado.
	- Exemplo: alterando permissões, propriedade, nome do arquivo ou número de links físicos.

- Birth time:
	- Explicação: data que o arquivo foi criado.

---

### Arquivos removidos

Quando removemos algum arquivo, na verdade o que acontece é que o bloco no disco fica liberado para ser gravado outro conteúdo por cima ([conteúdo relacionado](#forense)).

---

### Open FD's (File Descriptors)

```bash
whiptail <any_syntax> 3>&1 1>&2 2>&3
```

Nesse caso ele usa um *I/O redirection* (via pipes) pois o programa (em específico, o `whitpil`) não prepara os *FD's* para que você possa simplesmente redirecionar a *STDOUT* para uma variável (como geralmente você faz com a grande maioria dos *shell scripts*).

Em outras palavras, o `whitpil` não é designado para ser usado dessa forma (redirecionando a saída padrão dele), mas você pode mnipulalo forçando em nível de gerenciamento de descritores de arquivos. Essa é a "*API*" que o kernel Linux usa pra fornecer oque se chama de "*file*" em *user-land*.

Arquivos na verdade não existem de fato, o que existe é uma tabela de *FD's* ("*binary numbers representation*") e é assim que o núcleo (kernel) cria uma forma de gerenciar arquivos na *user-land*.

O Linux, é a engrenagem (motor) que usa a memória disponível (e memória sempre é um problema, por ser limitado)), criando essa *API* para você poder criar/remover arquivos em sistemas *unix-like* e assim como nesse caso, o próprio Linux. Usamos esse conceito de que tudo é um arquivo e sim, isso é um enorme problema... digamos que o Linux joga tudo isso para baixo do tapete e esconde os problemas na *user-land* (nem tudo é perfeito). O *design* e implementação dessas *API's* tem sempre os seus contras (limitações que geram problemas) e é isso que gera bugs.

Quando você usa esse símbolo: `>` (sinal de maior), no **shell bash** do Linux, ele entende que você está precissando lidar com a saída padrão de um recurso (processos ou arquivos (*I/O resources*)), então você cria um novo *FD* (ocupa um *slot* de memória), ou seja, você cria um novo *FD* sempre que quer despejar algo de um lugar pra outro, nesse caso usando o operador pipe do shell. Olha que engraçado, no Linux, **um diretório é um arquivo**!

Quando esperamos um “valor de retorno” de um comando, invocamos uma *subshell* (`$(<command>)`) e atribuímos a saída a uma variável:

```bash
xpto=$(whitptail <any_syntax>)
```
Mas há algo importante a ser observado: tecnicamente falando, não há “valor de retorno” (que é uma definição imprópria), o que é atribuído à variável é a **_STDOUT_** (*stderr* não é atribuído!).

Veja este exemplo:

```bash
# `echo` defaults to *stdout*; nothing is printed, because *stdout* is captured!
$ xpto=$(echo "anythink")
$ echo $xpto
value

# This is printed, as it's *stderr*!
$ xpto=$(echo "anythink" >/dev/stderr)
anythink
$ echo $xpto
# empty!
```

Agora, a maneira como o `whiptail` funciona é que os *widgets* são impressos em *stdout*, enquanto o "valor de retorno" é impresso em *stderr*. Podemos capturar apenas do *stdout*, então o que fazemos?

Simples! Trocamos *stdout* e *stderr*! Imprimir os *widgets* para *stderr* é perfeitamente válido e obtemos o “valor de retorno” em *stdout*.

A expressão formal disso é `3>&1 1>&2 2>&3`, que significa:

1. Criamos um descritor de arquivo temporário (3) e o apontamos para *stdout* (1).
1. Redirecionamos *stdout* (1) para *stderr* (2).
1. Redirecionamos *stderr* (2) para o descritor de arquivo temporário (3), que aponta para *stdout* (devido ao primeiro passo).

Resultado: *stdout* e *stderr* são trocados :).

#### Conclusão

Nesse exemplo do `whiptail`, aonde de certa forma podemos abstrair da seguinte forma:

```bash
# A considerar:
# - Por padrão o `whiptail` mostra sua saida em **STDOUT** (*file descriptor* 1)
# - Por padrão envia o seu "retorno" para **STDERR** (*file descriptor* 2)

xpto=$(whiptail <command> 3>&1 1>&2 2>&3)

#  (descritor temporário) 3>&1 (1->padrão->tela->captura)
#          (padrão->tela) 1>&2 (2->erro->não capturada->tela)
#       (erro->tela/null) 2>&3 (aponta para descritor 3)
```

Ele não continua num *loop* de `2>&1 -> 3>&1 -> 1>&2 ...`, nesse caso, quando o `whiptail` é encerrado, seu retorno é enviado para **STDERR** (2) que é redirecionada para o descritor de arquivos 3, que nesse ponto (em que o *file descriptor* 2 (**STDERR**) é redirecionado para ele) já foi redirecionado para **STDOUT** (1) que já tem sua saida definida (que é a tela, mas que porém é capturada pela variável) e não precisa ser "verificado" novamente pois no momento que ele vai para o descritor 3 é como se ele "voltasse no tempo" e nesse ponto o descritor 1 (**STDOUT**) ainda não tinha sido direcionado para o descritor 2 (**STDERR**, que o faria então entrar em *loop*).

---

### A Interface Gráfica

#### Definição

Uma interface gráfica (*Graphical User Interface* (*GUI*)) é um tipo de interface de usuário que permite a interação com um equipamento eletrônico por meio de ícones gráficos e outros elementos visuais, composto por:

- *Window System*.
- *Windows Manager*.
- *Desktop Environment*.
- *Display Manager*

#### Sistema de Janelas (*Window System* (*WS*))

O *Window System* é o componente da *GUI* que suporta a implementação de *Window Manager's* e fornece suporte a *hardware* gráfico, dispositivos apontadores e teclados.

- O sistema de janelas não inclui as janelas em si, ele implementa renderização de fontes, desenhos primitivos (linhas e traços), e habilita o computador a trabalhar com vários programas simultaneamente ao compartilhar recursos de *hardware* gráfico entre as janelas.

- Cada programa roda em sua própria janela, e alguns *Window System's* permitem mostrar aplicações gráficas que rodam em uma máquina remota.

- Alguns exemplos de *Window Manager's*:

	- Xorg.
	- Wayland.
	- Quartz Compositor (Mac OS X).

#### Gerenciador de Janelas (*Window Manager* (*WM*))

O *Window Manager* realiza a interação entre janelas, aplicações e o *Windowing System*.

- O *Window Manager* manipula dispositivos de *hardware* (mouse, placas de vídeo), assim como o posicionamento do ponteiro.

- Todos esses elementos são modelados para criar uma simulação denominada *Desktop Environment*, no qual a tela do PC representa uma "mesa" sobre a qual documentos e pastas são colocados.

- Um *Window Manager* é um *software* que controla o posicionamento e aparência de janelas dentro de um *Window System* em uma *GUI*.

- A maioria dos *Window Manager's* é projetada para fornecer um *Desktop Envionment*, trabalhando junto com o *Window System* o qual fornece suporte ao *hardware* gráfico, dispositivos apontadores e teclado.

- Alguns exemplos de *Window Manager's*:

	- Metacity (*Gnome 2*).
	- Mutter (*Gnome 3*).
	- KWin (*KDE*).
	- Compiz.
	- Beryl.

#### Ambiente de Desktop (*Desktop Environment* (*DE*))

O *Desktop Environment* trata-se de uma implementação de vários componentes, incluindo um *Window Manager*, temas, bibliotecas e aplicações que interagem com o *Window System* presente no computador.

- Alguns exemplos de *Desktop Environment's*:

	- CDE.
	- KDE.
	- GNOME.
	- Xfce.
	- LXDE.

#### Gerencador de Sessão (*Display Manager* (*DM*))

O *Display Manager* (ou *Login Manager*) é o software que fornece uma tela para que o usuário entre com suas credenciais para login (autenticação) local ou remoto e também permite escolher qual *Desktop Environment* será carregado (GNOME, KDE, Xfce, etc)

- Alguns exemplos de *Display Manager's*:

	- LightDM.
	- gdm.
	- xdm.
	- kdm.

---

### "/" no final da passagem de algum PATH

Estou fazendo esse artigo pois eu tive essa dúvida recentemente... em que casos e porque era ou não necessário a utilização da "/" no final de algum path na hora de passar na linha comdando? Por fim, em conversa com colegas da comunidade **slackjeff** e outros, fiz esses testes por conta própria e achei que poderia ser a dúvida de outros também.

No final desse post eu dei minha conclusão **PESSOAL**, não tenho LPIC 3, sou apenas um *jovem padawan* em evolução ainda, então, caso tenho cometido algum deslize, estou totalmente aberto a correções.

Para realizar os mesmo teste, basta cirar e entrar na pasta `/tmp/tmp` como segue na *gif* de exemplo:

![bar-final-path](/.assets/gifs/bar-final-path.gif)

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

#### Conclusão

Quando usamos "**/**" ao passar algum *path*, deixamos explícito que o alvo é uma **pasta/diretório** e não um arquivo **comum/regular**.

Porém, se usamos sem a "**/**", em tese, deixamos explícito que é um arquivo **regular** (já que com a "**/**" dizemos que **é**), mas, dependendo da situação, se o alvo for mesmo um diretório e não especificarmos a "**/**", ele conseguirá executar a ação (levando em consideração é claro que o esperado fosse que o alvo seja uma pasta mesmo).
