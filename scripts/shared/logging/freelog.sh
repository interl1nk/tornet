#!/bin/bash

#MIT License
#
#Copyright (c) 2025 Herman
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

# Variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GRAY='\033[0;37m'
RESET='\033[0m'

log() {
    local level="$1"
    local message="$2"
    local level_color
    local timestamp
    local os

    timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    os=$(uname -s)

    case "$level" in
        INFO) level_color=$GRAY ;;
        IP_ADDRESS) level_color=$MAGENTA ;;
        OK) level_color=$GREEN ;;
        ALERT) level_color=$YELLOW ;;
        FAILED) level_color=$RED ;;
        ERROR) level_color=$RED ;;
        *) level_color=$RESET ;;
    esac

    local os_message="$MAGENTA$os$RESET: $message"

    # Output to the terminal with colors, if it is a terminal.
    if [ -t 1 ]; then
        echo -e "$CYAN$timestamp$RESET – [$level_color$level$RESET] $os_message"
        sync
    fi
}
