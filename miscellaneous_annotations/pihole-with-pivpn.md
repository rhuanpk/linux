# Configuração do _PiHole_ com _PiVPN_

## _Deploy_ e Configuração do Servidor

### Criação do Servidor

1. Criar um _app_ do **pihole** pelo _markplace_.

### Configuração do Servidor

Depois de _deployado_ o servidor, conecte via `ssh`:

1. Atualize o servidor:
	`sudo apt update && sudo apt -y upgrade`

1. Guarde o nome do _host_:
	`hostname`

1. Troque o _hostname_ se desejar:
	`hostnamectl set-hostname <hostname>`

1. Verifique o _timezone_ do servidor:
	`timedatectl`

1. Caso precise trocar, verifique os _timezones_:
	`timedatectl list-timezones`

1. Caso precise setar um novo _timezone_:
	`timedatectl set-timezone <timezone>`

1. Instale o pacote _unbound_:
	`sudo apt install -y unbound`

1. Crite e edite o arquivo `/etc/unbound/unbound.conf.d/pi-hole.conf` com as linhas do _link_:
	[Pihole docs (configure-unbound)](https://docs.pi-hole.net/guides/dns/unbound/#configure-unbound);

1. Reinicie o serviço do _unbound_:
	`service unbound restart`

1. Execute o _dig_:
	`dig pi-hole.net @127.0.0.1 -p 5335`

## Configuração do _PiHole_

1. Acesse o painel administrativo do _pihole_:
	`https://<server_ip>/admin`

1. `Settings » DNS`:

	1. Desabilite todos os _DNS's_ _defaults_ (Google, CloudFlare);

	1. _Sete_ um _DNS_ customizado:
		`127.0.0.1#5335`

	1. Salve as alterações.

## Instalação e Configaração do _PiVPN_

### Instalação do _PiVPN_

1. `curl -L https://install.pivpn.io | bash -`

	1. `<Ok>`;

	1. `<Ok>`;

	1. `<Ok>`;

	1. `<Ok>`;

	1. Escolha um usuário com `sudo`;

	1. Escolha o modo de instalação (nesse tutorial: `WireGuard`);

	1. _Default port_ » `<Ok>`;

	1. `<Yes>`;

	1. `<Yes>`;

	1. _DNS Entry_ » `<Ok>`;

	1. `Entre com o hostname do servidor » <Ok>`;

	1. `<Yes>`;

	1. `<Ok>`;

	1. `<Ok>`;

	1. `<Yes>`;

	1. `<Ok>`;

	1. `<Yes>`;

	1. `<Ok>`.

### Configuração do _PiVPN_

1. Adicione um perfil da _VPN_ para algum _device_:
	`pivpn -a -n <device_name>`

Uso o comando `pivpn -qr` para ver os QRCodes dos perfis para o _device_ na _VPN_ (pelo aplicativo do _WireGuard_ por exemplo se for em _smartphone_).

Ou

Ou importe os arquivos de dentro de `~/configs/` caso esteja utilizando o aplicativo do _WireGuard Desktop_.

---

_REFERENCELINKS_:

- [Vídeo referência (origem)](https://www.youtube.com/watch?v=COz3SopM92U).
