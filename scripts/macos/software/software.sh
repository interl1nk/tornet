#! /bin/bash

source ./scripts/macos/network/network_manager.sh
source ./scripts/pkg/network/internet_connection.sh

function software_macos() {
    log INFO "Using MacOS: $OS"

    get_active_interface_macos
    check_internet_connection || { log ERROR "Exiting due to no internet."; exit 1; }
}
