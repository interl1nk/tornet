#! /bin/bash

source ./scripts/pkg/assets/colors.sh

function get_bridge() {
    echo "$(set_color "purple")[•]$(set_color "*") Sending request to Tor Project"
    go run cmd/bin.go
    echo "$(set_color "green")[✓]$(set_color "*") Tor bridges received successfully."
}

