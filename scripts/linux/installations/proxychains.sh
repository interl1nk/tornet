#! /bin/bash

source ./pkg/assets/colors.sh

function proxychains_service_linux() {
    echo "$(set_color "purple")[•]$(set_color "*") Checking proxychains-ng..."

    if ! command -v proxychains4 &> /dev/null; then
        echo "$(set_color "red")[ERROR]$(set_color "*"): proxychains-ng is not installed. Installing proxychains-ng..."

        case $(command -v apt yum dnf pacman | awk -F'/' '{print $NF}' | head -n 1) in
            apt)
                echo "$(set_color "purple")[•]$(set_color "*") Detected APT package manager."
                sudo apt update && sudo apt install -y proxychains4
                ;;
            yum)
                echo "$(set_color "purple")[•]$(set_color "*") Detected YUM package manager."
                sudo yum install -y proxychains-ng
                ;;
            dnf)
                echo "$(set_color "purple")[•]$(set_color "*") Detected DNF package manager."
                sudo dnf install -y proxychains-ng
                ;;
            pacman)
                echo "$(set_color "purple")[•]$(set_color "*") Detected Pacman package manager."
                sudo pacman -Sy proxychains-ng
                ;;
            *)
                echo "$(set_color "red")[ERROR]$(set_color "*"): Unsupported package manager. Please install proxychains-ng manually."
                return 1
                ;;
        esac

        if command -v proxychains4 &> /dev/null; then
            echo "$(set_color "green")[✓]$(set_color "*") proxychains-ng has been installed successfully."
        else
            echo "$(set_color "red")[ERROR]$(set_color "*"): Failed to install proxychains-ng. Please check your package manager."
            return 1
        fi
    else
        echo "$(set_color "green")[✓]$(set_color "*") OK."
    fi
}
