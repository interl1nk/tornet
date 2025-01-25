#! /bin/bash

source ./scripts/macos/macos.sh
source ./scripts/shared/logging/freelog.sh

function main() {
    echo "@Freeman"

    OS=$(uname)

    if [[ "$OS" == "Linux" ]]; then
        echo "Downloading..."
    elif [[ "$OS" == "Darwin" ]]; then
        macos_setup
    else
        log ERROR "Unsupported OS: $OS"
        return 1
    fi

    while true; do
        sleep 1
    done
}

main
