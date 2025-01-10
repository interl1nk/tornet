#! /bin/bash

source ./pkg/installations/macos/tor.sh
source ./pkg/installations/macos/proxychains.sh

function services_macos() {
    tor_service_macos
    proxychains_service_macos
}
