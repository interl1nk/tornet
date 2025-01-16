#! /bin/bash

source ./scripts/pkg/assets/colors.sh
source ./scripts/pkg/network/internet_connection.sh

source ./scripts/linux/network/network_manager.sh

function software_linux() {
    echo "$(set_color "green")[✓]$(set_color "*") Using Linux: $OS"

    get_active_interface_linux
    check_internet_connection || { echo "Exiting due to no internet."; exit 1; }
}
