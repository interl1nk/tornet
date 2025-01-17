#! /bin/bash

source ./scripts/pkg/assets/colors.sh

TOR_CONFIG_MACOS="/usr/local/etc/tor/torrc"

function get_bridge() {
  go run cmd/bin.go -mode=bridge
}

function change_tor_config() {
    echo "$(set_color "purple")[•]$(set_color "*") Configuring the Tor configuration"

    if [[ ! -f "$TOR_CONFIG_MACOS" ]]; then
        echo "$(set_color "red")[ERROR]$(set_color "*"): Tor configuration file not found at $TOR_CONFIG_MACOS. Ensure Tor is installed."
        exit 1
    fi

    if ! grep -q '^UseBridges 1' "$TOR_CONFIG_MACOS"; then
        echo 'UseBridges 1' | tee -a "$TOR_CONFIG_MACOS" > /dev/null
    fi

    BRIDGE="obfs4 <IP-адрес>:<порт> <fingerprint> cert=<сертификат> iat-mode=0"
    if ! grep -q "^Bridge $BRIDGE" "$TOR_CONFIG_MACOS"; then
        echo "$BRIDGE" | tee -a "$TOR_CONFIG_MACOS" > /dev/null
    fi

    echo "$(set_color "green")[✓]$(set_color "*") Tor configuration updated."
}

function add_or_replace_bridge() {
    local new_bridge="$1"

    echo "$(set_color "purple")[•]$(set_color "*") Updating Tor bridge configuration..."

    if [[ ! -f "$TOR_CONFIG_MACOS" ]]; then
        echo "$(set_color "red")[ERROR]$(set_color "*") Tor configuration file not found at $TOR_CONFIG_MACOS. Ensure Tor is installed."
        exit 1
    fi

    cp "$TOR_CONFIG_MACOS" "${TOR_CONFIG_MACOS}.bak"
    echo "$(set_color "yellow")[•]$(set_color "*") Backup created: ${TOR_CONFIG_MACOS}.bak"

    if ! grep -q '^UseBridges 1' "$TOR_CONFIG_MACOS"; then
        echo 'UseBridges 1' | tee -a "$TOR_CONFIG_MACOS" > /dev/null
    fi

    sed -i '' '/^Bridge /d' "$TOR_CONFIG_MACOS"

    echo "Bridge $new_bridge" | tee -a "$TOR_CONFIG_MACOS" > /dev/null
    echo "$(set_color "green")[✓]$(set_color "*") Bridge updated to: $new_bridge"
}

# Пример использования
# Передать новый мост как первый аргумент в скрипт
if [[ -z "$1" ]]; then
    echo "$(set_color "red")[✗]$(set_color "*") Usage: $0 '<new_bridge>'"
    echo "Example: $0 'obfs4 <IP-адрес>:<порт> <fingerprint> cert=<сертификат> iat-mode=0'"
    exit 1
fi

add_or_replace_bridge "$1"
