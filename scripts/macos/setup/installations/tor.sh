#! /bin/bash

function install_tor() {
    log INFO "Checking if Tor is installed"

    if ! brew list --formula | grep -q "^tor$"; then
        log ALERT "Tor is not installed"
        log INFO "Installing Tor"

        if brew install tor &> /dev/null; then
            log OK "Tor has been installed successfully"
        else
            log ERROR "Failed to install Tor. Please check your Homebrew setup."
            return 1
        fi
    else
        log OK "Tor is already installed"
    fi
}

function start_tor() {
    log INFO "Checking Tor service status..."

    tor_status=$(brew services list | grep tor)

    if echo "$tor_status" | grep -q "started\|Active: active"; then
        log OK "Tor service is already running"
    else
        log ALERT "Tor service is not running"
        log INFO "Starting Tor service"

        if tor_output=$(brew services start tor 2>&1); then
            log OK "Tor service has been started successfully"
        else
            log ERROR "Failed to start Tor service."
            echo "$tor_output"
            return 1
        fi
    fi
}
