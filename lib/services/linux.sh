#! /bin/bash

source ./pkg/installations/linux/tor.sh
source ./pkg/installations/linux/proxychains.sh

function services_linux() {
    tor_service_linux
    proxychain_service_linux
}
