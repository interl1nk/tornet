#! /bin/bash

function install_obfs4() {
  log INFO "Checking obfs4proxy package"

  if ! brew list --formula | grep -q "^obfs4proxy$"; then
      log INFO "Installing obfs4proxy"

      if brew install obfs4proxy &> /dev/null; then
          log OK "obfs4proxy has been installed successfully"
      else
          log ERROR "Failed to install obfs4proxy. Please check your Homebrew setup."
          return 1
      fi
  else
      log OK "obfs4proxy is already installed"
  fi

  if ! command -v obfs4proxy &> /dev/null; then
      log ERROR "obfs4proxy is installed but not found in PATH"

      if ! echo "$PATH" | grep -q "/usr/local/bin"; then
          log INFO "Adding /usr/local/bin to PATH"
          export PATH="/usr/local/bin:$PATH"

          if ! grep -q 'export PATH="/usr/local/bin:$PATH"' ~/.zshrc; then
              echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
              log OK "Updated PATH in ~/.zshrc"
          fi

          source ~/.zshrc
      fi
  fi

  if ! command -v obfs4proxy &> /dev/null; then
      log ERROR "obfs4proxy is still not available in PATH. Please check manually."
      return 1
  fi

  log OK "obfs4proxy is ready to use"
}