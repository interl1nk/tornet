#! /bin/bash

function get_bridge() {
    log INFO "Sending request to Tor Project"

    output=$(go run cmd/bin.go 2>&1)
    exit_status=$?

    if [[ $exit_status -eq 0 && ! "$output" =~ "error sending a request" ]]; then
        log OK "Tor bridges received successfully"
    else
        log ERROR "Failed to receive Tor bridges. Error: $output"
    fi
}
