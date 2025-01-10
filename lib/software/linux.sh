#! /bin/bash

source ./pkg/assets/colors.sh
source ./pkg/network/linux/network_manager.sh
source ./pkg/network/internet_connection.sh

function software_linux() {
    echo "$(set_color "green")✓$(set_color "*") Using Linux: $OS"

    get_active_interface_linux
    check_internet_connection || { echo "Exiting due to no internet."; exit 1; }
}
