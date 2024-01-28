#!/usr/bin/bash

# Go to into a new or existing vagrant workspace.

# >>> variables declaration!
readonly version='1.0.0'
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"

SUDO='sudo'
WORKSPACE_FOLDER='/tmp/vagrant'
if grep -q '^ID=debian$' /etc/*release /usr/lib/*release; then
	IS_DEBIAN='true'
else
	IS_DEBIAN='false'
fi

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Verify if vagrant temporary workspace folder already exists and suggest enter it otherwise creates this.

Usage: $script [<options>]

Options:
	-s: Forces keep sudo;
	-r: Forces unset sudo;
	-v: Print version;
	-h: Print this help.
EOF
}

privileges() {
	FLAG_SUDO="${1:?needs sudo flag}"
	FLAG_ROOT="${2:?needs root flag}"
	if [[ -z "$SUDO" && "$uid" -ne 0 ]]; then
		echo "$script: error: run with root privileges"
		exit 1
	elif ! "$FLAG_SUDO"; then
		if "$FLAG_ROOT" || [ "$uid" -eq 0 ]; then
			unset SUDO
		fi
	fi
}

check-needs() {
	privileges false false
	PACKAGES=('vagrant')
	if "$IS_DEBIAN"; then
		PACKAGES+=('vagrant-libvirt' 'libvirt-daemon-system')
	fi
	for package in "${PACKAGES[@]}"; do
		if ! dpkg -s "$package" &>/dev/null; then
			read -p "$script: info: is needed the \"$package\" package, install? [Y/n] " answer
			[ -z "$answer" ] || [ 'y' = "${answer,,}" ] && {
				if ! $SUDO apt install -y "$package" && [ "$package" = 'vagrant' ]; then
					cat <<- EOF
						$script: warn: vagrant repository may not be configured, check how to do this on:
						https://github.com/rhuanpk/studies/blob/main/sysadmin/vagrant/vagrant-notes.md#installation
					EOF
					continue
				fi
			}
		fi
	done
}

# >>> pre statements!
check-needs

if "$IS_DEBIAN" && ! groups | grep -q 'libvirt'; then
	$SUDO usermod -aG libvirt "${USER:-`whoami`}"
fi

while getopts 'srvh' option; do
	case "$option" in
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

privileges false false

# ***** PROGRAM START *****
echo -e "$script: hint: search vagrant boxes in: https://vagrantcloud.com/search"
[ -d "$WORKSPACE_FOLDER/" ] && {
	cat <<- EOF
		$script: info: vagrant workspace folder already exists
		$script: info: enter it running: cd "$WORKSPACE_FOLDER/"
	EOF
} || {
	mkdir -p "$WORKSPACE_FOLDER/"
	cd "$WORKSPACE_FOLDER/"
	vagrant init -m
cat << \EOF > "$WORKSPACE_FOLDER/Vagrantfile"
Vagrant.configure("2") do |config|
  config.vm.box = "debian/buster64"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  #config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.provider "qemu" do |qe|
    qe.qemu_dir = "/usr/bin/"
    qe.arch="x86_64"
    qe.memory = "512"
    qe.smp = "1"

    # need for x86_64
    qe.machine = "q35"
    qe.cpu = "max"
    qe.net_device = "virtio-net-pci"

    # it seems this box need a VGA device (the debug serial port doesn't work... I don't know why)
    qe.extra_qemu_args = %w(-vga std)

    #config.vm.provision "shell", inline: <<-SHELL
    #  apt update && apt upgrade -y && apt install -y nginx
    #SHELL
  end
end
EOF
	vagrant plugin install 'vagrant-qemu'
	cat <<- EOF
		$script: info: everything seems fine
		$script: hint: go to workspace folder running: cd "$WORKSPACE_FOLDER/"
		$script: hint: and upload the vm: vagrant up
	EOF
}
