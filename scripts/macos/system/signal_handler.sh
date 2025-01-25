#! /bin/bash

#source ./scripts/macos/network/hot_spot_proxy.sh
source ./scripts/macos/setup/configurations/tor_config.sh

function sigint_handler() {
    log ALERT "Caught SIGINT"

    restore_hot_spot_proxy
    delete_tor_config

    exit 0
}
