#! /bin/bash

TOR_CONFIG_MACOS="/opt/homebrew/etc/tor/torrc"
BRIDGE_FILE="bridge.txt"

function verify_tor_config() {
    log INFO "Verifying Tor configuration"

    if [[ ! -f "$TOR_CONFIG_MACOS" ]]; then
        log ALERT "Tor configuration file not found. Creating"
        touch "$TOR_CONFIG_MACOS"
        echo "UseBridges 1" >> "$TOR_CONFIG_MACOS"
        log OK "Created new Tor configuration file with default settings"
    else
        log OK "Tor configuration file found: $TOR_CONFIG_MACOS."
    fi

    if [[ ! -f "$BRIDGE_FILE" ]]; then
        log ERROR "Bridge file not found at $BRIDGE_FILE."
        exit 1
    fi

    if ! grep -q '^#.*BridgeRelay' "$TOR_CONFIG_MACOS"; then
        sed -i '' 's/^\(BridgeRelay\)/#\1/' "$TOR_CONFIG_MACOS"
    fi

    if ! grep -q '^#.*BridgeDistribution' "$TOR_CONFIG_MACOS"; then
        sed -i '' 's/^\(BridgeDistribution\)/#\1/' "$TOR_CONFIG_MACOS"
    fi
}

function update_tor_config() {
    verify_tor_config

    local bridges=()
    while IFS= read -r line; do
        bridges+=("$line")
    done < "$BRIDGE_FILE"

    if [[ ${#bridges[@]} -eq 0 ]]; then
        log ERROR "Bridges file is empty or contains invalid data."
        exit 1
    fi

    local new_bridge="${bridges[0]}"

    cp "$TOR_CONFIG_MACOS" "${TOR_CONFIG_MACOS}.bak"
    log INFO "Backup created: ${TOR_CONFIG_MACOS}.bak"

    if ! grep -q '^UseBridges 1' "$TOR_CONFIG_MACOS"; then
        echo 'UseBridges 1' | tee -a "$TOR_CONFIG_MACOS" > /dev/null
    fi

    sed -i '' '/^Bridge /d' "$TOR_CONFIG_MACOS"
    echo "Bridge $new_bridge" | tee -a "$TOR_CONFIG_MACOS" > /dev/null
    log OK "Bridge updated to: $new_bridge"

    sed -i '' '1d' "$BRIDGE_FILE"
    log INFO "Used bridge removed from the bridge file"
}

update_tor_config
