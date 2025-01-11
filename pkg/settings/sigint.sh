#! /bin/bash

source ./pkg/assets/colors.sh
source ./pkg/settings/hotspot_macos.sh

function handle_sigint() {
    echo "$(set_color "yellow")WARNING:$(set_color "*") Caught SIGINT."

    restore_settings

    echo "$(set_color "purple")Exiting...$(set_color "*")"
    exit 0
}
