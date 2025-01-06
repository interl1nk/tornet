#! /bin/bash

source ./pkg/assets/colors.sh

function get_active_interface_linux() {
    echo "$(set_color "purple")•$(set_color "*") Detecting active network interface with internet access..."

    default_interface=$(ip route | grep default | awk '{print $5}')

    if [ -z "$default_interface" ]; then
        echo "$(set_color "red")No active network interface with internet access detected$(set_color "*")"
        return 1
    else
        echo "$(set_color "green")✓$(set_color "*") Active interface detected: $default_interface"
        return 0
    fi
}


function get_active_interface_macos() {
    echo "$(set_color "purple")•$(set_color "*") Detecting active network interface with internet access..."

    default_interface=$(route -n get default | awk '/interface: / {print $2}')

    if [ -z "$default_interface" ]; then
        echo "$(set_color "red")No active network interface with internet access detected$(set_color "*")"
        return 1
    else
        echo "$(set_color "green")✓$(set_color "*") Active interface detected: $default_interface"
        return 0
    fi
}

function check_internet_connection() {
    echo "$(set_color "purple")•$(set_color "*") Checking internet connection..."

    if ping -c 1 8.8.8.8 &> /dev/null; then
        echo "$(set_color "green")✓$(set_color "*") Internet connection is active"
    else
        echo "$(set_color "red")No internet connection detected ✗$(set_color "*")"
        return 1
    fi
}
