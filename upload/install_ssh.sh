#!/bin/bash
set -euox pipefail
IFS=$'\n\t'

whoami

echo "Install SSH server."
apt-get install -y openssh-server

echo "Open port to handle SSH."
raspi-config nonint do_ssh 0

echo "Disable password login."
function comment() {
    sed -re "s:^($1\s+):# \1:" -i /etc/ssh/sshd_config
}
comment ChallengeResponseAuthentication
comment PasswordAuthentication
comment UsePAM
comment PermitRootLogin

cat >>/etc/ssh/sshd_config <<EOF
ChallengeResponseAuthentication no
PasswordAuthentication no
UsePAM no
PermitRootLogin no
EOF

echo "Reload SSH configuration to actually disable password logins."
systemctl reload ssh

echo "Uninstall the SSH installer service."
mv -f /etc/rc.local.original /etc/rc.local
