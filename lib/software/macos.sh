#! /bin/bash

source ./pkg/assets/colors.sh
source ./pkg/network/macos/network_manager.sh
source ./pkg/network/internet_connection.sh

function software_macos() {
    echo "$(set_color "green")✓$(set_color "*") Using MacOS: $OS"

    get_active_interface_macos
    check_internet_connection || { echo "Exiting due to no internet."; exit 1; }
}
