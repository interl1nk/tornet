#! /bin/bash

source ./scripts/pkg/assets/colors.sh

function golang_macos() {
    echo "$(set_color "purple")[•]$(set_color "*") Checking Golang version"

    if ! command -v go &>/dev/null; then
        echo "$(set_color "yellow")[ALERT]$(set_color "*"): Golang is not installed"

        echo "$(set_color "purple")[•]$(set_color "*") Installing Golang latest version"
        brew install go

        exit 1
    fi

    local go_version
    go_version=$(go version 2>/dev/null | grep -oE 'go[0-9]+\.[0-9]+(\.[0-9]+)?' | sed 's/go//')
    echo "$(set_color "gray")[•]$(set_color "*") Go version: $go_version"
    echo "$(set_color "green")[✓]$(set_color "*") OK."
}
