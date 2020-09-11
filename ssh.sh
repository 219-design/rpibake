#!/bin/bash
set -euox pipefail
IFS=$'\n\t'

source vars

ssh \
    pi@localhost \
    -p $Q_HOST_SSH_PORT \
    -i $Q_IDENTITY_SSH \
    -o ConnectTimeout=0 \
    $@ \
;