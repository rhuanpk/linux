<a id="menu"></a>
# Comandos Linux

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
- [Games](#games)
- [Estudos](#estudos)

<a id="debian_base"></a>
## [Debian base](#menu)

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

#### Update Alternatives

Comando _[update-alternatives](#update-alternatives)_:

```bash
sudo update-alternatives --install /usr/share/icons/default/index.theme x-cursor-theme /usr/share/icons/cursor/index.theme 999
```

_OBSERVATIONS_:
- No caso dos cursores, devem ser salvos para `/usr/share/icons` pasta;
- Na pasta do tema dever haver no mínimo algum arquivo ".theme" com:
```theme
[Icon Theme]
Inherits=<name-cursor-root-directory>`
```

##### Aplicar novo tema de cursor

Comando _[update-alternatives](#update-alternatives)_:

```bash
sudo update-alternatives --config x-cursor-theme
```

OBS: Precisa reiniciar a sessão para aplicar

#### Xresources

Utilizar definição direto no Xorg:
1. Mover o cursor para `~/.icons`
1. No arquivo `~/.Xresources`:
    `Xcursor.theme: <name-cursor-root-directory>`
1. Reinicie o Xorg ou recarregue as configurações:
    `xrdb -merge ~/.Xresources`

### Fonts

#### Diretórios

Path de todos os usuários:

```bash
/usr/share/fonts
```

Path pessoal do usuário:

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

Remover completamente o programa (**#**):
```sh
apt purge <package>
```

Fazer apenas o download do programa e suas dependências sem instalar (**#**):
```sh
apt install --download-only <package>
```

OBS: os _deb's_ serão salvos em `/var/cache/apt/archives`.

Listar pacotes instalados que não sejam dos repositórios do Debian (**#**):
```sh
apt list '~i!~Odebian'
```

#### `apt-pinning`

Edite no `/etc/apt/preferences.d/all`:
```
Package: *
Pin: release a=stable
Pin-Priority: 500

Package: *
Pin: release a=testing
Pin-Priority: 400

Package: *
Pin: release a=unstable
Pin-Priority: 300
```

Com essa configuração de versão de pacotes e configurado também o `sources.list` você terá acesso a mais de uma versão de pacote por vez sendo que a estável será a prioridade e será baixada automática quando não específicado a versão.

Para baixar de um _source_ diferente:

1. `apt install <package>/<source>`:
	- OBS: Tenta instalar a versão instável mantendo as dependências na versão **ESTÁVEL**.

1. `apt install -t <source> <package>`:
	- OBS: Tenta instalar a versão instável atualizando as dependências para a versão **INSTÁVEL** também.

#### Chaves de Repo

##### Baixando Direto

Comando:
```sh
curl -fsSL <repo-url-key> | [sudo] gpg --dearmor --output /etc/apt/trusted.gpg.d/<package-name>.gpg
```

##### Usando `apt-key`

_URL's_ de repositórios de chaves:

- <hkp://p80.pool.sks-keyservers.net:80>;
- <hkp://keyserver.ubuntu.com:80>;

Adicionar chave de repo diretamente pelo fingerprint da mesma (`#`):
```sh
apt-key adv --keyserver <keyserver> --recv-keys <fingerprint>
```

#### _Mirro's_

Debian `/etc/apt/sources.list`:
```sh
# stable
deb http://deb.debian.org/debian/ stable main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security stable-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian/ stable-updates main contrib non-free non-free-firmware

# testing
deb http://deb.debian.org/debian/ testing main contrib non-free non-free-firmware

# unstable
deb http://deb.debian.org/debian/ sid main contrib non-free non-free-firmware
```

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

### Comando _flatpak_

- Flatpak: [Setup](https://flatpak.org/setup)
- Flathub: [Setup](https://flathub.org/setup)

Instalar app flatpak:
```sh
flatpak install flathub <app-id>
```

Listar apps flatpak:
```sh
flatpak list
```

Executar app flatpak:
```sh
flatpak run <app-id>
```

Informações app flatpak:
```sh
flatpak infos <app-id>
```

Desinstalar app flatpak:
```sh
flatpak uninstall <app-id>
```

Listar flatpak _remotes_:
```sh
flatpak remotes
```

Impedir/Liberar app flatpak de receber atualizações:

- `--remove`: "desmascara" o app flatpak

```sh
flatpak mask [--remove] <app-id>
```

#### _Rollback_

Listar as versões do app flatpak:
```sh
flatpak remote-info --log flathub <app-id>
```

Executa o _rollback_ no app flatpak:
```sh
flatpak update --commit=<commit-hash> <app-id>
```

#### _Games_

Vi sugestão do [Eddie](https://github.com/eddiecsilva/debian-post-install?tab=readme-ov-file#configura%C3%A7%C3%B5es-extras), **Steam** e **Heroic Games Launcher**:
```sh
flatpak install com.valvesoftware.Steam com.valvesoftware.Steam.Utility.MangoHud com.valvesoftware.Steam.Utility.vkBasalt com.valvesoftware.Steam.VulkanLayer.MangoHud com.heroicgameslauncher.hgl
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

### Instalar Vagrant

1. `curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -`
1. `sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"`
1. `sudo apt update && sudo apt install vagrant`

### Instalar VirtualBox

Debian SID (**#**):
```sh
apt install linux-headers-`uname -r` virtualbox virtualbox-ext-pack virtualbox-dkms
```

OBS: Depois de instalar um novo kernel, instale os _headers_ novamente.

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

### spotify-downloader

1. `git clone 'https://github.com/spotDL/spotify-downloader' && cd spotify-downloader`
1. `docker build -t spotdl ./ && docker run --rm -ti -v "$(pwd)":/music --entrypoint sh spotdl`
1. `> poetry install`
1. `> poetry run spotdl download '<spotify-url>'`

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
xev
xev -event keyboard
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

#### Comando _parted_

Lista os discos na máquina:

```bash
parted -l
```

#### Aumentar (_grow_) e Encolher (_shrink_) Partições

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

#### Formulas de cálculo Entre MB/GB e SETORES

- SECTORS » MB: `<sectors>/2/1024`
- SECTORS » GB: `<sectors>/2/1024^2`

- MB » SECTORS: `<megabytes>*1048576/512`
- GB » SECTORS: `<gigabytes>*(1048576*1024)/512`

#### Formatação

Programas necessários para `fat32`:
```sh
sudo apt install mtools -y
```

Programas necessários para `exfat`:
```sh
sudo apt install exfat-fuse exfatprogs -y
```

##### Comando _mkfs_

Formatar **fat32**:

- `-n`: adiciona label na formatação.

```sh
sudo mkfs.fat -F 32 [-n <label_name>] /dev/sdXY
```

Formatar **ext4**:

- `-L`: adiciona label na formatação.

```sh
sudo mkfs.ext4 [-L <label_name>] /dev/sdXY
```

Formatar **exfat**:

- `-L`: adiciona label na formatação.

```sh
sudo mkfs.exfat [-L <label_name>] /dev/sdXY
```

Formatar **ntfs**:

- `-Q`: formatação rapida;
- `-L`: adiciona label na formatação.

```sh
sudo mkfs.ntfs [-Q] [-L <label_name>] /dev/sdXY
```

#### Gerenciamento de Labels de Partições

Programas necessários para `fat32`:
```sh
sudo apt install mtools -y
```

Programas necessários para `exfat`:
```sh
sudo apt install exfatlabel -y
```

##### `ext4`

Saber:
```sh
sudo e2label /dev/sdXY
```

Renomear:
```sh
sudo e2label /dev/sdXY label_name
```

##### `fat32`

Saber:
```sh
sudo mlabel -i /dev/sdXY -s ::
```

Renomear:
```sh
sudo mlabel -i /dev/sdXY ::label_name
```

##### `exfat`

Saber:
```sh
sudo exfatlabel /dev/sdXY
```

Renomear:
```sh
sudo exfatlabel /dev/sdXY label_name
```

##### `ntfs`

Saber:
```sh
sudo ntfslabel /dev/sdXY
```

Renomear:
```sh
sudo ntfslabel /dev/sdXY label_name
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

- `-a`: lista também arquivos ocultos;
- `-F`: na saida coloca uma `/` no final do nome do arquivo caso seja um diretório;
- `-C`: *seta* "*color always*";
- `-p`: coloca na saida as permissões dos arquivos;
- `-L <value>`: limita a quantidade de níveis de diretórios na buscar;
- `-P <pattern>`: retorna o que casar com o padrão (aceita coringas);
- `-I <pattern>`: excluí os arquivos/pastas no padrão.

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

- `-i`: *case insensitive*;
- `-r`: recursividade não seguindo symlinks;
- `-n`: número da linhas da ocorrência;
- `-E`: expressão regular extendida;
- `-R`: recursividade seguindo symlinks;
- `-o`: somente a ocorrência e não a linha toda da mesma
- `-v`: inverte a ocorrência, todas as linhas que não casaram;
- `-s`: suprime somente as mensagens de erro;
- `-I`: rejeita arquivos binários na busca;
- `-m <number>`: pare depois de _n_ ocorrências.
- `-A <number>`: quantidade de linhas a baixo da *match line* para ser exibida;

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

Para escolher o editor padrão modo texto/ver o editor padrão modo texto (_[update-alternatives](#update-alternatives)_):

```bash
sudo update-alternatives --config editor
```

#### Terminal padrão

Comando _[update-alternatives](#update-alternatives)_:

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

### Comando _sudo_

- `-S`: aceita receber entrada via *pipe* (*STDIN*) e espera receber no final da string uma nova linha;
- `-k`: reseta ou não salva a senha no cache;
- `-v`: valida ou atualiza o tempo de cache da senha.

#### Passar Senha de Forma Automática

Alta usabilidade em scripts:
```sh
echo -e "<password>\n" | sudo -S <command>
```

#### Tempo do Cache da Senha

Reseta o tempo de cache:
```sh
sudo -k
```

Rodar o comando sem guardar a senha em cache:
```sh
sudo -k <command>
```

Definir zero cache permanentemente:

1. Edite o arquivo de alterações do sudoers:
	`sudo visudo -f /etc/sudoers.d/users`
1. Colocar o seguinte conteúdo:
	`Defaults:ALL timestamp_timeout=0`

#### Validação da Senha e Refresh do Cache

Dentro de scripts: caso queria validar a senha do usuário sem precisar rodar o sudo com algum comando:
```sh
read -sp 'SUDO password: ' password
echo -e "${password}\n" | sudo -Sv
```

Dentro de script ou mesmo fora: renovar o cache da senha:
```sh
sudo -v
```

#### Arquivo _sudoers_ & Comando _visudo_

- Caso precise de alguma alteração no **sudoers**, crie um novo arquivo dentro de `/etc/sudoers.d/`;
- Sempre edite o arquivo original ou o arquivo de usuário com o comando `visudo`;

Editar o arquivo **sudoers** original:
```sh
sudo visudo
```

Criar um arquivo de usuário:
```sh
sudo visudo -f /etc/sudoers.d/users
```

#### Dar Privilégios de SUDO para Algum Usuário

- Define num arquivo **sudoers**:
```sh
<user> ALL=(ALL) [NOPASSWD:]{ALL|/absolute/path/command[,...]}
```

Ou

- Coloque o usuário no grupo **sudo** (full privileges):
```sh
sudo usermod -aG sudo <user>
```

Para fazer a limitação de comando ou senha separadamente no arquivo **sudoers**:
```sh
<user> ALL=[NOPASSWD:]/absolute/path/command[,...]
```

### Comando _exec_

O comando **exec** "substitui" o shell atual pelo comando passado e caso não seja passado passado nenhum argumento, o próprio shell atual será "substituido" por ele mesmo.

Quando executamos algum comando num shell, geralmente o shell cria um PID para esse comando no roda sob ele, ou seja, um sub processo. O que o comando **exec** faz na verdade é fazer com que o comando passado como argumento herde o PID do shell atual e qualquer _signal_ que o novo processo receber, o processo original (o shell) também receberá, ou seja, quando o novo processo encerrar, ou seja, seu PID morrer, o shell atual também morrerá, pois tem o mesmo PID.

```bash
exec [<options>] [<command>]
```

- Use quando quiser que logo depois do termino do comando o shell atual seja encerrado.
- Use para redirecionar a saída do próprio shell para controles de logs (lembre-se que um script no final também executa num shell).

### Comando *xdotool*

Minimizar tela do terminal corrente:

1. `var=$(xdotool getactivewindow)`
1. `xdotool windowminimize $var`

### Comando _su_

- `-c <command>`: executa o comando no usuário;
- `-s <shell>`: especifica o shell de login;
- `-p`: preserva o ambiente (não funciona com `--login`).

- _Loga_ num shell interativo de algum usuário;
- Não muda pasta de origem;
- Somente troca as variáveis **HOME** **USER** (também **USER** e **LOGNAME** se usuário não for `root`);
- Caso não especifique usuário o padrão é "root";
- Pode haver conflitos de ambiente por não ser um "full login":
```sh
su [<user>]
```

- `-`, `-l` ou `--login` faz o "login completo" no usuário resetando todo o ambiente;
- Muda para a pasta **home** do usuário;
- Evita conflitos de ambiente:
```sh
su - [<user>]
```

- Caso especificado usuário pode passar opções do seu shell de login (se **bash** por exemplo, pode passar `-x` para o _trace_):
```sh
su <user> [<arguments>]
```

_TIPS/TRICKS_:
- Caso queira executar comandos em múltiplas linhas, _heredoc_ não é possível, utilize _line breaks_ (`\` no final da linha).

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

Programas necessários:
```sh
sudo apt install -y ssh
```

#### Arquivos e Pastas

Arquivos de coniguração:
- Arquivo de configuração do usuário (cliente):
    `~/.ssh/config`

- Arquivo geral de configuração do usuário (cliente):
    `/etc/ssh/ssh_config`

- Arquivo geral de configuração do usuário (servidor):
    `/etc/ssh/sshd_config`

Pastas de configuração:
- Pasta de configuração do usuário (cliente):
    `~/.ssh/`

- Pasta geral de configuração:
    `/etc/ssh/`

- Pasta de configuração do usuário (cliente):
    `/etc/ssh/ssh_config.d/`

- Pasta de configuração do usuário (servidor):
    `/etc/ssh/sshd_config.d/`

#### Conexões

- `-p <port>`: troca a porta padrão (que é `22`);
- `-X`: habilita o redirecionamento para _Xorg_;
- `-Y`: desabilita o _xauth_ plugin de segurança (necessário caso erro ao executar apps via `-X`);
- `-f`: não abre o _shell_ interativo e coloca o processo em background (só pode ser usado executando um comando no _host_);
- `-N`: "bloqueia" _RCE_ (Remote Code Execution);
- `-L <local-port>:<dst-host>:<dst-port>`: ???;
- `-i <identity-file>`: informe o caminho da chave privada.

##### Apenas CLI

Conexão:
```sh
ssh [-p <port>] user@host
```

##### Acessar GUI

Programas necessários:
```sh
apt install xauth
```

Conexão:
```sh
ssh -X [-Y] user@192.168.0.1
```

OBS:
- Caso dê algum erro de conexão com interface também pode tentar remover o arquivo `.Xauthority` da _home_:
	`rm -fv ~/.Xauthority`
- Talvez seja necessário definir a variável DISPLAY antes do comando:
	`DISPLAY=:0 ssh [<options>] <host>`

No _server_ (aonde roda o _sshd_) é necessário _setar_ nas configurações:
```conf
X11Forwarding yes
X11DisplayOffset 10
X11UseLocalhost yes
AllowTcpForwarding yes
```

_OBSERVATIONS_:

- Caso tenha _firewall_ habilitado, libere a porta `tcp` para realizar as conexões.

_REFERENCELINKS_:

- <https://manpages.debian.org/unstable/openssh-server/sshd_config.5.en.html>.

#### Segurança

Nos arquivos de configuração para o servidor/_daemon_/`sshd` (sessão [arquivos](#arquivos)):

- Trocar porta de conexão:
	`Port <port>`

- Permitir ou não o acesso direto ao _root user_:
	`PermitRootLogin {yes|no}`

- Permitir ou não senha vazias:
	`PermitEmptyPasswords {yes|no}`

- Quantidade e tempo de inatividade (sem tráfego de pacotes) até tomar _dc_ (_disconect_):
	- Tempo de inatividade cada _request TCPKeepAlive_:
		`ClientAliveInterval <seconds>`
	- Quantidade de _request TCPKeepAlive_ antes do _dc_:
		`ClientAliveCountMax <count>`

- Máximo de conexões simultâneas:
	`MaxSessions <count>`

- Máximo de tentativas de conexão:
	`MaxAuthTries <tries>`

- Permitir ou não autênticação por senha (caso não a autênticação será feita somente via par de chaves):
	`PasswordAuthentication no`

- Bloquear ou liberar determinados IP:
	`{Allow|Deny}Users <user>[@<ip>][ <user>[@<ip>]...]`
	- OBS: corings `*` e `?` podem ser usados.

Arquivo final de exemplo:
```conf
Port 9999
PermitRootLogin no
PermitEmptyPasswords no
ClientAliveInterval 30
ClientAliveCountMax 5
MaxSessions 3
MaxAuthTries 5
PasswordAuthentication no
AllowUsers user1 user2@ip2
DenyUsers user3@ip3
```

##### Firewall

Liberar conexão só para determinado IP:
- UFW: `ufw allow in from <ip> to any port <port> proto tcp`

#### _ssh keys/agents_

Criar ssh key:
```sh
ssh-keygen [-t rsa [-b 4096]] [-t ed25519 [-a 32]]
```

Iniciar um agente *ssh* (quando algo buscar por uma chave é o *ssh-agent* que irá fornecer):
```sh
eval `ssh-agent -s`
```

OBS: Essa forma passada é a forma oficial descrita no manual do *ssh*. outros meios de iniciar o *ssh-agent* seria `ssh-agent -s` ou `exec ssh-agent bash`.

Adicionar chave ao agente:
```sh
ssh-add -k ~/.ssh/id_rsa
```

Verificar as chaves publicas adicionadas no agente:
```sh
ssh-add -l
```

Ver o *pid* e o *socket* do agente:
```sh
printenv SSH_AGENT_PID SSH_AUTH_SOCK
```

Remover *fingerprint* depreciado:
```sh
ssh-keygen [-f /home/${USER}/.ssh/known_hosts] -R <host>
```

Adicionar sua chave num servidor:
```sh
ssh-copy-id -i <identity_file> [-p <port>] <user>@<host>
```

Pegar as chaves pública de um servidor:
```sh
ssh-keyscan [-p <port>] [-t {rsa|,dsa|,ecdsa|,ed25519}] <server_ip> >> ~/.ssh/know_hosts
```

Trocar a senha de alguma chave:
```sh
ssh-keygen -pf ~/.ssh/key_file
```

Gerar chave pública a partir da privada:
```sh
ssh-keygen -yf ~/.ssh/key_file > ~/.ssh/key_file.pub
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
```sh
Host *
	UseKeychain yes
	AddKeysToAgent yes
	IdentityFile ~/.ssh/id_rsa
```

Exemplo de configuração `keychain` (`~/.bash_profile`):
```sh
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

#### Troubleshooting

A versão 9 e posterior do _openssh_ agora usar o `ssh.socket` como gatilho para o daemon (`ssh.service`) e por exemplo a porta é ouvido pelo que diz o `ssh.socket`, nesse caso, o que resolve é desabilitar o `ssh.socket`, remover o arquivo que força a sua chamada e habilitar o `ssh.service`:

1. `sudo systemctl disable --now ssh.socket`
1. `sudo rm -f /etc/systemd/system/ssh.service.d/00-socket.conf`
1. `sudo systemctl enable --now ssh.service`

_pipeline_:
```sh
sudo systemctl disable --now ssh.socket && sudo rm -f /etc/systemd/system/ssh.service.d/00-socket.conf && sudo systemctl enable --now ssh.service
```

_TIPS/TRICKS_:

- _Auto accept_ novo host:
```sh
ssh -o 'StrictHostKeychecking=no' <user>@<host> # or put in the config file
```

- Comando _ssh-keyscan_:
Ele lista as chaves pública do próprio servidor SSH (**sshd**) que são as credenciais validadas na hora de se conectar em um novo _host_ (yes/no).

- Configurar **Host Key** que o servidor entrega (no arquivo de configuração do SSHD):
```sh
HostKey /etc/ssh/ssh_host_<type>_key
```

- Permitir que o cliente aceite mais tipos de **Host Key**'s:
```sh
ssh -o 'HostKeyAlgorithms=+<type>[,<type>...]' <user>@<host> # or put in the config file
ssh -o 'PubkeyAcceptedKeyTypes=+<type>[,<type>...]' <user>@<host> # or put in the config file
ssh -o 'PubkeyAcceptedAlgorithms=+<type>[,<type>...]' <user>@<host> # or put in the config file
```

_OBSERVATIONS_:

- Caso o limite de tentativas de autenticação seja 3 e tenha 3 chaves no agente, quando a conexão for estabelecida, tentará ser feito a autenticação com essas 3 chaves e todas as tentativas serão gastas e caso na primeira tentativa por senha falhar, a conexão será encerrada (se não, teria 3 tentativas por senha a serem tentadas).

- Na fase inicial da conexão SSH o **cliente** requisita a conexão ao **servidor** que por sua vez envia a sua chave pública (sua **Host Key**, que é a chave que é criada automáticamente pelo SSH quando instalado, é a chave do próprio SSHD) para o cliente validar que está se conectando realmente no servidor desejado e não algum impostor. Quando o servidor envia a sua **Host Key** o cliente verificar se ela já consta no `~/.ssh/know_hosts` e caso não, pergunta ao usuário se quer prosseguir com a conexão e então salva a _pub key_ no arquivo?

### Comando _pssh_

- `-i`: _logga_ mais mensagens (verbose);
- `-h /path/to/hosts.list`: especifica o arquivo com todos os hosts ([user@]host[:port]);
- `-H [user@]host[:port]`: passa um único host direto na linha decomando (para fazer testes de mesa?);
- `-t <time>`: _timeout_ de cada host;
- `-l <user>`: especifica o usuário que será logado;
- `-I`: o que comando receber do input, envia como input para a conexão SSH;

Programas necessários:
```sh
sudo apt install -y pssh
```

Executar comando em vários hosts:
```sh
$ parallel-ssh -h ./hosts -t 0 -i "wget -qP ~/path/to/save '<url>'"
# ...
$ parallel-ssh -h ./hosts -t 0 -i 'echo -e "password\n" | sudo -S apt update && echo -e "password\n" | sudo -S apt upgrade -y'
# ...
$ echo 'password' | parallel-ssh -H user@host[.local] -t 0 -iAI 'sudo -S uptime'
```

### Comando _gpg_

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
gpg [--no-symkey-cache] --decrypt /path/to/file.any
```

Importar chave pública para o chaveiro:
```bash
gpg --import /path/to/key_file.any
```

Assinar texto de entrada com chave de forma limpa (sem criptográfia):
```bash
gpg --clear-sign > /path/to/file.asc
```

Assinar texto de entrada com chave "de forma suja" (com criptográfia):
```bash
gpg --sign > /path/to/file.asc
```

Assinar arquivo com chave de forma limpa (sem criptográfia):
```bash
gpg --clear-sign /path/to/file.any
```

Assinar arquivo com chave "de forma suja" (com criptográfia):
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

Tipos de entrada para senha:
- Via _default setting_: _não passe nenhuma opção_
- Via _plain text_: `--batch --passphrase <password>`
- Via _hidden prompt_: `--pinentry-mode loopback`
- Via _STDIN_: `<password> | --batch --passphrase-fd 0` ou `--batch --passphrase-fd 0 <<< <password>`

#### Agente

Formas de recarregar/matar o agente:
1. `gpgconf --kill gpg-agent`
1. `gpgconf --reload gpg-agent`
1. `gpg-connect-agent reloadagent /bye`

_OBSERVATIONS_:

- Todos os redirecionamento de arquivo feitos podem ser substituídos pelo arugmneto do próprio comando (`--output /path/to/file.any`), logo isso implica que se não passado o argumento próprio ou o redirecionamento do arquivo, a STDOUT é a padrão (a tela);

- Todos os argumentos `<key_id>` podem ser substituídos pelos meio de identificação da chave, por exemplos, *e-mail* ou *fingerprint* da mesma;

- Caso precise trocar a interface de dialogo da senha do gpg (que usa o pinentry) execute `update-alternatives --config pinentry` ou para mudar a configuração apenas para o gpg: `pinentry-program /usr/bin/pinentry-{curses|tty} >> ~/.gnupg/gpg-agent.conf`. Outra forma seria desinstalar o "pinentry program" na qual não deseja utilizar mais, exemplo: `apt remove pinentry-gnome`.

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

### Comando _progress_

- `-p <pid>`: monitora o comando pelo _PID_;
- `-c <command>`: monitora o comando pelo nome (ex: cp);
- `-m`: monitora em loop até o comando morrer;
- `-M`: monitor ativo mesmo sem comandos sendo monitorados.

- `<command> & progress -mp "$!"`
- `<command>; progress -mc <command>`
- `<command>; progress -Mc <command>`
- `progress -M [-c <command>]`

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

Criar backup de partição/HD:
```sh
sudo dd if=/dev/sdX[Y] of=/tmp/backup.hd bs=4M
```

Criando um _virtual disk__ (VD):
- `dd if=/dev/zero of=/tmp/vd.img bs=1M count=8`
- `mkfs.vfat -F 32 /tmp/vd.img`
- _`hexdump -C /tmp/vd.img | more`_
- `mount -o loop,rw -t vfat /tmp/vd.img /mnt`
- `cd /mnt/ && touch file.txt; cd -`
- `umount /mnt`

### Comando *sed*

- `-n`: suprime a saída padrão e mostra somente o que casa?

Substituir nova linha por algum caracter:

```bash
sed -z 's/\n/; /g' /path/to/file.txt
```

Buscar as linhas que casam com o primeiro grupo de pattern (o que estiver depois de `s/`) e o retorno será somente o *match* de `(.*)`:

```bash
sed -nE 's/^some_string\(to_match\) (.*)/\1/p' /path/to/file.txt
```

OBS: dessa forma é como se o `sed` buscasse a linha e já a recortasse (equivalente a uma pipeline de `grep | cut | sed | tr`), apesar de que o utilizador pode ficar limitado ao uso de *regex* pois os metacaracteres `.*` serão expandidos e não utilizado para a busca.

Parar na primeira linha casada:
```sh
sed -nE '/<regex>/{s/<regex>/\1/p;q}'
```

OBS: dessa forma é como se o **sed** percorresse as linhas de entrada até encontrar o primeiro `<regex>` descrito no exemplo, depois disso ele executa o que está entro do bloco de condição (`{}`) e como consequência pedimos para ele sair logo em seguida com `;q`.

Fazer a substituição somente nas linhas que casam com o _RegEx_:
```sh
sed '/<pattern>/s/<pattern>/<replacement>/' /path/to/file.txt
```

Imprimir somente um range de linhas:
```sh
sed -n '/<pattern>/,/<pattern>/p'
```

Remover todos caracteres de escape ANSI:
```sh
sed -nE 's/^.*\x1b\[([0-9]+;?)+m(.*)\x1b\[.*$/\2/p'
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

### Comando _curl_

- `-f`: caso *request* retorne algum código de erro, suprime a saida (*body response*);
- `-s`: silência o **curl**, suprime o progresso ou mensagens de erro, porém, mostra a *response* normalmente;
- `-S`: mostra o erro, caso ele ocorra enquanto a saida está silênciada (`-s`);
- `-L`: tentar encontrar a nova *url* caso a que esteja batendo tenha caido;
- `-o`: informa o nome e o local do arquivo de saída;
- `-X`: tipo da request;
- `-H`: _seta_ cabeçalhos da request;
- `-k`: desabilita verificações de segurança (_SSL_ e etc);
- `-v`: modo verboso;
- `-i`: _printa_ o cabeçalho da requisição;
- `-u <user>:<password>`: para fazer autênticação única.

Sintaxe comum para download:
```sh
curl -fsSLo /path/to/save.any <url>
```

Popular *field* no *html* de determinado endereço:
```sh
curl -d "<field-name>=<content>" <url>
```

#### Tipos de _Content-Type_

JSON:
```sh
curl [-H 'content-type: application/json'] -d '{"param1":"value1","param2":"value2"}' <url>
```

URL Encoded:
```sh
curl [-H 'content-type: application/x-www-form-urlencoded'] -d 'param1=value1&param2=value2' <url>
```

- OBS: **Espaços em branco** trocados por "+".

Form Data:
```sh
curl [-H 'content-type: multipart/form-data'] -F 'param1=value1' -F 'file=@/path/to/file.any' <url>
```

XML:
```sh
curl [-H 'content-type: application/xml'] -d '<root><element>value</element></root>' <url>
```

### Comando _wget_

- `-P`: diretório alternativo para salvar o arquivo;
- `-O`: mudar o nome de saida do arquivo;
- `-c`: continua um download que foi interrompido;
- `-r`: baixa pastas de forma recursiva;
- `-np`: se especificar uma pasta de download, não baixa o conteúdo das pastas pai (superiores);
- `--backups 0`: sobrescrever o arquivo caso ele já exista.

Sintaxe comum para download:

```bash
wget [-P /path/to/save/|-O archive-name.any] <url>
```

_OBSERVATIONS_:

- As opções `-P` e `-O` não podem ser usadas juntas;
- Use a opção `-c` na pasta aonde está o arquivo de download interminado.

### Comando _journalctl_

Monitora logs do sistema/_daemons_:

- `-x`: deixa visualmente a saida mais legível (pretty);
- `-f`: fica seguindo/escutando o log (equivalente ao `tail -f`);
- `-u <unit>`: especifique o nome do serviço para _loggar_ (pode especificar múltimos `-u`);
- `-b [<boot>]`: nulo ou `-0` = boot atual, `-1` = último boot e etc;
- `-n <lines>`: imprima as última _n_ linhas;
- <details>
    <summary><code>-p {&lt;priority&gt;|&lt;code&gt;}</code>: filtra por prioridade:</summary>

    - `emerg` (`0`): o sistema está inutilizável;
    - `alert` (`1`): medidas devem ser tomadas imediatamente;
    - `crit` (`2`): condições críticas;
    - `error` (`3`): condições de erro;
    - `warning` (`4`): condições de aviso;
    - `notice` (`5`): condição normal, mas significativa;
    - `info` (`6`): mensagem informativa;
    - `debug` (`7`): mensagens que são úteis para depuração.
- <details>
    <summary><code>-o &lt;format&gt;</code>: formata a saída:</summary>

    - `cat`: inclua apenas mensagens dos logs;
    - `short`: forma padrão;
    - `json`: json raw;
    - `json-pretty`: json indentado;
    - `verbose`: log completo.
- <details>
    <summary><code>--since &lt;time&gt; [--until &lt;time&gt;]</code>: filtra desde algum data ou por um <i>range</i> de data:</summary>

    - `2021-11-23 23:02:15`
    - `2021-05-04`
    - `12:00`
    - `5 hour ago, or 32 min ago`
    - `yesterday`, `today`, `now`
</details>
</details>
</details>

- `--no-pager`: não use um paginador (_less_ por exemplo) e printa tudo diretamente no console;
- `--list-boots`: list o histórico de boots;
- `--disk-usage`: mostra quanto de disco os logs estão consumindo.

Seguir os _logs_ de um serviço (`#`):
```sh
sudo journalctl -xfeu <unit>[.service]
```

Remover limpar os _logs_ (`#`):
```sh
journalctl --rotate --vacuum-size <size> [--unit <unit>.service]
```

### Comando _trap_

Comando _built-in_ do sistema para interceptar os sináis enviado ao _script_.

```bash
#!/bin/bash

# record new command to signals
trap "echo 'captured'" SIGTSTP EXIT

read -p 'Input: ' input
echo "$input"

# reset signals to default
trap - SIGTSTP EXIT
```

Sinais to próprio comando `trap`:
- `EXIT`: executa no final do script, e também quando capturado:
	- 02: **SIGINT** (`ctrl+c`)
	- 15: **SIGTERM**
- `DEBUG`: executa antes de cada comando simples
- `RETURN`: execute no final do script quando for chamado com `.` ou `source`
	- OBS: caso você defina o trap com esse sinal e depois o remova, terá que resetar o shell para que seu efeito passe
- `ERR`: executa depois de cada erro
- `WINCH`: executa quando a janela tem suas dimensões alteradas (diminuida ou aumentada)

_TIPS/TRICKS_:
- Defina `set -o pipefail` para `ERR` conseguir capturar _pipelines_
- Defina `set -E` para `ERR` conseguir "exergar" os erros dentro de funções e _subshells_

### Comando *systemctl*

- --type: filtra pelo tipo de unidade.
- --state: filtra pelo estádo da unidade.

Listar todas as unidades do sistema:
```sh
systemctl list-units [--type service] [--state running]
```

- --reverse: mostra as dependências reversas (quais serviços dependem deste).

Listar todas as dependências de uma unidade:
```sh
systemctl list-dependencies [--reverse] <service_name>.service
```

Caso o sistema não tenha voltado do congelamento, pode-se executar:
```sh
systemctl thaw '*'
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

Lista o UID, GID e os grupos do usuário corrente:

```bash
id
```

Retorna somente o UID do usuário corrente:

```bash
id -u
```

Retorna somente o GID do usuário corrente:

```bash
id -g
```

Retorna o nome do corrente:

```bash
id -un
```

Retorna o nome do usuário pelo UID passado:

```bash
id -un <uid>
```

### Comando *rsync*

Sintaxe:

```bash
rsync [<options>] </folder/origin_1> </folder/origin_2/> </file/origin_3> <destiny>
```

- `-r`: modo recursivo;
- `-v`: modo verboso;
- `-h`: aumenta a legibilidade;
- `-a`: aplica recursividade, preserva permissões, usuários, grupos e timestamp (*inode*);
- `-u`: skipa arquivos no qual o destino é mais novo;
- `-z`: comprime os dados trafegados deixando o tamanho do *payload* menor porém consumindo mais processamento;
- `-P`: mostra o progresso;
- `-e 'ssh -p <port>'`: mudar a porta padrão (22) de conexão;
- `--exclude=<pattern>`: exclui arquivos ou diretórios pelo padrão passado aceitando *glob* ou de forma absoluta (*regex*?);
- `--delete`: caso algum arquivo da fonte não exista mais no destino, no destino também é excluído.

Exemplo:
```sh
rsync -auhv --include=/.files-* --exclude={file1,folder2,.*} --exclude=*.any src/file/one.any src/folder/two/ /tmp/dst/folder/backup/
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

Entra no _sandbox_ ou executa algum comando nele:

```bash
firejail --join=<sandbox> [<command> <args>]
```

Copiar algo do _host_ para o _sandbox_:

```bash
firejail --put=<sandbox> /path/host/to/file.any /path/sandbox/to/save/file.any
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

### Comando _nslookup_

Resolver _hostnames_/domínios:

```bash
nslookup [-type=PTR] <hostname/doamin>
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

Resolver domínio:

```bash
dig [+short] [@<ip-dns>] <domain-to-search> [<record-type>]
```

Verificar _nameservers_ do domínio:

```sh
dig +trace [@<ip-dns>] <domain-name>
```

Encontrar domínio pelo IP:
```sh
dig [+short] [@<ip-dns>] -x <ip-server>
```

_OBSERVATIONS_:

- O comando **dig** aceita os tipos de registro `A`, `MX` e `SOA`.

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

- `:-i`: _case insensitive_ para buscas simples;
- `:-I`: _case insensitive_ para buscas também com padrões;
- `:m`: define uma marca para a página atual;
- `'<mark>`: vai para a marca;

### Comando _read_

- `-r`: traz o texto _raw_ (não interpreta caracteres de escape, "\n" por exemplo);
- `-e`: Na prática, não interpreta por exemplo teclas de movimentação, ou seja, consegue andar pelo texto com as setas (e consequentemente esses caracteres não são capturas pelo **read**);
- `-t`: _Seta_ um _timeout_ para cancelamento do comando;
- `-a`: A entrada será um _array_, ou seja, a cada espaço, um novo índice;
- `-p`: Imprime uma mensagem antes do cursor;
- `-i`: Caso utilizando ReadLine (opção `-e`), coloca uma mensagem padrão na caixa de _input_;
- `-n <chars>`: Retorna depois de _N_ caracteres e caso receba o delemitador de linha (tecla _return_) antes, não o inclui no _input_;
- `-N <chars>`: Igual o `-n` porém, inclui o delimitador de linha caso retorne antes.

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

Gravar a tela:
```sh
ffmpeg -f x11grab -y -framerate 60 -s "$(xdpyinfo | grep dimensions | awk '{print $2}' )" -i "${DISPLAY:-:0.0}" -c:v libx264 -preset superfast -crf 21 "$(date +'%Y-%m-%d_%H-%M-%S').mp4"
```

### Comando _date_

_Printa_ o formato padrão de hora com o timezone definido pelo seu sistema:
```sh
date
```

_Printar_ saida formatada (yyyy-mm-dd hh:mm:ss):
```sh
date '+%Y-%m-%d %H:%M:%S'
```

_Printar_ os segundos desde a Época (1970-01-01 00:00 UTC)
```sh
date '+%s'
```

Converter segundos (desde a Época) em data:
```sh
date --date='@<seconds>' '+%F %T'
```

Passar fuso horário específico:
```sh
# timezone name
TZ='Asia/Tokyo' date

# or abbreviations
TZ='EST' date
```

### Comando _ncal_

- `-B`: mostra os meses **antes** desse (incluindo o atual);
- `-A`: mostra os meses **depois** desse (incluindo o atual);
- `-3`: mostra junto mês anterior e o próximo;
- `-j`: mostra o número do dia (em relação ao ano);
- `-y`: mostra todos os meses do ano;
- `-w`: mostra junto a contagem das semanas;
- `-m`: mostra um mês específico.

Calendário _CLI_:

```sh
ncal [-B|A{count}] [-3] -b [-jyw] [-m <months>] [<year>]
```

### Comando _paste_

Coloca linhas ao lado:

```sh
paste <(<command>) <(<command>)
```

### Comando _while_

_TIP/TRICK_:
```sh
cat file.list | while read line; do
    sleep .1
    echo "$line"
done
```

### Comando _mount_

- `-o` opções comuns:
    - `rw/ro`
    - `showexec`
    - `allow_other`
    - `user`
    - `uid=<uid>`
    - `gid=<gid>`

Montar arquivo **iso** (**#**):
```sh
mount -o ro -t iso9660 /path/to/img.iso /mnt
```

Montar partição **ext4** e manipular com usuário regular (**#**):
```sh
mount -o user /dev/sdXY /mnt
bindfs -u `id -u` -g `id -g` /mnt ~/disk

# or

mount /dev/sdXY /media/disk
chown -Rv `id -un`:`id -gn` /media/disk
```

_OBSERVATIONS_:
- Sistemas de arquivos como **FAT32** deixam tudo como o esperado;
- Sistemas de arquivos como **EXT4** deixam todos os arquivos como root pois esse sistema de arquivo não tem suporte as opçoes `uid` e `gid` por exemplo;
- Sistemas de arquivos como **EXFAT** deixam tudo como o esperado;
- Sistemas de arquivos como **NTFS** deixam as permissões full `777` de todos os arquivos independente das opções de montagem e de comandos como `chmod` pois esse sistema de arquivos não segue as mesmas especificações UNIX de grupos e permissões.

### Comando _declare_

Criar array associativo:
```sh
declare -A ARRAY=(
    [index1]=value1
    [index2]='value 2'
)
```

### Comando _ftp_

Programas necessários:
```sh
apt install ftp
```

Se conectar no servidor:
```sh
ftp [ftp://][<user>@]<ip>[:<port>]/
```

### Comando _filebrowser_

Programas necessários:
```sh
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
```

Iniciar servidor:
```sh
filebrowser [-a <ip>] [-p <port>] -r /path/to/share/folder
```

### Comando _screenkey_

Programas necessários:
```sh
apt install screenkey
```

Mostrar as telcas que estão sendo digitadas:
```sh
screenkey -m -t 1 -s small -g 1323x853+334+180 --compr-cnt 1 --no-whitespace --vis-shift
```

### Comando _modprobe_

Verificar se um modolo já está carregado:
```sh
modprobe --dry-run --first-time <module> && echo "not loaded" || echo "loaded"
```

### Comando _xsetroot_

Resetar o background padrão do sistema:
```sh
xsetroot
```

### Comando _gifwrap_

Ver gifs pelo terminal:
```sh
gifwrap -f /path/to/image.gif
```

OBS: deixe o menor zoom possível do terminal.

### Comando _slop_

- `-q`: silencia a saída;
- `-f`: formata a saída.

Programas necessários:
```sh
sudo apt install slop
```

Retorna a área selecionada no estilo `x,y+width+height` (`left,top+right+bottom`):
```sh
slop
```

Formatando a saída:
```sh
# %x: x axis
# %y: y axis
# %w: width
# %h: height
# %g: geometry (%wx%h+%x+%y)
# %i: window id
# %%: literal '%'
slop -f '%x %y %w %h %g %i'
```

_OBSERVATIONS_:
- ver o man do comando para mais detalhes e dicas.

### Comando _realpath_

- `-s`: links simbólicos não são expandidos;
- `-z`: troca nova linha por nulo;
- `--relative-to=<folder>`: retorna o caminho relativo para chegar no arquivo por dentro da pasta passada.

Retorna o caminho absoluto dos arquivos passados como argumento:
```sh
realpath [<options>] <file> [<file> ...]
```

OBS: por padrão se o arquivo for um link simbólico, será expandido.

### Comando _apropos_

Pesquisar manpages para determinado assunto que case:
```sh
apropos <something>
```

### Comando _sort_

- `-m`: mescla os arquvios antes de sortear;
- `-t`: especifica o delimitador;
- `-k`: especifica por campo sortear.

Organizar arquivos por ordenação:
```sh
sort [-m] [-t <char>] [-k <field>] /path/to/sorting-file.txt[ /path/to/another.txt...] [>/path/to/save/sorted-file.txt]
```

### Comando _dmesg_

- `-w`: modo _tail_;
- `-H`: mais legível para humanos;
- `-C`: limpa o cache do **dmesg**;
- `-c`: limpa o cache do **dmesg** depois de printar na tela.

Comando:
```sh
dmesg [<options>]
```

_TIPS/TRICKS_:
- Antes de limpar o histórico salve ele: `dmesg -H > /tmp/dmesg_$(date '+%F_%T').log`

### Comando _iptables_

Listar as regras:
```sh
iptables -S
```

### Comando _tcpdump_

- `-i <ifname>`: interface de rede a ser monitorada;
- `-G <seconds>`: quanto tempo ficará capturando;
- `-W <count>`: quantas vezes capturará;
- `-w /path/to/tcpdump-%F_%T.pcap`: arquivo de saída do tipo _packet capture_;
- `host <id/domain> [or <id/domain>...]`: _ip_ ou domínio a ser monitorado;

Instalação:
```sh
apt install tcpdump
```

Monitorar tráfego de rede:
```sh
tcpdump -i eth0 -G <seconds> -W <count> -w 'tcpdump_%F-%T.pcap' host <ip/domain> or host <ip/domain>
```

### Comando _timedatectl_

Verificar infos de data e hora e se tudo esta ok:
```sh
timedatectl status
```

Sincronizar RTC com UTC (de onde a info é buscada, não altera fuso):
```sh
timedatectl set-local-rtc 0
```

OBS: para reverter faça: `timedatectl set-local-rtc 1`

Listar os timezones:
```sh
timedatectl list-timezones
```

Definir timezone no sistema:
```sh
timedatectl set-timezone <timezone/abbreviation>
```

Timezones com abreviações:
```sh
for timezone in `timedatectl list-timezones`; do echo "$timezone (`env TZ="$timezone" date +'%Z'`)"; done
```

Listar todas as abreviações dos timezones:
```sh
timedatectl list-timezones | xargs -I '{}' env TZ='{}' date +'%Z' | sort -u
```

### Comando _sleep_

Sintaxe:
```sh
sleep <number>[s|m|h|d] [<number> ...]
```

Comando:
```sh
# sleep 1 minute and 30 seconds
sleep 1m 30s
```

_OBSERVATIONS_:
- cada valor de tempo passado para o sleep será somado;
- "s" (segundos) é o padrão.

### Comando _pandoc_

- `-f {markdown|html}`: especifíca o tipo de arquivo de entrada;
- `-t {markdown|pdf|plain|html}`: especifíca o tipo de arquivo de saía;
- `-o /path/to/output.{md|pdf|txt|html}`: especifíca o caminho do arquivo de saída;
- `--pdf-engine=pdflatex`: especifíca a _engine_;
- `--template=<template>.tex`: especifica o caminho para o arquivo de template;
- `--toc`: gera a tabela de conteúos(sumírio);
- `-N`: faz títulos e sub títulos numerados;
- `--highlight-style={tango|breezedark}`: define o tema dos _highlights_ (formatações com craze);
- `--list-highlight-styles`: lista os estilos disponíveis;
- <details>
	<summary><code>-V &lt;option&gt;</code>: informa opções para a <i>engine</i>:</summary>

	- `geometry:margin=1in`
	- `fontfamily:{helvet|dejavu}`
	- `hyperlink=true`
	- `colorlinks=true`
</details>

Programas necessários:
```sh
apt install pandoc
```

#### Converter MD para PDF

Programas necessários:
```sh
apt install texlive-latex-base [texlive-latex-extra] [texlive-fonts-extra]
```

Comando:
```sh
pandoc [<options>] /path/to/input.md
```

<details>
<summary>&gt;Template Example&lt;</summary>

```tex
\documentclass{article} % specify document type
\usepackage[hidelinks]{hyperref} % add hiperlinks support
\usepackage{tocloft} % allow changes in Content of Table (TOC) table
\usepackage{mdframed} % add box shadows support
\usepackage[margin=1in]{geometry} % set 1 inch margins
\usepackage{helvet} % uses Helvetica font
\renewcommand{\familydefault}{\sfdefault} % define sans serif as default

% includes syntax highlighting definitions if necessary
$if(highlighting-macros)$
$highlighting-macros$
$endif$

% pandoc internal command to adjust the distance between list items
\providecommand{\tightlist}{%
  \setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}

\begin{document} % begin of document

\tableofcontents % generetes the table of contents
\clearpage % jump to a new page

$body$ % body of document

\end{document} % end of document
```
</details>

_REFERENCELINKS_:

- [Pandoc Manual](https://pandoc.org/MANUAL.html);
- [LATEX Fonts](https://tug.org/FontCatalogue/).

### Comando _ranger_

- Deselecionar todos itens selecionados:
    `uv`
- Copiar o caminho absoluto do item em foco:
    `:shell -w xclip -r -sel clip <<< '%d/%f'`

#### (Des)Compressão

Compactar:
    _selecionar os arquivos_ > `!` > `[-w] zip [<options>] compressed.zip %s`

Descompactar:
    _seleciona o arquivo_ > `!` > `[-w] unzip [<options>] %s`

Descompactar múltiplos:
    _selecionar os arquivos_ > `!` > `[-w] for archive in %s; do unzip [<options>] "$archive"; done`

### Comando _findmnt_

Lista informações de pontos de montagem:
```sh
findmnt -T /mount/path
```

### Comando `last`

Lista o histórico de _logins_ no host:
```sh
last [--fulltimes] [--ip] [--limit <count>] [--system]
```

### Comando `getfacl`

Programas necessários (`#`):
```sh
apt install acl
```

Apresentar de forma bonito os proprietários e permissões:
```sh
getfacl /path/to/file/or/folder[/*]
```

### Comando `base64`

Tanto para codificar quanto para decodificar é necessário passar o dado via **arquivo** ou **entrada padrão**.

- `-d`: decodifica base64 para o original;
- `-w <cols>`: número de colunas na saída, `0` para em uma única linha.

(De)Codificar:
```sh
base64 [-w <cols>] [-d] /path/to/file.any

# or

base64 [-w <cols>] [-d] <<< <data>

# or

<data> | base64 [-w <bols>] [-d]
```

### Comando _xcompmgr_

Programas necessários (**$**):
```sh
apt install xcompmgr
```

Executar o compositor:
```sh
xcompmgr [-cfn]
```

### Comando _xwininfo_

Pegar informações de alguma janela:
```sh
xwininfo
```

### Comando _lsblk_

Pegar info a partir do caminho do _device_:
```sh
lsblk -no <column> /dev/sdXY
```

Saber se o disco -e **HDD** ou **SSHD**:
```sh
lsblk -do name,rota
```

- `0`: para SSD
- `1`: para HDD

### Comadno _isntall_

Copiar arquivos para o destino já criando as pastas:
```sh
install -Dt </path/to/folder/> </path/to/file1>[ ...]
```

### Comando _diff_

Realizar o _diff_ a nível de palavras:
```
diff -u /path/to/file1.any /path/to/file2.any | colordiff | diff-highlight
```

OBS: Nesse caso o _diff-highlight_ referente é [esse](#configurar-diff-highlight-do-git).

### Comando _mokutil_

Checar se _secure boot_ está ativo:
```sh
mokutil --sb-state
```

### Comando _gocr_

Programas necessários (**#**):
```sh
apt install gocr
```

Extrair textos de imagens (**$**):
```sh
gocr /path/to/image/file.any
```

### Comando _dmidecode_

Saber o número de série do dispositivo (**#**):
```sh
dmidecode -s system-serial-number
```

### Comando _mtr_

- `-4`: somente IPv4
- `-6`: somente IPv6
- `-r`: entra em _report mode_, usado com `-c`, não mostra output e no final dos ciclos mostra o resumo
- `-w`: não resume os nomes de domínios
- `-t`: ao invés de chamar _GUI_ ou _TUI_, reporta diretamente no console
- `-g`: força usar GTK
- `-C`: _output_ como CSV
- `-j`: _output_ como JSON
- `-c <count>`: quantidade de ciclos
- `-i <seconds>`: quantidade de segundos entre cada ICMP Echo
- `-s <packetsize>`: tamanho do pacote em bytes

Monitorar o _TTR_ de todos os _hopes_:
```sh
mtr [<options>] domain.any
```

### Comando _pwgen_

- `-s`: Senha completamente randômica
- `-c`: Garante letras maúsculas e minúsculas
- `-n`: Garante números
- `-y`: Inclui caracteres especiais

Programas necessários (**#**):
```sh
apt install pwgen
```

Gerar senha aleatória (**$**):
```sh
pwgen [-scny] <char-count> <passwords-count>
```

### Comando *xclip*

- `-f`: printa o conteúdo além de enviar para a área de transferências;

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

### Comando `podman`

Erro:
```
... try resetting the pause process with "podman system migrate"
```

Ocorre depois do host reiniciar ou suspende, o podman perde a sessão, para resolver habilite a permanência de login:
```sh
loginctl enable-linger
```

Verifique se retorna "yes":
```sh
loginctl user-status | grep -m1 'Linger'
```

### Usuários e Grupos

Adicionar usuário (mod):
```sh
adduser [<options>] <user>
```

Adicionar usuário (vanila):
```sh
# creates the user (and add your groups)
useradd -m [-G <group>[,<group>...]] <user>
# sets a new password for the new user
passwd <user>
```

Remover usuário (mod):
```sh
deluser [<options>] <user>
```

Adicionar usuário a um ou muitos grupos:
```sh
usermod -aG <group>[,<group>...] <user>
```

OBS: Omitindo a flag `-a` você deixará o usuário somente com os usuários especificados e todos os outros grupos serão removidos.

Remover usuário de um grupo:
```sh
gpasswd -d <user> <group>
```

#### Comando _newgrp_

Caso tenha feito a adição de um usuário a um grupo e não possa reiniciar a sessão para que a modiciação seja aplicada o comando `newgrp` irá recarregar a sessão do _shell_ atual do usuário corrente com o grupo específicado:
```sh
newgrp <group>
```

### Família _kill_

- `pid`: _process id_.

#### Comando _kill_

- `-0`: verifica se o processo está vivo.

Envia _signal's_ ao processo:
```sh
kill [[-s] <siginal>] [-0] <pid>
```

#### Comando _killall_

Envia _signal's_ a todos os processos com o nome:
```sh
killall [[-s] <siginal>] <name>
```

#### Comando _pkill_

- `-u`: faz o _match_ para processos de um usuário específico;
- `-f`: faz o _match_ do _pattern_ não somente com o nome do comando executado mas inclusive com toda a sua linha de argumentos.

Envia _signal's_ a todos os processos que casam com o _RegEx_:
```sh
pkill [-f] [-u <user>] '^string'
```

### Família _ps_

#### Comando _ps_

- `-a`: lista todos os processos;
- `-ux`: lista os processos do usuário atual;
- `-f`: lista a linha completa do comando;
- `-p <pid>`: lista um único processo pelo seu _PID_;
- `-C <name>`: lista os processos correspondentes ao nome;
- `-o <output>`: especifica as colunas de saída;
- `--no-headers`: não mostra os cabeçalhos na saída.

Lista os _PID's_ e informações dos processos:
```sh
ps [-aux] [-f] [-p <pid>] [-C <name>]
```

#### Comando _pgrep_

- `-l`: mostra também o nome do processo.
- `-f`: faz o _match_ do _pattern_ não somente com o nome do comando executado mas inclusive com toda a sua linha de argumentos.

Lista os _PID's_ dos processos que casam com o _RegEx_:
```sh
pgrep [-fl] <pattern>
```

#### Comando _pstree_

Exibe os processos em forma de árvore:
```sh
pstree
```

_TIPS/TRICKS_:

Buscar por somente um processo:

- Da forma padrão com `grep`:
	`ps -aux | grep <pattern>`

- Via _proc file_:
	`cat /proc/<pid>/cmdline`

- Com `pgrep`:
	`ps -fp $(pgrep '<pattern>') --width $(("$(tput cols)"*"$(tput lines)"))`

### Saber meu *ip externo*

Com *curl* na *ipecho*:

```bash
curl -L http://ipecho.net/plain
```

### Busca de arquivos e diretorios

#### Comando *find*

Sintaxe:
```sh
find ./ -name file.txt
```

Limitando a recursividade:
```sh
find ./ -maxdepth 3 -name file.txt
```

Excluir determinado path da busca:
```sh
find ./ -path ./some_path -prune -o -name '*file*'
```

Excluir vários paths da busca:
```sh
find ./ \( -path ./first/path -o -path ./second/path \) -prune -o -name '*file*'
```

Buscar por arquivos e excluílos:
```sh
find ~/ -not \( -path '*/.*' -prune -o -path '*/folder' -prune \) -iname '*confli*' -exec rm -i '{}' \; 2>&-
```

Excluir vários paths da busca e limitar a recursivedade:
```sh
find ./ -maxdepth 2 \( -path ./first/path -o -path ./second/path \) -prune -o -name '*file*'
```

Buscar por links simbólicos quebrados e excluílos:
```sh
find ./ -xtype l -exec rm -fv '{}' \;
```

Find `printf`:
```sh
find ./ -printf '%C+\t%p\n'
```

Sair na primeira ocorrência:
```sh
find ./ -name file.any -print -quit
```

_OBSERVATIONS_:

- pastas para o parâmetro `-path` não pode contem `/` no final;
- para qualquer tipo de _match pattern_ (inclusive para diretórios) é aceito _wildcards_, exemplo: `find ./ \( -path '*/folder' -o -path '*/.folder' \) -prune -o -name '*f?le*'`;
- utilizando `\;` para finalizar o `find` fará com que cada ocorrência seja um novo comando porém com `\+` fará a concatenação, como: `<command> <arg1> <arg2>...`

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
tar -zcvf target-folder.tar.gz /path/file/to/compact.any /path/folder/to/compact/
```

Descompactar de `.tar.gz`:

```bash
tar [-C /path/folder/to/decompress/] -zxvf /path/to/compressed/folder.tar.gz
```

##### _.tar.xz_

Compactar em `.(tar|tbz2).(xz|bz2)`:

```bash
tar -cvf target-folder.tar.gz /path/file/to/compact.any /path/folder/to/compact/
```

Descompactar de `.(tar|tbz2).(xz|bz2)`:

```bash
tar [-C /path/folder/to/decompress/] -xvf /path/to/compressed/folder.tar.xz
```

##### _.tar.\*_

Ver conteúdo de `.tar.*`:

```bash
tar -tf /path/to/compressed/folder.tar.gz
```

#### Comando _zip/unzip_

- `-d`: especifica a pasta para ser descompactado;
- `-l`: listar o conteúdo do arquivo compactado;
- `-r`: faz ser recursivo a compressão (caso não passe o glob `*` na pasta especificada);
- `-y`: segue o link simbólico e zipa o arquivo original;
- `-e`: criptografar o arquivo compactado;
- `-b <path>`: especifica o diretório para o arquivo temporario (de cache) do zip;
- `-i <pattern> [<pattern> ...]`: inclue arquivos com o padrão;
- `-x <pattern> [<pattern> ...]`: exclui arquivos com o padrão.

Compactar:
```sh
zip [-b /tmp] [-ry] target-folder.zip /path/file/to/compact.any /path/folder/to/compact/*
```

Descompactar:
```sh
unzip [-d /path/to/decompress/] /path/to/compressed/folder.zip
```

Ver o conteúdo:
```sh
unzip -l /path/to/compressed/folder.zip
```

Exemplos de padrões e inclusão/exclusão:
- Exclua todos os arquivos que terminam com ".any" de todas as pastas em todos os níveis:
	- `\*.any`

- Exclua todos os arquivos que terminam com ".any" de todas as pastas que tenham o nome em todos os níveis:
	- `\*/folder/\*.any`

- Exclua todas as pastas com o(s) nome(s) em todos os níveis:
	- `\*/folder/\*`
	- `\*/folder-{a,b}/\*`

- Exclua a pasta com o nome a partir da sua raiz (pastas a serem compactadas):
	- `/depth0/folder/*`

#### Comando _xz_

- `-z`: para criar arquivos compactados;
- `-d`: para descompactar arquivos;
- `-k`: descompacta o arquivo e ainda mantem um cópia do compactado;
- `-v`: modo verboso (printa na tela o processamento).

Compactar:

```bash
xz -z [-v] /path/file/to/compact
```

Descompactar:

```bash
xz -d [-kv] /path/to/file/compressed.xz
```

#### Comando _7z_

- `x`: para descompactar arquivos.

Descompactar:

```bash
7z x /path/to/file/compressed.any
```

#### Comando _gzip_

- `-d`: para descompactar arquivo;
- `-k`: descompacta o arquivo e ainda mantem um cópia do compactado;
- `-v`: modo verboso (printa na tela o processamento).

Compactar:

```bash
gzip /path/file/to/compact
```

Descompactar:

```bash
gzip -d [-kv] /path/to/file/compressed.gz
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
# or
sudo jmtpfs /mount/point -o allow_other,auto_unmount
```

Desmontar:

```bash
sudo umount /mount/point
# or
sudo fusermount -u /mount/point
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

- `X`: letra do disco;
- `Y`: número da partição;
- `-m`: memória RAM em MB;
- `-smp`: núcleos do processador;
- `-nographic`: executa em _background_.

Instalação:

```bash
sudo apt install -y qemu-system-x86 qemu-utils
```

Criar disco:

```bash
qemu-img create -f qcow2 /path/to/disk.qcow2 15G
```

#### BIOS (Legacy)

Subir VM:

```bash
qemu-system-x86_64 -enable-kvm -m 2048 -smp 2 -hda {/path/to/disk.qcow2|/dev/sdX} -boot d -cdrom disk_image.iso
```

Iniciar o disco:

```bash
qemu-system-x86_64 -enable-kvm -m 2048 -smp 2 -hda {/path/to/disk.qcow2|/dev/sdX}
```

#### UEFI

Dependência:

```bash
sudo apt install ovmf -y
```

Subir VM:

```bash
qemu-system-x86_64 -enable-kvm -bios /usr/share/ovmf/OVMF.fd -m 2048 -smp 2 -hda {/path/to/disk.qcow2|/dev/sdX} -boot d -cdrom disk_image.iso
```

Iniciar o disco:

```bash
qemu-system-x86_64 -enable-kvm -bios /usr/share/ovmf/OVMF.fd -m 2048 -smp 2 -hda {/path/to/disk.qcow2|/dev/sdX}
```

#### Usar Dispositivo Externo Como Disco

```sh
sudo qemu-system-x86_64 -enable-kvm -m 2048 -smp 2 -drive file=/dev/sdX
```

#### Conectar Via SSH (configurar _network_ entre _host_ e _guest_):

```bash
qemu-system-x86_64 -enable-kvm -m 2048 -smp 2 -hda {/path/to/disk.qcow2|/dev/sdX} -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::2222-:22
```

#### Conectar Outro VD ou Um HD Real

```sh
# other qcow2 VD
qemu-system-x86_64 -enable-kvm -m 2048 -smp 2 -hda {/path/to/disk.qcow2|/dev/sdX} -drive file=/path/to/disk.qcow2,format=qcow2,if=virtio
# for VD created by dd
qemu-system-x86_64 -enable-kvm -m 2048 -smp 2 -hda {/path/to/disk.qcow2|/dev/sdX} -drive file=/path/to/disk.img,format=raw,if=virtio
# for HD partition (HDD or pendrives)
qemu-system-x86_64 -enable-kvm -m 2048 -smp 2 -hda {/path/to/disk.qcow2|/dev/sdX} -drive file=/dev/sdXY,format=raw,if=virtio
```

#### Compartilhar Pasta do Host com Guest

- Compartilhe a pasta com a VM:
```sh
qemu-system-x86_64 -enable-kvm -m 2048 -smp 2 -hda {/path/to/disk.qcow2|/dev/sdX} -virtfs local,path=/path/to/shared-folder,mount_tag=shared-folder,security_model=passthrough
```

- Monte a pasta por dentro da VM:
```sh
mount -o trans=virtio -t 9p <mount-tag> /mnt
```

#### Clonagem de Disco Virtual

```bash
qemu-img convert -pO qcow2 /path/to/base-disk.qcow2 /path/to/output-disk.qcow2
```

#### Troubleshooting

Executar qemu _logado_ como root:
1. Liberar acesso no `xhost` (**$**):
    `xhost +si:localuser:root`
1. Executar comando passando a variável `DISPLAY`:
    `DISPLAY=:0 <command>`

### Wi-fi CLI

#### Pacote `network-manager`

Programa necessário (`#`):
```sh
apt install network-amanger
```

##### Comando `nmcli`

Listar redes wifi dispníveis (`$`):
```sh
nmcli device wifi list [ifname <network-interface>]
```

Conectar em rede simples (comum WPA2) (`$`):
```sh
nmcli device wifi connect <wifi-name> password <password> [ifname <network-interface>]
```

Conectar em rede empresarial (_enterprise_ WPA2-EAP) (`$`):
```sh
nmcli connection add type wifi connection-name <connection-name> ssid <wifi-name> [ifname <network-interface>]
nmcli connection edit id <connection-name>
nmcli> set ipv4.method auto
nmcli> set wifi-sec.key-mgmt wpa-eap
nmcli> set 802-1x.eap peap
nmcli> set 802-1x.phase2-auth mschapv2
nmcli> set 802-1x.identity <username>
nmcli> set 802-1x.password <password>
nmcli> set 802-1x.ca-cert <certificate>
nmcli> set 802-1x.anonymous-identity <anonymous-identity>
nmcli> save
nmcli> activate
```

- OBS: O nome da conexão (propriedade `connection-name`) pode ser literalmente qualquer nome e serve somente para referenciar a configuração de alguma conexão. Acontece que os gerenciadores de rede sempre colocam a `connection-name` o mesmo nome do **SSID** (nome da rede _Wi-Fi_) de forma automática, porém, a `connection-name` pode ser qualquer um.

Simplesmente trocar de rede (`$`):
```sh
nmcli device wifi connect <ssid>
```

###### VPN

Adicionar (configurar) conexão _VPN_ (`$`):
```sh
nmcli connection import type <vpn-type> file /path/to/vpn-file.any
```

- OBS: Depois basta se conectar com `nmtui-connect`.

_OBSERVATIONS_: Para **OpenVPN** instale o pacote `network-manager-openvpn`.

#### Comando *nmap*

Programas necessários (`#`):
```sh
apt install nmap
```

Saber _IP's_ conectados a minha rede:
1. Saiba primeiro seu _IP_ (`$`):
	`ip address`
1. Coloque no `nmap` (`#`):
	`nmap -sA 192.168.0.1/24`

Saber quais portas estão sendo usadas por qual serviço na sua máquina (`#`):
```sh
nmap -sV localhost
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

### Manipulação de Arquivos de Texto e Mídia

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

#### Comando _ffmpeg_

Instalação:
```sh
apt install ffmpeg
```

MKV to MP4:
```sh
ffmpeg -i /path/to/video/input.mkv -codec copy /path/to/save/output.mp4
```

VIDEO to GIF:
```sh
ffmpeg -i /path/to/video/input.any /path/to/save/output.gif
```

#### Tool Kit _mkvtoolnix_

Instalação:
```sh
apt install mkvtoolnix
```

Mesclar arquivos mp4 (depois é necessário converter de volta para mp4):
```sh
mkvmerge -o output.mp4 multi-monitors-0.mp4 \+ multi-monitors-1.mp4
```

### Saída dos comandos lado a lado

```sh
paste <(<command>) <(<command>) | column -ts $'\t'
```

### Alias Inside Shell Script's

Isso não é possível de ser feito pois quando um script é executado, nele não é carregado um ambiente de shell, muito menos o atual, portanto o shell não reconhecerá o alias.

#### `expand_aliases` Approach

Nesse caso usa-se:
1. `shopt -s expand_aliases`
1. `. ~/.bashrc`

Porém, para isso terá que tirar a validação de shell não interativo no início do seu `.bashrc`.

#### `BASH_ENV` Approach

Defina a variável `BASH_ENV` na linha de execução do script:
- `BASH_ENV=/path/to/file-load <script>`

#### Alias Approach

Define no seu shell rc o alias:
```sh
alias sudo='sudo '
```

### Function Within Sudo

Execute com `declare -f` e `bash -c`:
```sh
sudo bash -c "`declare -f <function>`; <function> [args]"
```

### QRCode Creating and Reading

Programas necessários:
```sh
sudo apt install -y qrencode zbar-tools
```

#### `qrencode`

- `-v`: versão do tipo de QR Code (quanto maior, mais pixels);
- `-s`: tamanho dos pixels do QR Code;
- `-l`: "aumenta a quantidade de pixels";
- `-t`: tipo do arquivo de saída;
- `-m`: largura das bordas da imagem;
- `-o`: caminho do arquivo gerado.

Gerar QR Code:
```sh
qrencode [-v 5] [-s 10] [-l H] -[t {PNG|SVG}] [-m 3] -o ./qrcode.png '<url/email/phone>'
```

#### `zbar*`

- `-q`: silencia o log na saída;
- `--raw`: mostra diretamente/somente o contéudo de fato do QR Code.

Ler QR Code de uma imagem:
```sh
zbarimg [--raw] [-q] ./qrcode.png
```

Ler QR Code da câmera:
```sh
zbarcam [--raw] [-q]
```

### Unset de Variáveis/Funções/Aliases

Variáveis:
```sh
unset <variable>
```

Funções:
```sh
unset -f <function>
```

Aliases:
```sh
unalias <alias>
```

### Recuperar Arquivos de um `rm` Comando

1. SE for um arquivo editavel:
    1. Pegue pid do na segunda coluna e o descritor de arquivo na quarta coluna:
        `lsof | grep '/path/to/file'`
    1. Copie o arquivo direto do descritor:
        `cp /proc/<pid>/fd/<fd> /path/to/restored/file`
1. Desmonte imediatamente o sistema de arquivos ou remonte somente leitura:
    - Para desmontar:
        `umount /dev/sdXY`
    - Para remontar somente leitura:
        `mount -o remount,ro /dev/sdXY`
1. Faça backup da partição:
    `dd if=/dev/sdX[Y] of=/tmp/backup.hd bs=4M`
1. <details>
    <summary>Execute a recuperação</summary>

    - <details>
        <summary>Caso <code>ext4</code></summary>

        - `extundelete --restore-all {/dev/sdX[Y]|/path/to/backup.hd}`\
        OBS: Veja outras opções do comando com:
            `man extundelete`
    </details>
</details>

### Descobrir Hostnames Com Seus IP's

Programas necessários:
```sh
apt install arp-scan avahi-daemon avahi-utils
```

Comando:
```sh
arp-scan --localnet --quiet --format='${ip}' | grep -E '^([[:digit:]]{1,4}\.?)+$' | xargs avahi-resolve -va
```

### Pegar IP Local

Com `ip` comando:
```sh
ip address show | grep -FA2 'state UP' | sed -nE 's/^.*inet (([[:digit:]]{1,3}.?){4})\/.*$/\1/p'
```

Com `hostname` comando:
```sh
hostname -I | cut -d ' ' -f 1
```

### Configuração de Polkit

#### Habilitar Suspensão do Sistema Para Determinado Usuário Sem Ser Necessário Autenticação

1. Adicionar nova regra no arquivo `/etc/polkit-1/rules.d/<file-name>.rules`:
```js
polkit.addRule(function(action, subject) {
    if ((action.id == "org.freedesktop.login1.suspend" ||
         action.id == "org.freedesktop.login1.hibernate" ||
         action.id == "org.freedesktop.login1.suspend-then-hibernate") &&
        subject.user == "<username>") {
        return polkit.Result.YES;
    }
});
```

2. Reinicie o serviço:
```sh
systemctl restart polkit
```

### Como Ler Cabeçalho de Contexto (_DIFF_)

O cabeçalho de exemplo `@@ -37,6 +35,8 @@` significa:
- `-37,6`: indica que as alterações começam na linha 37 do arquivo original e se estende por 6 linhas;
- `+35,8`: indica que as linhas adicionadas começam na linha 35 do novo arquivo e se estendem por 8 linhas.

Ou seja, as linhas citadas na verdade não começam desde a primeira linha alterada mas da primeira linha mostrada de todo o contexto e o restante das linhas são o restante das linhas do contexto e não quantas linhas mais foram alteradas.

### Pegar a Linha Mais Longa de Um Arquivo

Passando arquivo como argumento:
```sh
grep -nE "^.{`wc -L < /path/to/file.any`}$" /path/to/file.any
```

Usando _pipe_:
```sh
<command> | grep -nE "^.{`<command> | wc -L`}$"
```

### VNC

#### TigerVNC

Server:
1. Instalação (**#**):
    `apt install tigervnc-scraping-server`
1. Configuração (**$**):
    1. `mkdir ~/.vnc`
    1. `vncpasswd` > _set password_ > _choose "n"_
1. Execute (**$**):
    `x0vncserver -localhost no -passwordfile ~/.vnc/passwd -display :0`

Client:
1. Instalação (**#**):
    `apt install tigervnc-viewer`
1. Executar (**$**):
    `vncviewer`

_REFERENCELINKS_:
- [Sir Rob Linux Brasil](https://youtu.be/YxodO52p94U)
- [DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-vnc-on-ubuntu-22-04)
- [Baeldung](https://www.baeldung.com/linux/virtual-network-computing-server-configure)
- [addictivetips](https://www.addictivetips.com/ubuntu-linux-tips/set-up-vnc-desktop-sharing-on-linux-with-tigervnc/)

### Assinar e _Triggar_ Módulo do Kernel

1. Instalar dependências (**#**):
    `apt install mokutil dkms openssl linux-headers-$(uname -r)`
1. Gerar a chave/certificado (**$**):
    `openssl req -new -x509 -newkey rsa:4096 -keyout <module>.priv -outform DER -out <module>.der -nodes -days 9999 -subj '/CN=<provider>/'`
1. Assine o módulo manualmente (**#**):
    `/usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 <module>.priv <module>.der "$(modinfo -n <module>)"`
1. Importar o certificado manualmente (**#**):
    `mokutil --import <module>.der`
1. _reinicie o sistema_
1. Verifique se o módulo foi adicionado (**#**):
    - Alternativa 1:
        `cat /proc/keys | grep asymmetri`
    - [Alternativa 2](#comando-modprobe)
1. Adicione o trigger no dkms (**#**):
    `echo 'SIGN_TOOL=/usr/local/bin/sign-<module>.sh' > /etc/dkms/<module>.conf`
1. Crie o script de assinatura em `/usr/local/bin/sign-<module>.sh`:
    ```sh
    #!/usr/bin/bash
    private_key=<module>.priv
    x509_cert=<module>.der
    /usr/src/linux-headers-$1/scripts/sign-file sha256 "$private_key" "$x509_cert" "$2" || { echo "error signing module \"$2\"" >&2; exit 1; }
    echo "signed newly-built module \"$2\"" >&2
    ```
1. Dê permissão de execução para o script (**#**):
    `chmod +x '/usr/local/bin/sign-<module>.sh'`

### Bluetooth

#### Via _GUI_

Programas necessários (**#**):
```sh
sudo apt install blueman
```

Habilitar o daemon (**#**):
```sh
sudo systemctl enable --now bluetooth
```

Depois basta abir algum dos apps do blueman no minu de aplicativo.

#### Via _CLI_

Programas necessários (**#**):
```sh
apt install bluetooth bluez bluez-tools libspa-0.2-bluetooth
```

Habilitar o daemon (**#**):
```sh
systemctl enable --now bluetooth
```

Enviar arquivo (**$**):
```sh
bt-obex -p <name|macaddr> /path/to/file.any
```

Para receber arquivos (**$**):
```sh
bt-obex -ys
```

OBS: Os arquivos serão salvos por padrão em `~/.cache/obexd/`.

---

<a id="db_gnulinux-bash"></a>
[<span style="font-size:14px;">GNU/Linux && Bash</span>](#menu)

### Variáveis de ambiente

Mostrar variáveis de ambiente (do usuario corrente):

```bash
env
```

Criar variável de ambiente (escopo global):

```bash
# this will cause subshells to have access to this value.
export FOO="bar"
```

Variáveis do **bash**:

- `BASH_ENV`: arquivo que será carregado antes do comando.

- `PROMPT_COMMAND`: define um comando para ser executado depois de cada comando;

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

### Expansão de Parâmetros

#### `#`, `##`, `%`, `%%`

```sh
$ foo=https://sub.domain.xyz/downloads/archive.tar.gz

$ echo ${foo#*/}
> /sub.domain.xyz/downloads/archive.tar.gz

$ echo ${foo##*/}
> archive.tar.gz

$ echo ${foo%/*}
> https://sub.domain.xyz/downloads

$ echo ${foo%%/*}
> https:
```

#### `@<operator>`

##### `@E`

Treats as `$'...'`.

```sh
$ foo='hello\nworld'

$ echo "$foo"
> hello\nworld

$ echo "${foo@E}"
> hello
> world
```

##### `@Q`

Quote each string to use as input.

```sh
$ foo='hello world'

$ echo "$foo"
> hello world

$ echo "${foo@Q}"
> 'hello world'
```

#### Array

| Expansão            | Descrição                                                  |
| ------------------- | ---------------------------------------------------------- |
| `${array[@]}`       | Imprime todos os elementos do array em strings protegidas. |
| `${array[*]}`       | Imprime todos os elementos do array em uma única string.   |
| `${array[N]}`       | Imprime o elemento na posição ‘N’.                         |
| `${#array[@]}`      | Imprime o total de elementos do array.                     |
| `${!array[@]}`      | Imprime os índices do array.                               |
| `${array[@]:N}`     | Imprime todos os elementos a partir da posição ‘N’.        |
| `${array[@]:N:M}`   | Imprime ‘M’ elementos a partir da posição ‘N’.             |
| `${array[@]: -N}`   | Imprime os últimos ‘N’ elementos.                          |
| `${array[@]: -N:M}` | Imprime ‘M’ elementos a partir da última ‘N’ posição.      |

_TIPS/TRICKS_:

- As expansões de parâmetros `:-`, `:=`, `:+` e `:?` podem ser usadas sem o caracter ":":
    - A expressão COM o ":": é ativada quando a variável for **vazia** ou **não existir**;
    - A expressão SEM o ":": é ativada somente se a variável **não existir**.

- As expansões de parâmetros `^`, `^^`, `,`, `,,`, `~` e `~~` aceitam _wildcards_:
    `echo "${foo^^[aeiou]}"`

- As expansões de parâmetros de "[_array's_](#array)" aceitam variáveis sem o operador:
    `foo='hello'; index='1'; echo "${foo:index}"`

### Glob's Estendidos

Bash:

| Glob         | Descrição                                               |
| ------------ | ------------------------------------------------------- |
| `?(pattern)` | Corresponde a uma ocorrência do padrão.                 |
| `*(pattern)` | Corresponde a qualquer número de ocorrências do padrão. |
| `+(pattern)` | Corresponde a pelo menos uma ocorrência do padrão.      |
| `@(pattern)` | Corresponde exatamente a uma ocorrência do padrão.      |
| `!(pattern)` | Corresponde a tudo, exceto o padrão.                    |

Zsh:

| Glob          | Descrição                        |
| ------------- | -------------------------------- |
| `^foobar`     | Nega o padrão.                   |
| `^(foo\|bar)` | Nega os padrões.                 |
| `foo~bar`     | Aceita "foo" e nega "bar".       |
| `(foo)#`      | Zero ou mais ocorrências de foo. |
| `(foo)##`     | Uma ou mais ocorrências de foo.  |

### Classes de Caracteres POSIX

| Classe       | Descrição                                                             |
| ------------ | --------------------------------------------------------------------- |
| `[:alnum:]`  | Alfabéticos e númericos `[a-z A-Z 0-9]`.                              |
| `[:alpha:]`  | Alfabéticos `[a-z A-Z]`.                                              |
| `[:blank:]`  | Caractere em branco, espaço ou tab `[\t]`.                            |
| `[:cntrl:]`  | Caracteres de controle `[\x00-\x1F-\x7F]`.                            |
| `[:digit:]`  | Números `[0-9]`.                                                      |
| `[:graph:]`  | Qualquer caractere visível (ou seja, exceto em branco) `[\x20-\x7E]`. |
| `[:lower:]`  | Letras minúsculas `[a-z]`.                                            |
| `[:upper:]`  | Letras maiúsculas `[A-Z]`.                                            |
| `[:print:]`  | Caracteres visíveis (ou seja, exceto os de controle) `[\x20-\x7E]`.   |
| `[:punct:]`  | Pontuação `[-!"#$%&'()*+,./:;?@[\\\]_{\|}~]`.                         |
| `[:space:]`  | Espaço em branco `[\t\r\n\v\f]`.                                      |
| `[:xdigit:]` | Número hexadecimais `[0-9 a-f A-F]`.                                  |

Perl equivalentes (_PCRE_):

| Classe      | Equivalente |
| ----------- | ----------- |
| `[:digit:]` | `\d`        |
| `[:alnum:]` | `\w`        |
| `[:space:]` | `\s`        |

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

### Tipos de Shell's

Shell de Login:
- Iniciado como resultado de um login;
- Quando faz login a partir de um terminal virtual (TTY);
- Quando se conecta via SSH;
- Quando usa um gerenciador de login gráfico que inicia um shell de login.

Shell de Não-Login:
- Iniciado não como resultado de um login;
- Abertura de um terminal dentro de um ambiente gráfico;
- Execução de scripts que invocam shell's (_subshells_).

Shell Interativo:
- Espera e responde a comandos do usuário;

Shell Não-Interativo:
- Não (necessarimente) espera entrada do usuário;
- Executado a partir de scripts ou comandos automatizados;
- Comandos passados por argumentos (`bash -c '<command>'`).

### Ordem de Chamada dos Arquivos de Inicialização

#### Usando CLI

Shells de Login:
1. `/etc/environment`:
    - Independete (carregado pelo **PAM**);

1. `/etc/profile` (`/etc/profile.d/*.sh`):
    - Configuração global para _shells_ de _login_;

1. `~/.bash_profile`:
    - Configuração local do usuário para _shells_ de _login_;

1. `~/.bash_login`:
    - Carregado caso o anterior não exista a menos que seja explícito;

1. `~/.profile`:
    - Carregado caso o anterior não exista a menos que seja explícito.

Shells Interativos:
1. `/etc/bash.bashrc`:
    - Configuração global para _shells_ interativos (e de não-login);

1. `~/.bashrc`:
    - Configuração local do usuario para _shells_ interativos (e de não-login).

#### Usando GUI

1. `/etc/environment`:
    - Independente (carregado pelo **PAM**).

1. `~/.xinitrc`:
    - Independente (carregador pelo servidor gráfico (**X**));
    - Pode conter a chamada dos _shell's startup files_.

1. `/etc/X11/xinit/xinitrc`:
    - Carregado caso o anterior não exista a menos que seja explícito;

_REFERENCELINKS_:

- [Environment Variables (from Debian wiki)](https://wiki.debian.org/EnvironmentVariables);
- [ArchWiki](https://wiki.archlinux.org/title/bash#Configuration_files).

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

### Iterar Sobe Cada Letra de Uma String

1ª Opção:
```sh
foo='string'; for ((index=0; index < ${#foo}; index++)); do echo "${foo:$index:1}"; done
```

2ª Opção:
```sh
while read -n1 line; do echo "$line"; done < <(echo -n 'string')
```

3ª Opção:
```sh
grep --only-matching --color=never '.' <<< 'string' | while read line; do echo "$line"; done
```

4ª Opção:
```sh
for char in `sed -E 's/(.)/\1\n/g' <<< 'string'`; do echo "$char"; done
```

### Palavra Chave `return`

Usar quando dentro de uma função você não quiser encerrar o script por completo (com comando `exit` por exemplo), ou seja, quando quiser somente sair da função antecipadamente.

Com esse comando podemos especificar o código de retorno da função com `return <code>` e caso não especifique o código de retorno o comando automáticamente retornará a função com o código de retorno do último comando executado.

E o comando também só será útil caso queira retornar de forma antecipada pois caso utilize o `return` na última linha, NÃO ter o `return` terá o mesmo efeito.

### Leitura de Arquivo Nativa

```sh
echo "$(< /path/to/file.any)"
```

### Montar _String_ de Opções Sem Espaços

```sh
options=('option1' 'option2' 'option3' 'option4')
cmd --options "`IFS=,; echo "${options[*]}"`"
```

or

```sh
array=('option1' 'option2' 'option3' 'option4')
options=`IFS=,; echo "${array[*]}"`
cmd "$options"
```

### Comando `test` Como Um `if` Tradicional

```sh
[ 0 -eq 0 ] && { ls /foo; :; } || echo false
```

OBS: Nesse caso o comando do bloco verdade falhará (`ls /foo`), e caso não tenha o ":;", o bloco false também será executado pois como o operador `&&`, o operador `||` avalia o código de saída do último comando executado (comando anterior a ele) e não a condição do comando `test` (para isso temos especificamente o comando `if`). Isso não é uma falha, muito pelo contrário, de fato é o comportamento correto uma vez que você entende o intuito e o funcionamento dos operadores lógicos do _shell_... Esse exemplo é apenas um _trick_ para que o comportamento dessa expressão seja o mais próximo de um **if** tradicional.

### Descritores de Arquivos (_File Descriptors_ (_FD's_))

Ver os descritores de arquivos do shell atual:
```sh
ls /proc/"$$"/fd/
```

OBS:
- inclusive caso você abra um novo para escrita ou leitura ele também será listado e você identificará seu tipo pelas permissões;
- inclusive dá para enviar algo para o descritor de arquivo de otro processo com redirecionamento: `<command> >/proc/<pid>/fd/<fd>`

### Arrays

Operador de atribuição:
```sh
array=(one two)
array+=(three)
```

### Test

O comando `test` por padrão sem nenhum argumento valida com a opção `-n`, logo:
```sh
[ -n "$FOO" ]
```

É equivlaente a:
```sh
[ "$FOO" ]
```

### ANSI Colors

Escapes:

- Forma longa:
    - Iniciar: `\033[<ansi>;<ansi>m`
    - Resetar: `\033[00m`

- Forma abreviada:
    - Iniciar: `\e[<ansi>;<ansi>m`
    - Resetar: `\e[00m`

Cores:
| Color   | Code    | - | Effect    | Code |
| ------- | ------- | - | --------- | ---- |
| Black   | {3\|4}0 | - | Regular   | 0    |
| Red     | {3\|4}1 | - | Bold      | 1    |
| Green   | {3\|4}2 | - | Dim       | 2    |
| Yellow  | {3\|4}3 | - | Italic    | 3    |
| Blue    | {3\|4}4 | - | Underline | 4    |
| Magenta | {3\|4}5 | - | Blink     | 5    |
| Cyan    | {3\|4}6 | - | Invert    | 7    |
| White   | {3\|4}7 | - | Hidden    | 8    |

_EXAMPLES_:

- Com echo:
```sh
echo $'\e[1;31;43m<string>\e[m'
```

_TIPS/TRICKS_:

- Quando for utilizdo as cores para setar na `PS1` variável proteja a expressão:
```sh
\[\e[<ansi>m\]foobar\[\e[m\]
```

### Imprimir Variável Pelo Valor com Expansão de Parâmetro

Simples:
```sh
foo='bar'
bar='xpto'
# eval echo "\$$foo"
echo "${!foo}"
```

Avançado (expansão não é possível aqui):
```sh
bar1='boo'
bar2='baz'
foo=1
eval echo "\$bar$foo"
foo=2
eval echo "\$bar$foo"
```

### `:`

Executar expansão "seca":
```sh
: ${foo:=bar}
echo "$foo"
```

### `printf`

Printar caracteres em sequência:
```sh
printf -- '-%.s' `seq <count>`
```

Ou:
```sh
printf -- '|%.s\n' `seq <count>`
```

### Subsituição de Processos

A saída ou a entrada são arquivos.

#### `<(cmd)`

O retorno dessa substituição será um arquivo, ou seja, será usada em comandos que esperam receber arquivos.

- `diff ./file-1.txt ./file-2.txt` -> `diff <(echo '/foo/bar') <(pwd)`
- `ls -1 > ./file.txt && wc -l ./file.txt` -> `wc -l <(ls -1)`
- `while read; do echo "$REPLY"; done < <(grep -rn 'value' ./folder/)`

#### `>(cmd)`

O comando que gera algúm arquivo envia-o para a substituição, ou seja, é o inverso de `<()`, se antes o comando que recebia o arquivo ficava do lado de fora, agora o comando que recebe o arquivo via _STDIN_ estará do lado de dentro recendo o arquivo gerado do lado de fora. A substituição é o arquivo de saída.

- `tar -cf ./archive.tar && ssh host tar -xf - < ./archive.tar` -> `tar -cf >(ssh host tar -xf -) ./`
- `ls -1 > ./file.txt && wc -l ./file.txt` -> `ls -1 > >(wc -l)`
- `exec > >(tee ./file.log) 2>&1`

### Comando _set_

- `-o pipefail`: agora a _pipeline_ retorna o código do primeiro comando com erro ao invés de retornar o código do último executado (útil caso não queira tratar `${PIPESTATUS[@]}`).

### Comando _shopt_

- `shopt -s globstar`: `**` casa com com qualquer quantidade de caractere em todos os níveis (diretórios e subdiretórios)
- `shopt -s dotglob`: incluí arquivos e diretórios ocultos nos resultados de expansões de nomes

_TIPS/TRICKS_:
- `shopt -s globstar dotglob` com `**[/*]` causa a expansão de todos os arquivos e todo os subníveis incluíndo os ocultos (equivalente a `find`?)

### Múltiplos Comandos _In-Line_ com Background

Caso tente executar:
```sh
<command> &; <command>
```
Irá pegar um erro de sintaxe.

Nesse caso, o `&` já realiza a mesma função que o `;` indicando o final de um comando (que porém, executará em background), ou seja, a forma correta de escrever a expressão seria:
```sh
<command> & <command>
```

### Comandos `test` Equivalentes `if`

#### Um Comando Por Bloco

<details>
<summary>Simples</summary>

`if`:
```sh
# in-block
if <expression>; then
    <command>
fi

# in-line
if <expression>; then <command>; fi
```

`test`:
```sh
# in-block
[ <expression> ] && {
    <command>
}

# in-line
[ <expression> ] && <command>
```
</details>

<details>
<summary>Else</summary>

`if`:
```sh
# in-block
if <expression>; then
    <command>
else
    <command>
fi

# in-line
if <expression>; then <command>; else <command>; fi
```

`test`:
```sh
# in-block
[ <expression> ] && {
    <command>
} || {
    <command>
}

# in-line
[ <expression> ] && <command> || <command>
```
</details>

<details>
<summary>Else If</summary>

`if`:
```sh
# in-block
if <expression>; then
    <command>
elif <expression>; then
    <command>
else
    <command>
fi

# in-line
if <expression>; then <command>; elif <expression>; then <command>; else <command>; fi
```

`test`:
```sh
# in-block
[ <expression> ] && {
    <command>
} || { [ <expression> ] && {
    <command>
} || {
    <command>
}; }

# in-line
[ <expression> ] && <command> || { [ <expression> ] && <command> || <command>; }
```
</details>

#### Múltiplos Comandos Por Bloco

<details>
<summary>Simples</summary>

`if`:
```sh
# in-block
if <expression>; then
    <command>
    <command>
fi

# in-line
if <expression>; then <command>; <command>; fi
```

`test`:
```sh
# in-block
[ <expression> ] && {
    <command>
    <command>
}

# in-line
[ <expression> ] && { <command>; <command>; }
```
</details>

<details>
<summary>Else</summary>

`if`:
```sh
# in-block
if <expression>; then
    <command>
    <command>
else
    <command>
    <command>
fi

# in-line
if <expression>; then <command>; <command>; else <command>; <command>; fi
```

`test`:
```sh
# in-block
[ <expression> ] && {
    <command>
    <command>
} || {
    <command>
    <command>
}

# in-line
[ <expression> ] && { <command>; <command>; } || { <command>; <command>; }
```
</details>

<details>
<summary>Else If</summary>

`if`:
```sh
# in-block
if <expression>; then
    <command>
    <command>
elif <expression>; then
    <command>
    <command>
else
    <command>
    <command>
fi

# in-line
if <expression>; then <command>; <command>; elif <expression>; then <command>; <command>; else <command>; <command>; fi
```

`test`:
```sh
# in-block
[ <expression> ] && {
    <command>
    <command>
} || { [ <expression> ] && {
    <command>
    <command>
} || {
    <command>
    <command>
}; }

# in-line
[ <expression> ] && { <command>; <command>; } || { [ <expression> ] && { <command>; <command>; } || { <command>; <command>; }; }
```
</details>

---

<a id="db_configuracao"></a>
[<span style="font-size:14px;">Configuração</span>](#menu)

### Comando _xrandr_

#### Mudar Resolução da Tela Via Terminal

##### A Partir de Uma Resolução Já Existente

1. Verificar as saidas de vídeos possíveis:
```bash
xrandr
```

2. Defina a resolução com:
```sh
xrandr -s 1920x1080
```

##### Caso Precise Criar/Forçar Uma Resolulção Não Listada

1. Pegue as cordenadas da tela informando a **resolução** e **hz** (_hertz_) desejados com o comando `cvt`:
    `cvt 1920 1080 90`

    - OBS: Copie tudo o que estiver depois de "Modeline ":
        `"1920x1080_90.00"  269.00  1920 2064 2272 2624  1080 1083 1088 1140 -hsync +vsync`

1. Crie um novo modo xrandr com a informação coletada:
    `xrandr --newmode "1920x1080_90.00"  269.00  1920 2064 2272 2624  1080 1083 1088 1140 -hsync +vsync`

1. Adicione o novo modo criado ao xrandr:
	`xrandr --addmode Virtual1 1920x1080_90.00`

1. Defina o novo modo adicionado:
	`xrandr --output Virtual1 --mode 1920x1080_90.00`

<details>
<summary># TIPS & TRICKS</summary>

- Para adicionar a nova resolução de forma permanente, coloque no seu **shell rc** os comandos `--newmode`, `--addmode` e `--output`.
</details>

#### Mesclar Monitores

1. Liste os monitores disponíveis:
    `xrandr --listactivemonitors`

Ou utilize a _pipeline_:
    `xrandr --listactivemonitors | sed -nE 's/.*  (.*)$/\1/p' | tr '\n' ',' | sed 's/,$//'`

2. Execute:
    `xrandr --setmonitor MERGE-1 auto VGA-1,HDMI-1`

#### Mudar Escala

Exemplos:
1. `xrandr --output eDP-1 --scale 1.25 [--filter {bilinear|nearest}]`
2. `xrandr --output eDP-1 --scale-from 1920x1080`

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

Listar configurações atuais:
```sh
setxkbmap -query
```

Definir layout do teclado:
```sh
setxkbmap -layout br [-model abnt2] [-variant abnt2]
```

Definir _Compose Key_:
```sh
setxkbmap -option compose:<keysym>
```

Limpar as opções do `setxkbmap` (_Compose Key_ e outros configs):
```sh
setxkbmap -option
```

Lista de _keysyms_:
- `ralt`: Alt Direito (AltGr)
- `lalt`: Alt Esquerdo
- `caps`: Caps Lock
- `menu`: Menu
- `rctrl`: Controle Direito
- `lctrl`: Controle Esqurdo
- `shift`: Shift
- `super`: Super
- `esc`: Escape
- `backspace`: Backspace

##### _Compose Key_

Tabela de combinações _Compose Keys_:

| Combinação                  | Resultado | Descrição                        |
| --------------------------- | --------- | -------------------------------- |
| `Compose` + `-` + `-` + `-` | `—`       | Travessão (em dash)              |
| `Compose` + `'` + `e`       | `é`       | Letra "e" com acento agudo       |
| `Compose` + `"` + `u`       | `ü`       | Letra "u" com trema              |
| `Compose` + `,` + `c`       | `ç`       | Letra "c" com cedilha            |
| `Compose` + `~` + `n`       | `ñ`       | Letra "n" com til                |
| `Compose` + `^` + `o`       | `ô`       | Letra "o" com acento circunflexo |
| `Compose` + `"` + `a`       | `ä`       | Letra "a" com trema              |
| `Compose` + `o` + `c`       | `©`       | Símbolo de copyright             |
| `Compose` + `+` + `-`       | `±`       | Sinal de mais ou menos           |
| `Compose` + `-` + `>`       | `→`       | Seta para a direita              |
| `Compose` + `<` + `-`       | `←`       | Seta para a esquerda             |
| `Compose` + `:` + `=`       | `≠`       | Sinal de diferente               |
| `Compose` + `^` + `2`       | `²`       | Expoente dois                    |
| `Compose` + `/` + `=`       | `≠`       | Sinal de diferente               |
| `Compose` + `?` + `?`       | `¿`       | Ponto de interrogação invertido  |
| `Compose` + `!` + `!`       | `¡`       | Ponto de exclamação invertido    |
| `Compose` + `.` + `.`       | `…`       | Reticências                      |

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

### XDG

É um conjunto de especificações para **caminhos de diretórios**, **esquemas de URL** e **_mime types_**.

- As variáeveis estão em: `~/.config/user-dirs.dirs`
- Os _mime types_ em: `/usr/share/mime/types`

_Labels_ (`<label>`):
- `DESKTOP`
- `DOWNLOAD`
- `TEMPLATES`
- `PUBLICSHARE`
- `DOCUMENTS`
- `MUSIC`
- `PICTURES`
- `VIDEOS`

#### Comando _xdg-user-dir_

Somente retorna o valor das variáveis XDG:
```sh
xdg-user-dir <label>
```

#### Comando _xdg-user-dirs-update_

Atualiza os valores das variáveis caso houve alguma alteração:
```sh
xdg-user-dirs-update
```

Define um novo valor para um das variáveis XDG:
```sh
xdg-user-dirs-update --set <label> $HOME/New/xdg/path
```

#### Comando _xdg-mime_

Descobrir o _mime type_ de algum arquivo:
```sh
xdg-mime query filetype {file.any/directory}
```

Saber o programa definido para determinado _mime type_:
```sh
xdg-mime query default <mime/type>
```

Definir o programa a abrir determinado _mime type_:
```sh
xdg-mime default <program>.desktop <mime/type>
```

#### Comando _xdg-settings_

Verificar as propriedades do **xdg-settings**:
```sh
xdg-settings --list
```

Pegar o valor de alguma propriedade:
```sh
xdg-settings get <property> [<subproperty>]
```

Definir o valor de uma propriedade:
```sh
xdg-settings set <property> [<subproperty>] <value>
```

#### LC\_ALL Não Definida

Comando:
```sh
export LC_ALL='en_US.UTF-8'; dpkg-reconfigure locales
```

### PipeWire

_Setup_ no Debian SID:
1. (Des)Instale os pacotes necessários (**#**):
    `apt install pipewire-audio pipewire-jack pipewire-media-session-`
1. Copie os arquivos de configuração do PipeWire (**#**):
    `cp -v /usr/share/doc/pipewire/examples/systemd/user/pipewire-pulse.* /etc/systemd/user/`
1. Copie os arquivos de configuração do ALSA (**#**):
    `cp -v /usr/share/doc/pipewire/examples/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d/`
1. Copie os arquivos de configuração do JACK (**#**):
    `cp -v /usr/share/doc/pipewire/examples/ld.so.conf.d/pipewire-jack-*.conf /etc/ld.so.conf.d/`
1. Configure o JACK (**#**):
    `ldconfig`
1. Habilite o _daemon_ do WirePlumber (**$**):
    `systemctl --user --now enable wireplumber.service`
1. Reinicie o sistema (**$**):
    `systemctl reboot` || `sudo reboot`

_OBSERVATIONS_:
- Caso deseje desabilitar o [fluidsynth](https://www.fluidsynth.org/):
    `sudo systemctl --global disable fluidsynth.service`
- Para o _setup_ oficial siga o passo a passo da [wiki](https://wiki.debian.org/PipeWire)

#### Módulo de Cancelamento de Ruído

1. No arquivo `/etc/pipewire/pipewire.conf.d/pipewire.conf` (_system-wide_) ou em `~/pipewire/pipewire.conf.d/pipewire.conf` (local) defina:
```
 context.modules = [
  {   name = libpipewire-module-echo-cancel
      args = {
          # library.name  = aec/libspa-aec-webrtc
          # node.latency = 1024/48000
          # monitor.mode = false
          capture.props = {
             node.name = "Echo Cancellation Capture"
          }
          source.props = {
             node.name = "Echo Cancellation Source"
          }
          sink.props = {
             node.name = "Echo Cancellation Sink"
          }
          playback.props = {
             node.name = "Echo Cancellation Playback"
          }
      }
  }
]
```
A configuração então será "appendada" ao array de módulos.

Extra, no `pavucontrol` na parte de _input's_ deixe como _fallback_ o módulo de cancelamento de ruído que aponta para o canal _built-in_ e nele defina o seu dispositivo (como o _headphone_ por exemplo) como padrão.

_REFERENCELINKS_:
- [PipeWire Synopsis](https://docs.pipewire.org/page_man_pipewire_conf_5.html)
- [PipeWire Module Echo Cancel](https://docs.pipewire.org/page_module_echo_cancel.html)

### Polybar

Executar:
```sh
polybar [-r|--reload] [<bar>]
```

Em segundo plano:
```sh
nohup polybar [-r|--reload] [<bar>] &
```

Para especificar em qual monitor a polybar irá aparecer:
```sh
MONITOR=<monitor> polybar
```

- OBS: pegue o nome do monitor com: `xrandr [-q|--query]`

Script para definir polybar em todos os monitores (by [community](https://github.com/polybar/polybar/issues/763#issuecomment-392960721)):
```sh
#!/bin/bash
for monitor in $(polybar --list-monitors | cut -d':' -f1); do
    MONITOR="$monitor" polybar --reload [bar] &
done
```

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

### Informações do Sistema

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

### Driver de Rede

Comando _inxi_:
```sh
inxi -N
```

Comando _lspci_:
```sh
lspci -nnk
```

### Memória RAM

Programas neceśsarios (**#**):
```sh
apt install -y lshw dmidecode
```

Comando _lshw_ (**#**):
```sh
lshw -c memory
```

Comando _dmidecode_ (**#**):
```sh
dmidecode -t memory
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

### Engatilhar Para Dispositivos

Adicionar algum script `.rules` em `/etc/udev/rules.d/`:

- _Triggar_ por fornecedor ou produto (ou pelos dois):
```rules
ACTION=="<action>", SUBSYSTEMS=="<subsystem>", ATTRS{idVendor}=="<vendor-id>", ATTRS{idProduct}=="<product-id>", RUN+="/path/to/your/script.sh"
```

- _Triggar_ pelo rótulo do dispositivo:
```rules
ACTION=="<action>", SUBSYSTEM=="<subsystem>", ENV{ID_FS_LABEL}=="<label>", RUN+="/path/to/your/script.sh"
```

_OPTIONS_:

- `ACTION`:
    - `add`: Quando o dispositivo é adicionado
    - `remove`: Quando o dispositivo é removido
    - `change`: Quando o dispositivo é alterado

- `SUBSYSTEMS`:
    - `usb`: Dispositivos USB no geral

- `SUBSYSTEM`:
    - `block`: Dispositivos de bloco (discos, partições)

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

```sh
DISPLAY=:0
* * * * * /absolute/path/to/script.sh
```
or
```sh
* * * * * export DISPLAY=:0; /absolute/path/to/script.sh
```

_OBSERVATIONS_:

Dentro do **crontab** redirecionamento de _STDOUT_ podem não funcionar, mas de _STDERR_ sim como por exemplo:
```sh
* * * * * /absolute/path/to/script.sh 2>/tmp/cron.log
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
	MatchIsTouchpad "on"
	Option "Tapping" "true"
	Option "NaturalScrolling" "true"
	Option "ScrollMethod" "twofinger"
EndSection
```

### Update-alternatives

Definir o padrão para determinada propriedade (**#**):
```sh
update-alternatives --auto <name>
```

Instalando um novo programa no *update-alternatives* (**#**):

- `link`: link simbólico genérico já usado pelo _update-alternative_
- `name`: propriedade do update-alternative que está modificando
- `path`: caminho absoluto do novo programa
- `priority`: prioridade de utilização sobre outros (maior valor, maior prioridade)

```sh
update-alternatives --install <link> <name> <path> <priority>
```

Para descobrir _link_ e _name_ usando a opção `--query` (**$**):
![image-to-discover-link-and-name](./.assets/images/update-alternatives-install-option.png)

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
Maintainer: rhuanpk
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

- Matar painel atual:
    `${mod}+x`

- Matar janela atual:
    `${mod}+&`

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

Modo Normal:
- split vertical:
	`ctrl+w v`
- split horizontal:
	`ctrl+w s`
- navega entre as janelas:
	`ctrl+w w`
- _scroll_ de linha a linha para baixo:
	`ctrl+w e`
- _scroll_ de linha a linha para cima:
	`ctrl+w y`
- entre no modo bloco visual:
	`ctrl+v`
- cola um registro específico do histórico:
	`<register_name>p`
- deleta da linha atual até o início do arquivo:
	`dgg`
- deleta da linha atual até o final do arquivo:
	`dG`
- entrar na janela de comandos:
	`q:`

Modo de Comando:
- abre o arquivo no caminho passado:
	`:e /path/to/file.any`
- abre uma janela dedicada a ser um terminal:
	`:term`
- abre uma janela dedicada a ser um terminal esplitado na vertical:
	`:vertical :term`
- executa um comando e volta para o vim:
	`:! pwd`
- executa um comando e seu retorno vai direto para o arquivo que está sendo editado:
	`:r! pwd`
- faz a listagem do histórico de _deletes/yanks_ ("_reg_" é a abreviação de "_register_"):
	`:reg`
- limpa o arquivo (deleta todas as linhas):
	`:%d`
- deleta o range de linhas informados:
	`:<begin-number>,<end-number>d`
- deleta da linha atual até o final do arquivo:
	`:.,$d`
- deleta todas as linhas que contenham a _string_ passada:
	`:g/<string>/d`
- deleta todas as linhas que NÃO contenham a _string_ passada:
	`:g!/<string>/d`
- deleta todas as linhas em branco :):
	`:g/^$/d`
- nas linhas casadas com o regex faça a troca:
	`:[<range-lines>]g/<regex>/s/<old-string>/<new-string>/[gci]`
- regex no range de linhas (o segundo valor do range pode ser outro _pattern_):
	`:/<pattern>/,$g/<string>`
- executar mais de um comando por linha:
	`:%s/<pattern>/<replacement>/[gci] | :%s/<pattern>/<replacement>/[gci]`
- ir para o próximo _buffer_ (arquivo):
	`:bn`
- ir para _buffer_ anterior:
	`:bp`
- avançar _n_ _buffers_:
	`:<number>bn`
- retroceder _n_ _buffers_:
	`:<number>bp`
- ir para um _buffer_ específico pelo índice ou pelo nome:
	`:b {<index>|<name>}`
- listar arquivos no _buffer_:
    `:ls`
- mudar o _syntax highlifht_:
    `:set filetype=<type>`

Modo de Pesquisa:
- pesquisa com case insensitive:
	`/<string>\c`
- pesquisa com case sensitive:
	`/<string>\C`

_TIPS/TRICKS_:

- Para adicionar um novo arquivo ao _buffer_ basta abrir com o comando `:e`.

- Gravar comandos num registrador e executar _n_ vezes:
	1. `q<letter>`: começa a gravar um novo registrador de nome _<letter>_;
	1. `:<command>`: executa comando;
	1. `:<command>`: executa outros comandos se desejado;
	1. `q`: persiste o novo registrador;
	1. `<number>@<letter>`: usa ele _n_ vezes.
    - OBS: após cada execução do registrador o cursor irá para a próxima linha.

- Trocar todas as variáveis para minúsculas (bash script):
    ```sh
    :%s/^\(\s*\(\(readonly\|local\) \)\?\)\?\([[:alnum:]]\+_\?\)\+=/\L&/g | :%s/\${\?.\?\([[:alnum:]]\+_\?\)\+\(\[.]\)\?}\?/\L&/g | :%s/^\(\s*declare\)\( \(--\?\w\+ \)\?\)\(\([[:alnum:]]\+_\?\)\+\)=/\1\2\L\4=/g
    ```
    - OBSERVAÇÕES:
        - Caso queria trocar todas maiúscula troque os `\L` por `\U`.
        - Com esse RegEx, caso tenha alguma variável declarada dentro de um _heredoc_ por exemplo ela também será afetada, se tiver executadado num arquivo dentro de um repositório git execute `git restore -p ./` para desfazer as alterações nas variáveis indejadas (que serão poucas provavelmente).

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
	`x-terminal-emulator --working-directory=%f`

Adicionar pastas em "Palces":

1. `*botão direito na pasta* » Send To » Side Pane (Create Shortcurt)`

### Caixas de diálogo

#### Notify-send

```sh
notify-send 'Summary' 'Message body.'
```

#### Noti

```sh
noti <command>
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

### Configurar `diff-highlight` do Git

1. Instale o **Git** caso ainda não o tenha (**#**):
    `apt install git`

1. Copie a pasta do **diff-highlight**:
    `cp -rfv /usr/share/doc/git/contrib/diff-highlight/ ./`

1. Entre na pasta:
     `cd ./diff-highlight/`

1. Gere o binário:
    `make`

1. Coloque o binário em alguma pasta da sua variável `$PATH`.

_pipeline_:
```
cdpwd() { cd "$1" && echo "cd: $(pwd)"; }; [ "${UID:-`id -u`}" -ne 0 ]; sudo='sudo'; $sudo apt install -y git && cdpwd /tmp/ && cp -rfv /usr/share/doc/git/contrib/diff-highlight/ ./ && cdpwd ./diff-highlight/ && make && install -vDt ~/.local/bin/ ./diff-highlight
```

### Desabilitar Fast Startup no Windows

Via prompt de comando:
- Lista as opções de energia:
    `powercfg /a`
- Habilita/Desabilita o Fast Startup
    `powercfg -h {on|off}`

Via interface gráfica:
1. Painel de Controle
1. Hardware e Sons
1. Opções de Energia
1. Escolher funções dos botões de energia
1. Alterar configurações não disponíveis no momento
1. Ligar inicialização rápida (recomendado)
1. Salvar alterações

---

<a id="db_any_commands"></a>
[<span style="font-size:14px;">Any commands</span>](#menu)

### Comando _yt-dlp_

Baixar áudio:
```sh
yt-dlp -x --audio-format mp3 <yt-url>
```

Baixar vídeo:
```sh
yt-dlp -S ext:mp4,res:1080 <yt-url>
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

- `-r`: saída pura;
- `-c`: mimificado;
- `-C`: colorido;
- `-M`: sem cor;

Comando:

- `jq '.' file.json`
- `jq '.' file.json > pretty.json`
- `cat file.json | jq`
- `jq <<< '{"foo":"bar"}'`
- `curl -fsSL 'https://jsonplaceholder.typicode.com/posts' -H 'content-type: application/json' | jq`

Acessando atributo do objeto JSON:

```sh
jq [-r] '.xpto.array.[2]' <<< '{"foo":"bar","xpto":{"hello":"world","array":[true,42,"string"]}}'
```

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

#### Instalação

- Via _standalone package_
    ```sh
    curl -fsSL https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz | sudo tar -C /usr/local/bin/ -zxvf -
    ```
- <details>
    <summary>Via oficial repos (<i>#deprecated</i>)</summary>

    ```sh
    [ "$UID" -ne 0 ] && sudo='sudo'; $sudo tee '/etc/apt/sources.list.d/ngrok.list' <<< 'deb https://ngrok-agent.s3.amazonaws.com buster main' && curl -fsSL 'https://ngrok-agent.s3.amazonaws.com/ngrok.asc' | $sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/ngrok.gpg && $sudo apt update && $sudo apt install -y ngrok
    ```
</details>

#### Configuração

Configurar a cahve de API:
```sh
ngrok config add-authtoken <api-token>
```

#### SSH

- Iniciar o _reverse proxy_ para **SSH**:
	`ngrok tcp <ssh-port>`

Depois de iniciado, na linha "_Forwarding_" temos:
```sh
tcp://0.tcp.us.ngrok.io:00000 -> localhost:00000
```

- O domínio disponibilizado pelo **ngrok** é:
	`tcp://<DOMAIN>:00000`
- E a porta disponibilizado pelo **ngrok** é:
	`tcp://0.tcp.us.ngrok.io:<PORT>`

Agora basta fazer a conexão com:
```sh
ssh -p <ngrok-port> <host-user>@<ngrok-domain>
```

#### HTTP

- Iniciar o _reverse proxy_ para **HTTP**:
```sh
ngrok http <http-port>
```

_TIPS/TRICKS_:

- Iniciar o **ngrok** em background:
```sh
nohup ngrok tcp 22 &>/dev/null &
```

- Pegar as infos de _url's_ e endereços locais _bindados_:
```sh
curl -sS http://127.0.0.1:4040/api/tunnels | jq -C | grep -E '(public_url|addr)'
```

- Matar todas as seções do **ngrok**:
```sh
kill -KILL `ps -o pid -C ngrok | tail -n +2`
```

_OBSERVATIONS_:
- Caso tenha _firewall_, habiliar a porta nele?

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

### Comando *highlight-pointer*

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

- `-f <font>`: font name;
- `-w <width>`: width pixels (should use `tput cols`).

Instalação:

```bash
sudo apt install -y figlet
```

_Printar_ a menssagem como _banner_:

```bash
figlet [-f <fontname>] [-w <width>] "TEXT FOR BANNER"
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

### Comando _showrgb_

Procurar pelo RGB de alguma cor:
```sh
showrgb | grep -i '<color>'
```

---

<a id="ubuntu"></a>
## [Ubuntu](#menu)

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
## [Git](#menu)

### *Quick Start*

1. `git add ./`
1. `git commit -m 'commit message'`
1. `git push origin main`

_pipeline_:

```sh
git add ./ && git commit -m 'commit message' && git push origin main
```

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

Parar de _trackear_ branch remota:

```sh
git branch -dr <remote>/<branch>
```

#### Renomeação de Branchs

##### Local

Remover:

```sh
git branch -m <new_branch>
```
Forçando:

```sh
git branch -M <new_branch>
```

##### Remoto

Remover:

```sh
git push <remote> <remote>/<old_branch>:refs/heads/<new_branch> :<old_branch>
```

#### Criação de Branchs

A partir de uma remoto já existente:
```sh
git switch -c <local-branch> <remote>/<remote-branch>
```

### Commits

#### Revert

Desfaz o _commit_ criando um novo _commit_ sem essas alterações:

```sh
git revert <commit>
```

Passando um _range_ (do mais antigo para o mais novo) de _commits_ (isso fará um **revert** por vez):

```sh
git revert <oldest_commit>..<newst_commit>
```

#### Reset

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

#### Amend

Para adicionar um novo arquivo para o último _commit_ ou editar qualquer arquivo do _commit_, basta fazer as alterações desejadas e adicionar em _stage_ (`git add <path>`):

```bash
# simplesmente commitar sem alterar nada (mensagem):
git commit --amend --no-edit

# commitar no modo interativo (abre o editor padrão):
git commit [-i] --amend

# já passando a mensagem:
git commit --amend -m '<message>'
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

Com _squash_:

```bash
git merge --squash <branch_name>
```

OBS: dessa forma, com tudo irá virár um único _commit_, no final ele deixa tudo em _staged_ para você _commitar_ com a mensagem que desejar.

### Rebase

#### Simple Rebase

Command:
	`git rebase <new-base>`

We say: rebase atual branch to "new base" branch.

Command:
	`git rebase <new-base> <rebase-branch>`

We say: rebase "branch to rebase" branch to "new base" branch.

Eexplain: before perform normal rebase, switch to the "branch to rebase" branch.

#### Rebase With Onto

Command:
	`git rebase --onto <new-base> <start-point>`

We say: rebase atual branch to "new base" branch starting from "start point".

Command:
	`git rebase --onto <new-base> <start-point> <end-point>`

We say: in atual branch starting from "start point" util the "end point" rebasing onto "new base" branch.

OBSERVATIONS:

- In **rebase onto** the _start point_ actually is the child commit of him (so you'll probably want to do something like `<start-point>^` or `<start-point>~1`);

- This guide uses "newbie terms" for better explanation. In "technical terms" in **common rebase** (and **git onto**) the `<new-base>` actually is `<new-parent-commit>` and in **rebase onto** the `<start-point>` is `<old-parent-commit>` and `<end-point>` is `<until-the-commit>`.

### Stash

- `-u`: _stashear_ arquivos não traqueados (#saving,#listing);
- `-p`: _patch_ dos arquivos (#listing);
- `-S`: aplica o **stash** somente sobre o _staging_ (#saving);
- `-k`: apesar de _stashear_ o que está em _staging_, não o limpa (#saving);
- `-m <message>`: _stashear_ com mensagem específica (#saving);
- `--index`: restaurar preservando o _staging_ (#applying).

_Stashear_ todos os arquivos:

```bash
git stash [-uk] [-m <message>]
```

_Stashear_ arquivos específicos:

```bash
git stash push [-uk] [-m '<message>'] <path/to/folder/or/file.any>*
```

Listar/Mostrar _stash_:

```bash
git stash show [-up] 'stash@{<stash_id>}'
```

Aplicar/Aplicar e Dropar _stash_:

```sh
git stash {apply|pop} [--index] ['stash@{<stash_id>}']
```

Deletar **stash**:

```sh
git stash drop ['stash@{<stash_id>}']
```

_OBERSAVTIONS_:

- Nas operações com **stash**, quando NÃO especificado o _id_, é pego por padrão o último (o primeiro da _FIFO_).

### Log's

- `--all`: caso sua branch esteja atrás, mostra logs dos ramos a frente também;
- `--oneline`: mostra o log de forma resumida, um por linha;
- `--patch`: mostras as alteraçẽos feitas nos commits;
- `--graph`: dsenha uma gráfo da time line dos logs;
- `--author=<name>`: filtra os logs pelo autor.

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

Clonar sem outras branch ou referência delas:
```sh
git clone --single-branch [-b {<branch_name>|<tag_name>}] <url>
```

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

### Remote

Limpar as referência do remoto no seu repositório local (remover o que não é mais necessário):

```sh
git remote prune <remote>
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

#### Cache

Configurar:

```bash
git config --global credential.helper cache
# or seting the time
git config --global credential.helper 'cache --timeout 28800'
```

Limpar a senha do cache:

```bash
git credential-cache exit
```

#### Store

Configurar:

```bash
git config --global credential.helper store
# or seting the file
git config --global credential.helper 'store --file /path/to/.credentials-file'
```

_Setar_ o arquivo de configuração (_default_):

```bash
echo 'https://<user>:<token>@<domain>' >> ~/.git-credentials
```

#### Libsecret (Linux)

Programas necessários:
```sh
sudo apt install -y libsecret-1-dev
```

_Setup_:
1. _Buildar_ o binário: `sudo make --directory=/usr/share/doc/git/contrib/credential/libsecret`
1. _Setar_ o helper: `git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret`

_TIP/TRICK_:

- Para definir credenciais para usuários diferente do mesmo host (porém como consequência para cada repo):
```sh
git config --global credential.https://.useHttpPath true
```

---

_Desetar_ a configuração global:

```bash
git config --global --unset credential.helper {cache|store}
```

_OBSERVATIONS_:
- Pode-se utilizar os dois _helpers_ aonde caso não seja encontrado o helper do store será pedido a senha que posteriormente será gravada no cache.

### Configuration

_Setar_ usuário e email:
```sh
git config --global user.name <user>
git config --global user.email <email>
```

OBS: para setar usuário e email local troque a flag `--global` para `--local`.

Listar todas as configuração:
```sh
git config --list --show-origin
```

OBS: caso você esteja dentro de um repo também será mostrado as configurações locais do repo.

Trocar editor padrão:
```sh
git config --global core.editor <editor>
```

#### `includeIf` (_repo groups_)

Definir arquivo de configuração específico para todos os repos dentro de terminada pasta:
```sh
git config --global includeIf.'gitdir:~/path/to/folder/projects/'.path ./path/to/.gitconfig
```

- _OBSERVATIONS_:
    - Necessário a "/" no final do caminho do em `gitdir`;
    - O `.` no início do caminho do `.gitconfig` é a relação da _home_ do usuário.

### Bare

#### "Servidor Remoto" Local

1. Defina o servidor remoto local:
	`git clone --bare /path/to/local/project /mnt/project.git`
1. Adicione o servidor remoto local no projeto local:
	`git remote add drive /mnt/project.git`

_OBSERVATIONS_:
- Caso necessário outra pessoa pode pegar a mídia externa que está sendo usada como servidor externo, plugar em sua máquina, adiciona-lo como remote e pegar suas atualização com `pull`:
	1. `git remote add drive /mnt/project.git`
	1. `git pull drive main`

#### Expor "Servidor Remoto" Local

1. _Entre no "servidor remoto" local_
1. Atualize o _bare_:
	`git --bare update-server-info`
1. Troque os _hooks_ de update:
	`mv hooks/post-update{.sample,}`
1. Suba um mini servidor web (como em **python**):
	`python -m http.server 8000`
1. _Faça o clone teste_:
    `git clone http://localhost:8000 project`
1. <details>
    <summary>Acesse de fora</summary>

    - <details>
        <summary>Utilize uma VPN</summary>

        Para clonar, ao invés de usar `localhost`, utilize o IP da sua VPN ou seu _DDNS_.
    ou
    - <details>
        <summary>Utilize um <em>Reverse Proxy</em></summary>

        1. Exponha a porta 8000 como HTTP (que aponta para nosso mini _web server_):
            `ngrok http 8000`
        1. Clone de fora da rede com:
            `git clone https://<uuid>.ngrok.io project`
    </details>
    </details>
</details>

_OBSERVATIONS_:
- Sugestões VPN:
    - `PiVPN`
	- `tailscale`
	- `ZEROTIER`

### Commands

- _Printa_ o _hash_ do _commit_ em comum de duas _branchs_: `git merge-base <first_branch> <second_branch>`
- _Printa_ o _hash_ de objeto git do arquivo (seja pasta ou diretório): `git hash-object path/to/any-file`

### Tips & Tricks

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

#### Comparar Arquivos Entre Duas Commits/Branchs

```bash
git diff <src-branch/commit> <dst-branch/commit> -- file.any
```

#### Comparar Duas Branchs Pelo Commit Pai Mais Recente

```sh
# `git diff $(git merge-base <source> <target>) <target>` is an alias from git itself for:
git diff HEAD...<target_branch>
```

#### Splitar Commit's

Último _commit_:

1. _Com seu repo local limpo..._
1. Reseta o último _commit_ para a _worktree_: `git reset HEAD^`
1. Adicione e _commite_ conforme a necessidade.

OBS: necessário _force push_?

Algúm _commit_ no meio da árvore/história:

1. Use `rebase`: `git rebase -i <commit_hash>^`

OBS:

- simplesmente marque todos _commit's_ a serem editados com `e` ou `edit`;
- _reset_ o _commit_ atual com `git reset HEAD^` e _commite_ conforme desejado;
- será necessário _force push_;

#### Mesclar Sem Commitar

1. Mescle sem commitar (as alterações iram para o _index_ (_staging area_)): `git merge --no-commit <branch>`
1. _resolve conflicts and mark them as resolved (if exists)_
1. Saia do merge (as aterações continuaram no _index_): `git merge --quit`
1. Fça um `amend` para aplicar as alterações no último _commit_: `git commit --amend --no-edit`

_pipeline_ (work if not have conflicted):

```sh
git merge --no-commit <branch> && git merge --quit && git commit --amend --no-edit
```

#### Dar Rebase da Própria Branch (_self rebase_) Pelo Commit de `merge-base`

```sh
git rebase [-if] `git merge-base feature main`
```

OBS: será útil fazer dessa forma e não pegando de forma manual o último commit da branch quando antes do rebase tiver feito algum merge.

#### Personalização de URL

Inclua a sessão `url` no arquivo `.git/config`:

- Imbutir token de acesso:
```git
[url "https://<user>:<token>@"]
	insteadOf = https://
```
OBS: No final haverá a substituição: `https://remote.any/user/repo.git` -> `https://user:token@remote.any/user/repo.git`

- Redirecionar para o protocolo SSH:
```git
[url "ssh://git@"]
	insteadOf = https://
```
OBS:
- No final haverá a substituição: `https://remote.any/user/repo.git` -> `ssh://git@remote.any/user/repo.git`
- Tenha a chave ssh no agente
- O mesmo vale caso queira fazer o inverso, `SSH` to `HTTPS`
- Também é possível fazer via _CLI_: `git config --global url.'git@<remote>:'.insteadOf 'https://<remote>/'`

#### Aplicar Diff Patch Gerado com Cor

Quando for salvar um patch para ser aplicado posteriormente gere com:
```sh
git diff --no-color > /path/to/save/diff.patch
```

Caso esteja com cor aplique com:
```sh
cat -v /path/to/saved/diff.patch | sed 's/\^\[\[[[:digit:]]*m//g' | git apply -
```

#### Sobre `git config --get`

- Com a flag `--global`: listará as informações do arquivo de configuração global (`~/.gitconfig`) ou do sistema (`/etc/gitconfig` ou `/etc/git/gitconfig`);
- Com a flag ``: listará as informações de escopo do "grupo" (ver #includeIf-repo-groups);
- Com a flag `--local`: listará as informações do arquivo de configuração do repo local (`/path/to/project/.git/config`).

#### Descartar Somente Alterações do Index

1. `git stash --staged`
1. `git stash drop`

#### Alterar Modo de Prompt

Desabilitar o _prompt_ (git espera encontrar as credenciais no ambiente):
```sh
GIT_TERMINAL_PROMPT=0 <command>
```

Habilitar o _prompt_ (git forçara a entrada manual das credenciais):
```sh
GIT_TERMINAL_PROMPT=1 <command>
```

#### Remover Commit do Meio do Log

Utilize `git rebase -i` ou `git revert`. O **revert** é preferível por ser uma abordagem mais "segura" pois evitará pushs forçados, o que bagunçaria o histórico de todos (claro que se as alterações ainda não estiverem no remoto, utilizar o **rebase -i** não seria um problema).

#### _Author_ X _Commiter_

O autor é a pessoa que originalmente escreveu o código. O committer, por outro lado, é considerado a pessoa que cometeu o código em nome do autor original. Isso é importante no Git porque o Git permite reescrever o histórico ou aplicar patches em nome de outra pessoa.

#### Pegar Código de Saída de Status

_Exit status_ para arquivos modificados/deletados (**worktree**):
```sh
if git diff -s --exit-code <pathspec>; then
	echo not changed
else
	echo changed
fi
```

_Exit status_ para arquivos não traqueados (**untracked**):
```sh
git status --porcelain | grep '^\?\?'
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

#### Renomear Branch Local e Remota

1. `git branch -m <new_branch>`
1. `git push <remote> <remote>/<old_branch>:refs/heads/<new_branch> :<old_branch>`
1. `git fetch <remote>`
1. `git branch -u <remote>/<new_branch>`

_pipeline_:

```sh
git branch -m <new_branch> && git push <remote> <remote>/<old_branch>:refs/heads/<new_branch> :<old_branch> && git fetch <remote> && git branch -u <remote>/<new_branch>
```

#### Setar Manualmente Branch Upstream das Branchs Locais

Comando:
```sh
for branch in `git branch --color=never | sed -E 's/^[ \*] //g'`; do
	git switch "$branch" \
	&& git branch -u "origin/$branch"
done
```

### Git Playground

<http://git-school.github.io/visualizing-git/>

---

<a id="github_cli"></a>
## [GitHub CLI](#menu)

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
## [Arch Base](#menu)

### Pacman

Sincronização e atualiza os pacotes:

```bash
pacman -Syu
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

Mostra os arquivos do pacote:

```bash
pacman -Ql [-q] <package> [<package> ...] [| grep /bin]
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

Limpa o cache dos pacotes:
```sh
pacman -Sc [-c]
```

### AUR

Instalação manual:

1. Clone o repositório:
	`$ git clone '<repo>'`
1. Entre no repositório:
	`$ cd ./<repo>/`
1. Instale o pacote:
	- <details>
		<summary>With SUDO</summary>

		`$ sudo makepkg -srci`
	- <details>
		<summary>With ROOT</summary>

		1. `$ makepkg -src`
			- OBS: Caso reclame de dependência, instale com `pacman` e refaça essa estapa.
		1. `# pacman -U <package>.zst`
	</details>
	</details>

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
## [Android](#menu)

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

### Termux

Pós [instalação](https://f-droid.org/en/packages/com.termux/):
1. `pkg upgrade -y`
1. `pkg install -y ranger vim tree curl git iproute2`
1. `termux-setup-storage`

Usuário:
```sh
whoami
```

IP's:
```sh
ip -br -c a
```

Ver logs do sistema?
```sh
logcat 'syslog:*'
```

#### SSH

Programas necessários:
```sh
pkg install -y openssh
```

Iniciar o _daemon_:
```sh
sshd
```

Encerrar o _daemon_:
```sh
kill `find '/data/data/com.termux/files' -name 'sshd.pid' -exec cat '{}' \+ 2>&-`
```

##### Conexão

Via senha:
- Simplesmente defina uma senha com: `passwd`

Caso queira usar chaves (sem precisar definir uma senha para fazer a cópia da `.pub`):
1. Inicie o _daemon_ do SSH (`sshd`) no _host_;
1. No **termux** copia a chave pública do _host_:
	1. `scp <user>@<host>:~/.ssh/key.pub /tmp/key.pub`
	1. `cat /tmp/key.pub >> ~/.ssh/authorized_keys`
1. Caso deseje, pare o _daemon_ do SSH no _host_ agora.

#### PRoot Distro

Programas necessários:
```sh
pkg install -y proot-distro
```

_Command help_:
```sh
proot-distro
```

Listar _distros_ para instalação:
```sh
proot-distro list
```

Instalar _distro_:
```sh
proot-distro install <distro>
```

_Logar_ na _distro_:
```sh
proot-distro login <distro>
```

Remover _distro_:
```sh
proot-distro remove <distro>
```

Resetar _distro_ do zero:
```sh
proot-distro reset <distro>
```

---

<a id="miscellaneous"></a>
## [Miscellaneous](#menu)

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

Itens colapsados:

```md
## Markdown Details

<details open>
<summary>Summary 1</summary>

Ordered list:
1. Item 1.1
1. Item 1.2
1. <details>
    <summary>Summary 2 (Item 1.3)</summary>

    - Item 1.3.1
    - Item 1.3.2
    - Item 1.3.3
1. Item 1.4

</details>
</details>
```

Comentário interno:
```md
[//]: # (internal comment)
```

Imagens clicaveis:
```md
[1]: <image-url> "image text"

[![alt text][1]](<link-to>)
```

Imagens clicaveis:
```md
[![alt text](<image-url>)](<link-to> "image text")
```

---

<a id="games"></a>
## [Games](#menu)

### Steam

Lauch Options para CS:
```
gamemoderun %command% [-sdlaudiodriver pipewire] -nojoy -novid -vulkan -fullscreen
```

---

<a id="estudos"></a>
## [Estudos](#menu)

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
