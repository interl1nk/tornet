#! /bin/bash

source ./scripts/pkg/assets/colors.sh

source ./scripts/linux/software/software.sh
source ./scripts/linux/services/services.sh

source ./scripts/macos/software/software.sh
source ./scripts/macos/services/services.sh
source ./scripts/macos/settings/proxy_config.sh
source ./scripts/macos/settings/hotspot_macos.sh
source ./scripts/macos/settings/sigint.sh

trap handle_sigint SIGINT

function setup() {
    echo "Hello, you are using TorNet!"

    OS=$(uname)

    if [[ "$OS" == "Linux" ]]; then
        software_linux
        services_linux
    elif [[ "$OS" == "Darwin" ]]; then
        software_macos
        services_macos
        change_proxy_config
        hot_spot_macos
    else
        echo "$(set_color "purple")[ERROR]$(set_color "*"): Unsupported OS: $OS"
        return 1
    fi

    while true; do
        sleep 1
    done
}

setup
