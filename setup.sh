#! /bin/bash

source ./scripts/linux/software/software.sh
source ./scripts/linux/services/services.sh

source ./scripts/macos/software/software.sh
source ./scripts/macos/services/services.sh
source ./scripts/macos/settings/proxy_config.sh
source ./scripts/macos/settings/hotspot_macos.sh
source ./scripts/macos/settings/bridge.sh
source ./scripts/macos/settings/sigint.sh

source ./scripts/pkg/logging/freelog.sh

trap handle_sigint SIGINT

function setup() {
    echo "@Freeman"

    OS=$(uname)

    if [[ "$OS" == "Linux" ]]; then
        software_linux
        services_linux
    elif [[ "$OS" == "Darwin" ]]; then
        software_macos
        services_macos
        change_proxy_config
        hot_spot_macos
        get_bridge
    else
        log ERROR "Unsupported OS: $OS"
        return 1
    fi

    while true; do
        sleep 1
    done
}

setup
