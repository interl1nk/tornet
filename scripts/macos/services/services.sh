#! /bin/bash

source ./scripts/macos/installations/tor.sh
source ./scripts/macos/installations/proxychains.sh
source ./scripts/macos/installations/golang.sh

function services_macos() {
    tor_service_macos
    proxychains_service_macos
    golang_macos
}
