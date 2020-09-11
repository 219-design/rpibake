#!/bin/bash
set -euox pipefail
IFS=$'\n\t'

echo "Install SSH server."
sudo apt-get install -y openssh-server

echo "Open port to handle SSH."
sudo rasp-config nonint do_ssh 0

echo "Uninstall the SSH installer service."
sudo rm -f /lib/systemd/system/install_ssh.service
sudo systemctl daemon-reload
