#! /bin/bash

function install_proxychains() {
    log INFO "Checking proxychains-ng"

    if ! brew list --formula | grep -q "^proxychains-ng$"; then
        log ALERT "proxychains-ng is not installed"
        log INFO "Installing proxychains-ng via Homebrew"

        if brew install proxychains-ng &> /dev/null; then
            log OK "proxychains-ng has been installed successfully"
        else
            log ERROR "Failed to install proxychains-ng. Please check your Homebrew setup."
            return 1
        fi
    else
        log OK "Checked"
    fi
}
