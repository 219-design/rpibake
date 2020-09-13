#!/bin/bash
set -euox pipefail
IFS=$'\n\t'

source $ROOT_DIR/scripts/vars

sudo qemu-system-arm \
    -M versatilepb \
    -cpu arm1176 \
    -m 256 \
    -append "root=/dev/sda2 rootfstype=ext4 rw" \
    -net nic \
    -net user,hostfwd=tcp::$Q_HOST_SSH_PORT-:22 \
    -net tap,ifname=vnet0,script=no,downscript=no \
    -drive file=$Q_IMG,format=raw \
    -dtb $Q_DTB \
    -kernel $Q_KERNEL \
    -no-reboot \
;