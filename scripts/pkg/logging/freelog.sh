#!/bin/bash
# freelog - Logger for free individuals.
# License: MIT License
# Copyright (c) 2025 Herman.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
GRAY='\033[0;37m'
RESET='\033[0m'

# get_public_ip() is a function that determines your public IP address via Tor or the standard way.
get_public_ip() {
  local ip

  # Check if a SOCKS proxy is available on port 9050 (Tor)
  if nc -z 127.0.0.1 9050 2>/dev/null; then
    ip=$(curl --socks5 127.0.0.1:9050 -s https://check.torproject.org/api/ip | jq -r '.IP' 2>/dev/null)
  else
    # Fallback to other methods if Tor is unavailable
    if command -v wget > /dev/null 2>&1; then
      ip=$(wget -qO- https://ifconfig.me)
    elif command -v dig > /dev/null 2>&1; then
      ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
    elif command -v nslookup > /dev/null 2>&1; then
      ip=$(nslookup myip.opendns.com resolver1.opendns.com | grep 'Address' | tail -n 1 | awk '{print $2}')
    else
      ip="FAILED"
    fi
  fi

  # Default to ERROR if IP couldn't be fetched
  [[ -z "$ip" ]] && ip="FAILED"
  echo "$ip"
}

# log() is the main function for logging.
log() {
  local level="$1"
  local message="$2"

  # Logging the message.
  local timestamp
  local os
  local ip

  timestamp=$(date +'%Y-%m-%d %H:%M:%S')
  os=$(uname -s)
  ip=$(get_public_ip)

  # Form the text for the terminal (with colors).
  if [[ "$ip" == "FAILED" ]]; then
    ip="${RED}FAILED${RESET}"
  else
    ip="${MAGENTA}$ip${RESET}"
  fi

  local level_color
  case "$level" in
    INFO) level_color=$GRAY ;;
    OK) level_color=$GREEN ;;
    ALERT) level_color=$YELLOW ;;
    FAILED) level_color=$RED ;;
    ERROR) level_color=$RED ;;
    *) level_color=$RESET ;;
  esac

  local os_ip_message="$BLUE$os$RESET:$MAGENTA$ip$RESET – $message"

  # Output to the terminal with colors, if it is a terminal.
  if [ -t 1 ]; then
    echo -e "$CYAN$timestamp$RESET [$level_color$level$RESET] $os_ip_message"
  fi
}

# Function to track IP changes
track_ip_changes() {
  local previous_ip=""

  while true; do
    new_ip=$(get_public_ip)

    if [[ "$new_ip" != "$previous_ip" ]]; then
      previous_ip=$new_ip
    fi
    # Wait for 5 seconds before checking the IP again
    sleep 5
  done
}

# Start tracking IP changes in the background
track_ip_changes &

# Save the PID of the background process so we can terminate it later
TRACK_IP_PID=$!

# Cleanup function to remove TMP_DIR and terminate background process
cleanup() {
  echo -e "${CYAN}Cleaning up background processes...${RESET}"
  if [[ -n "$TRACK_IP_PID" ]]; then
    kill "$TRACK_IP_PID" 2>/dev/null
  fi
}

# Trap EXIT to run cleanup
trap cleanup EXIT SIGINT
