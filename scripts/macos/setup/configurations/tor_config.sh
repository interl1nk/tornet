#! /bin/bash

source ./scripts/macos/setup/configurations/bridge.sh

TOR_CONFIG_MACOS="/opt/homebrew/etc/tor/torrc"
BRIDGE_FILE="bridge.txt"

function create_tor_config() {
    log INFO "Verifying Tor configuration"

    if [[ ! -f "$TOR_CONFIG_MACOS" ]]; then
        log ALERT "Tor configuration file not found"

        log INFO "Creating torrc configuration file"
        touch "$TOR_CONFIG_MACOS"

#        echo "UseBridges 1" >> "$TOR_CONFIG_MACOS"
        log OK "Created new Tor configuration file with default settings"
    else
        log OK "Tor configuration file found: $TOR_CONFIG_MACOS"
    fi

    if ! grep -q '^#.*BridgeRelay' "$TOR_CONFIG_MACOS"; then
        sed -i '' 's/^\(BridgeRelay\)/#\1/' "$TOR_CONFIG_MACOS"
    fi

    if ! grep -q '^#.*BridgeDistribution' "$TOR_CONFIG_MACOS"; then
        sed -i '' 's/^\(BridgeDistribution\)/#\1/' "$TOR_CONFIG_MACOS"
    fi
}

function update_tor_config() {
    log INFO "Updating Tor configuration: $TOR_CONFIG_MACOS"

    local bridges=()
    while IFS= read -r line || [[ -n "$line" ]]; do
        bridges+=("$line")
    done < <(get_bridges_from_file "$BRIDGE_FILE")

    if [[ ${#bridges[@]} -eq 0 ]]; then
        log ERROR "Cannot update Tor config without valid bridges."
        exit 1
    fi

    # Получаем первый мост из массива
    local new_bridge="${bridges[0]}"

    # Создание резервной копии
    local backup_file="${TOR_CONFIG_MACOS}.bak"
    cp "$TOR_CONFIG_MACOS" "$backup_file"
    log INFO "Backup created: $backup_file"

    # Включение UseBridges
    if ! grep -q '^UseBridges 1' "$TOR_CONFIG_MACOS"; then
        echo 'UseBridges 1' | tee -a "$TOR_CONFIG_MACOS" > /dev/null
    fi

    # Обновление моста
    sed -i '' '/^Bridge /d' "$TOR_CONFIG_MACOS"
    echo "Bridge $new_bridge" | tee -a "$TOR_CONFIG_MACOS" > /dev/null
    log OK "Bridge updated to: $new_bridge"

    # Удаление использованного моста из файла
    if [[ -s "$BRIDGE_FILE" ]]; then
        sed -i '' '1d' "$BRIDGE_FILE"
        log INFO "Used bridge removed from the bridge file."
    else
        log ALERT "Bridge file is already empty. No action needed."
    fi
}

function verify_tor_config() {
    log INFO "Verifying Tor configuration"

    # Проверяем конфигурацию и подавляем вывод
    if tor --verify-config > /dev/null 2>&1; then
        log OK "Tor configuration was valid"
    else
        log ERROR "Tor configuration is invalid."
    fi
}

function delete_tor_config() {
    if [[ -f "$TOR_CONFIG_MACOS" ]]; then
        rm "$TOR_CONFIG_MACOS"
        rm "$TOR_CONFIG_MACOS.bak"

        if [[ $? -eq 0 ]]; then
            log INFO "Successfully removed"
        else
            log ERROR "Failed to remove $TOR_CONFIG_MACOS"
        fi
    else
        log ALERT "Config file $TOR_CONFIG_MACOS does not exist"
    fi
}
