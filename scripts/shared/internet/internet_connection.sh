#!/bin/bash

function check_internet_connection() {
    log INFO "Checking internet connection"

    local hosts=("1.1.1.1" "8.8.8.8" "example.com")

    for host in "${hosts[@]}"; do
        if ping -c 1 -W 1 "$host" &> /dev/null; then
            log OK "Internet connection is active via ping to $host"
            return 0
        fi
    done

    if command -v nc &> /dev/null; then
        for host in "${hosts[@]}"; do
            if echo | nc -w 2 "$host" 80 &> /dev/null; then
                log OK "Internet connection is active via nc to $host:80"
                return 0
            fi
        done
    fi

    if command -v telnet &> /dev/null; then
        for host in "${hosts[@]}"; do
            if echo | telnet "$host" 80 2>/dev/null | grep -q "Connected"; then
                log OK "Internet connection is active via telnet to $host:80"
                return 0
            fi
        done
    fi

    log ERROR "No internet connection detected."
    return 1
}
