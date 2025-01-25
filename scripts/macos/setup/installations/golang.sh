#! /bin/bash

function install_golang() {
    log INFO "Checking Golang version"

    if ! command -v go &>/dev/null; then
        log ALERT "Golang is not installed"

        log INFO "Installing Golang latest version"
        brew install go

        exit 1
    fi

    local go_version
    go_version=$(go version 2>/dev/null | grep -oE 'go[0-9]+\.[0-9]+(\.[0-9]+)?' | sed 's/go//')
    log INFO "Go version: $go_version"
}
