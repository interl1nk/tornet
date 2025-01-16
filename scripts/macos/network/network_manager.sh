#! /bin/bash

source ./scripts/pkg/assets/colors.sh

function get_active_interface_macos() {
    echo "$(set_color "purple")[•]$(set_color "*") Detecting active network interface with internet access..."

    default_interface=$(route -n get default | awk '/interface: / {print $2}')

    if [ -z "$default_interface" ]; then
        echo "$(set_color "red")No active network interface with internet access detected$(set_color "*")"
        return 1
    else
        echo "$(set_color "green")[✓]$(set_color "*") Active interface detected: $default_interface"
        return 0
    fi
}
