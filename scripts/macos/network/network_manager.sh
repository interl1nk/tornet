#! /bin/bash

source ./scripts/pkg/assets/colors.sh

function get_active_interface_macos() {
    log INFO "Detecting active network interface with internet access"

    default_interface=$(route -n get default | awk '/interface: / {print $2}')

    if [ -z "$default_interface" ]; then
        log ERROR "No active network interface with internet access detected"
        return 1
    else
        log OK "Active interface detected: $default_interface"
        return 0
    fi
}
