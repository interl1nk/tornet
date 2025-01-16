#! /bin/bash

source ./scripts/linux/installations/tor.sh
source ./scripts/linux/installations/proxychains.sh

function services_linux() {
    tor_service_linux
    proxychain_service_linux
}
