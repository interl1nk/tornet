#! /bin/bash

source ./scripts/pkg/assets/colors.sh

function hot_spot_macos() {
    echo "$(set_color "purple")[•]$(set_color "*") Configuring MacOS network..."
    echo "$(set_color "yellow")[ALERT]$(set_color "*"): Enter your password below:"

    sudo networksetup -setsocksfirewallproxy "Wi-Fi" 127.0.0.1 9050
    sudo networksetup -setsocksfirewallproxystate "Wi-Fi" on

    echo "$(set_color "green")[✓]$(set_color "*") MacOS network configured."
}

function restore_settings() {
    echo "$(set_color "purple")[•]$(set_color "*") Restoring original settings..."
    sudo networksetup -setsocksfirewallproxystate "Wi-Fi" off
}
