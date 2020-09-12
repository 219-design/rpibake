#!/bin/bash
set -euox pipefail
IFS=$'\n\t'

source $ROOT_DIR/scripts/vars

function pipe_in() {
    ssh \
        pi@localhost \
        -p $Q_HOST_SSH_PORT \
        -i $Q_IDENTITY_SSH \
        -o ConnectTimeout=0 \
        $@ \
    ;
}

until pipe_in
do
    sleep 5
done