#! /bin/bash

function tor_service_linux() {
    echo "$(set_color "purple")•$(set_color "*") Checking Tor status..."

    if ! command -v tor &> /dev/null; then
        echo "$(set_color "red")Error: Tor is not installed. Please install Tor first.$(set_color "*")"
        return 1
    fi

    tor_status=$(systemctl is-active tor)
    tor_start="sudo systemctl start tor"

    if [ "$tor_status" == "active" ]; then
        echo "$(set_color "green")✓$(set_color "*") Service Tor is running."
    else
        echo "$(set_color "red")Tor is down. Starting Tor..."

        if tor_output=$($tor_start 2>&1); then
            echo -e "\n$(set_color "green")Success ✓$(set_color "*")\n"
        else
            echo "$(set_color "red")Error:$(set_color "*") error starting Tor."
            echo "$tor_output"
            return 1
        fi
    fi
}

function tor_service_macos() {
    echo "$(set_color "purple")•$(set_color "*") Checking Tor status..."

    if ! brew list tor &> /dev/null; then
        echo "$(set_color "red")Error:$(set_color "*") Tor is not installed via Homebrew. Please install Tor first."
        return 1
    fi

    tor_status=$(brew services list | grep tor)

    if echo "$tor_status" | grep -q "started\|Active: active"; then
        echo "$(set_color "green")✓$(set_color "*") Service Tor is running."
    else
        echo "$(set_color "yellow")•$(set_color "*") Tor is down."
        echo "$(set_color "purple")•$(set_color "*") Starting Tor..."

        if tor_output=$(brew services start tor 2>&1); then
            echo "$(set_color "green")✓$(set_color "*") Service Tor is running."
        else
            echo "$(set_color "red")Error:$(set_color "*") error starting Tor."
            echo "$tor_output"
            return 1
        fi
    fi
}
