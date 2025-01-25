#! /bin/bash

source ./scripts/macos/network/validate_network.sh
source ./scripts/macos/network/hot_spot_proxy.sh
source ./scripts/macos/network/tor_network.sh
source ./scripts/macos/setup/installations/installations.sh
source ./scripts/macos/utilities/get_bridge.sh
source ./scripts/macos/setup/configurations/proxy_config.sh
source ./scripts/macos/setup/configurations/tor_config.sh
source ./scripts/macos/setup/configurations/bridge.sh
source ./scripts/macos/system/signal_handler.sh

trap sigint_handler SIGINT

function macos_setup() {
    log INFO "Phase 1"
    validate_network
    log OK "Phase 1 finished."

    log INFO "Phase 2"
    get_installations
    log OK "Phase 2 finished."

    log INFO "Phase 3"
    get_bridge
    log OK "Phase 3 finished."

    log INFO "Phase 4"
    proxy_config
    log OK "Phase 4 finished."

    log INFO "Phase 5"
    check_bridge_file
    create_tor_config
    update_tor_config
    verify_tor_config
    log OK "Phase 5 finished."

    log INFO "Phase 6"
#    start_tor
    test_tor_bridge
    log OK "Phase 6 finished."

#    log INFO "Phase 7"
#    hot_spot_proxy
#    log OK "Phase 7 finished."

    log OK "MacOS program setup finished."
}