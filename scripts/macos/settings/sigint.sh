#! /bin/bash

source ./scripts/macos/settings/hotspot_macos.sh

function handle_sigint() {
    log ALERT "Caught SIGINT"
    restore_settings
    exit 0
}
