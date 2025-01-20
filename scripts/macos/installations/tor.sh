#! /bin/bash

function tor_service_macos() {
    log INFO "Checking Tor status"

    if ! brew list --formula | grep -q "^tor$"; then
        log ALERT "Tor is not installed"
        log INFO "Installing Tor via Homebrew"

        if brew install tor &> /dev/null; then
            log OK "Tor has been installed successfully"
        else
            log ERROR "Failed to install Tor. Please check your Homebrew setup."
            return 1
        fi
    fi

    tor_status=$(brew services list | grep tor)

    if echo "$tor_status" | grep -q "started\|Active: active"; then
        log OK "Service Tor is running"
    else
        log ALERT "Tor is down"
        log INFO "Starting Tor"

        if tor_output=$(brew services start tor 2>&1); then
            log OK "Service Tor is running"
        else
            log ERROR "Error starting Tor."
            echo "$tor_output"
            return 1
        fi
    fi
}
