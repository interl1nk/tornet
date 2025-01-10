#! /bin/bash

source ./lib/software/linux.sh
source ./lib/services/linux.sh

source ./lib/software/macos.sh
source ./lib/services/macos.sh

source ./pkg/settings/proxy_config.sh
source ./pkg/settings/hotspot_macos.sh

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
        echo "Unsupported OS: $OS"
        return 1
    fi
}

setup
