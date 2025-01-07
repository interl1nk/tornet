#! /bin/bash

source ./pkg/assets/colors.sh
source ./pkg/settings/network_manager.sh
source ./pkg/settings/installation.sh

function services() {
	echo "$(set_color "purple")•$(set_color "*") Checking software..."

	OS=$(uname)

  if [[ "$OS" == "Linux" ]]; then
      echo "Using Linux: $OS"

      get_active_interface_linux
      check_internet_connection || { echo "Exiting due to no internet."; exit 1; }

      tor_service_linux
      proxychains_service_linux
  elif [[ "$OS" == "Darwin" ]]; then
      echo "$(set_color "green")✓$(set_color "*") Using MacOS: $OS"

      get_active_interface_macos
      check_internet_connection || { echo "Exiting due to no internet."; exit 1; }

      tor_service_macos
      proxychains_service_macos
  else
      echo "Unsupported OS: $OS"
      return 1
  fi
}
