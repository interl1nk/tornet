#! /bin/bash

source ./scripts/pkg/assets/colors.sh

source ./scripts/macos/settings/hotspot_macos.sh

function handle_sigint() {
    echo "$(set_color "yellow")[ALERT]$(set_color "*"): Caught SIGINT."

    restore_settings

    echo "$(set_color "purple")Exiting.$(set_color "*")"
    exit 0
}
