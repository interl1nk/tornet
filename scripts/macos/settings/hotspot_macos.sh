#! /bin/bash

function hot_spot_macos() {
    log INFO "Configuring MacOS network"

    networksetup -setsocksfirewallproxy "Wi-Fi" 127.0.0.1 9050
    networksetup -setsocksfirewallproxystate "Wi-Fi" on

    log OK "MacOS network configured"
}

function restore_settings() {
    log INFO "Restoring original settings"
    networksetup -setsocksfirewallproxystate "Wi-Fi" off
    brew services stop tor
}
