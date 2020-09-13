#!/bin/bash
set -euox pipefail
IFS=$'\n\t'

source $ROOT_DIR/scripts/vars

echo "Mount disk."
LOOPBACK=$(sudo losetup -f)
sudo losetup -P $LOOPBACK $Q_IMG
PART_BOOT=$(mktemp -d)
PART_USER=$(mktemp -d)
sudo mount ${LOOPBACK}p1 $PART_BOOT
sudo mount ${LOOPBACK}p2 $PART_USER

function unmount_disks() {
    echo "Unmount disk."
    sudo umount $PART_BOOT
    sudo umount $PART_USER
}
trap unmount_disks EXIT

echo "Generate custom SSH key."
if [[ -f .user/id_rsa ]]
then
    echo "Key exists, not regenerating."
else
    mkdir -p .user/
    ssh-keygen -b 4096 -t rsa -f .user/id_rsa -q -N ""
fi

echo "Copy general upload items onto disk."
rsync -vrlpt --delete-delay upload/ $PART_USER/home/pi/upload/

echo "Install SSH keys."
sudo mkdir -p $PART_USER/home/pi/.ssh
sudo cp .user/id_rsa.pub $PART_USER/home/pi/.ssh/authorized_keys

echo "Install SSH server installer."
sudo mv $PART_USER/etc/rc.local $PART_USER/etc/rc.local.original
sudo cp mount/rc.local $PART_USER/etc/

echo "Success!"