#! /bin/bash

source ./scripts/pkg/assets/colors.sh

function tor_service_macos() {
    echo "$(set_color "purple")[•]$(set_color "*") Checking Tor status..."

    if ! brew list --formula | grep -q "^tor$"; then
        echo "$(set_color "yellow")[ALERT]$(set_color "*"): Tor is not installed via Homebrew. Please install Tor first."
        echo "$(set_color "purple")[•]$(set_color "*") Installing Tor via Homebrew..."

        if brew install tor &> /dev/null; then
            echo "$(set_color "green")[✓]$(set_color "*") Tor has been installed successfully."
        else
            echo "$(set_color "red")[ERROR]$(set_color "*"): Failed to install Tor. Please check your Homebrew setup."
            return 1
        fi
    fi

    tor_status=$(brew services list | grep tor)

    if echo "$tor_status" | grep -q "started\|Active: active"; then
        echo "$(set_color "green")[✓]$(set_color "*") Service Tor is running."
    else
        echo "$(set_color "yellow")[ALERT]$(set_color "*"): Tor is down."
        echo "$(set_color "purple")[•]$(set_color "*") Starting Tor..."

        if tor_output=$(brew services start tor 2>&1); then
            echo "$(set_color "green")[✓]$(set_color "*") Service Tor is running."
        else
            echo "$(set_color "red")[ERROR]$(set_color "*"): Error starting Tor."
            echo "$tor_output"
            return 1
        fi
    fi
}
