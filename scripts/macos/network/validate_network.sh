#! /bin/bash

source ./scripts/macos/network/active_interface.sh
source ./scripts/shared/internet/internet_connection.sh

function validate_network() {
    get_active_interface
    check_internet_connection || { log ERROR "Exiting due to no internet."; exit 1; }
}
