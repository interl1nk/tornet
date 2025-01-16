#! /bin/bash

source ./scripts/pkg/assets/colors.sh

function proxychains_service_macos() {
    echo "$(set_color "purple")[•]$(set_color "*") Checking proxychains-ng..."

    if ! brew list --formula | grep -q "^proxychains-ng$"; then
        echo "$(set_color "yellow")[ALERT]$(set_color "*"): proxychains-ng is not installed via Homebrew."
        echo "$(set_color "purple")[•]$(set_color "*") Installing proxychains-ng via Homebrew..."

        if brew install proxychains-ng &> /dev/null; then
            echo "$(set_color "green")[✓]$(set_color "*") proxychains-ng has been installed successfully."
        else
            echo "$(set_color "red")[ERROR]$(set_color "*"): Failed to install proxychains-ng. Please check your Homebrew setup."
            return 1
        fi
    else
        echo "$(set_color "green")[✓]$(set_color "*") OK."
    fi
}
