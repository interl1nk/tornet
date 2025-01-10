#! /bin/bash

source ./pkg/assets/colors.sh

function check_internet_connection() {
    echo "$(set_color "purple")•$(set_color "*") Checking internet connection..."

    if ping -c 1 8.8.8.8 &> /dev/null; then
        echo "$(set_color "green")✓$(set_color "*") Internet connection is active"
    else
        echo "$(set_color "red")No internet connection detected ✗$(set_color "*")"
        return 1
    fi
}
