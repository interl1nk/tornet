#! /bin/bash

source ./scripts/pkg/assets/colors.sh
source ./scripts/pkg/network/internet_connection.sh

source ./scripts/macos/network/network_manager.sh

function software_macos() {
    echo "$(set_color "green")[✓]$(set_color "*") Using MacOS: $OS"

    get_active_interface_macos
    check_internet_connection || { echo "Exiting due to no internet."; exit 1; }
}
