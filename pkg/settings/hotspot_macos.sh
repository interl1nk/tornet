#! /bin/bash

function hot_spot_macos() {
    sudo networksetup -setsocksfirewallproxy "Wi-Fi" 127.0.0.1 9050
    sudo networksetup -setsocksfirewallproxystate "Wi-Fi" on
}