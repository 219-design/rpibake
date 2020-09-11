#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo apt-get -y install \
    qemu-system-arm \
    qemu-user \
;
