#! /bin/bash

source ./scripts/macos/setup/installations/golang.sh
source ./scripts/macos/setup/installations/proxychains.sh
source ./scripts/macos/setup/installations/tor.sh
source ./scripts/macos/setup/installations/obfs4.sh


function get_installations() {
    log INFO "Installing necessary packages"

    install_golang
    install_proxychains
    install_tor
    install_obfs4

    log OK "Necessary packages installed successfully"
}
