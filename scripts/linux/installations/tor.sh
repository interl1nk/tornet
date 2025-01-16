#! /bin/bash

source ./pkg/assets/colors.sh

function tor_service_linux() {
    echo "$(set_color "purple")[•]$(set_color "*") Checking Tor status..."

    if ! tor_installed=$(command -v tor); then
        echo "$(set_color "red")[Error]$(set_color "*"): Tor is not installed. Installing Tor..."

        case $(command -v apt yum dnf pacman | awk -F'/' '{print $NF}' | head -n 1) in
            apt)
                echo "$(set_color "purple")[•]$(set_color "*") Detected APT package manager."
                sudo apt update && sudo apt install -y tor
                ;;
            yum)
                echo "$(set_color "purple")[•]$(set_color "*") Detected YUM package manager."
                sudo yum install -y tor
                ;;
            dnf)
                echo "$(set_color "purple")[•]$(set_color "*") Detected DNF package manager."
                sudo dnf install -y tor
                ;;
            pacman)
                echo "$(set_color "purple")[•]$(set_color "*") Detected Pacman package manager."
                sudo pacman -Sy tor
                ;;
            *)
                echo "$(set_color "red")[ERROR]$(set_color "*"): Unsupported package manager. Please install Tor manually."
                return 1
                ;;
        esac

        if command -v tor &> /dev/null; then
            echo "$(set_color "green")[✓]$(set_color "*") Tor has been installed successfully."
        else
            echo "$(set_color "red")[ERROR]$(set_color "*"): Tor installation failed. Please check your package manager."
            return 1
        fi
    else
        echo "$(set_color "green")[✓]$(set_color "*") Tor is already installed at $tor_installed."
    fi

    tor_status=$(systemctl is-active tor)

    if [ "$tor_status" == "active" ]; then
        echo "$(set_color "green")[✓]$(set_color "*") Service Tor is running."
    else
        echo "$(set_color "yellow")[•]$(set_color "*") Tor is down. Starting Tor..."

        if tor_output=$(sudo systemctl start tor 2>&1); then
            echo "$(set_color "green")[✓]$(set_color "*") Service Tor is running."
        else
            echo "$(set_color "red")[ERROR]$(set_color "*"): Error starting Tor."
            echo "$tor_output"
            return 1
        fi
    fi
}
