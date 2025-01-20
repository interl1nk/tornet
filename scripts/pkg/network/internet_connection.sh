#! /bin/bash

function check_internet_connection() {
    log INFO "Checking internet connection"

    if ping -c 1 8.8.8.8 &> /dev/null; then
        log OK "Internet connection is active"
    else
        log ERROR "No internet connection detected."
        return 1
    fi
}
