#! /bin/bash

PROXY_CONFIG_MACOS="/opt/homebrew/etc/proxychains.conf"

function proxy_config() {
    log INFO "Configuring the proxy configuration"

    if ! grep -q 'socks5  127.0.0.1 9050' "$PROXY_CONFIG_MACOS"; then
        echo 'socks5  127.0.0.1 9050'| tee -a $PROXY_CONFIG_MACOS > /dev/null
    fi

    if grep -q '^#.*dynamic_chain' "$PROXY_CONFIG_MACOS"; then
        sed -i '' 's/^#\s*dynamic_chain/dynamic_chain/' "$PROXY_CONFIG_MACOS"
    fi

    if ! grep -q '^#.*strict_chain' "$PROXY_CONFIG_MACOS"; then
        sed -i '' '/^strict_chain/ s/^/#/' "$PROXY_CONFIG_MACOS"
    fi

    log OK "Configured"
}

function cleanup_proxy_config() {
    log INFO "Cleaning up proxy configuration"

    sed -i '' '/socks5  127.0.0.1 9050/d' "$PROXY_CONFIG_MACOS"

    sed -i '' 's/^dynamic_chain/# dynamic_chain/' "$PROXY_CONFIG_MACOS"
    sed -i '' 's/^#\s*strict_chain/strict_chain/' "$PROXY_CONFIG_MACOS"

    log OK "Proxy configuration cleaned up"
}
