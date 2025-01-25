#! /bin/bash

BRIDGE_FILE="bridge.txt"

function get_bridges_from_file() {
    local file="$1"
    local bridges=()

    # Проверка наличия файла и его содержимого
    if [[ ! -f "$file" || ! -s "$file" ]]; then
        log ERROR "Bridge file is missing or empty: $file"
        return 1
    fi

    # Чтение мостов из файла построчно
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Пропускаем пустые строки
        [[ -z "$line" ]] && continue
        bridges+=("$line")
    done < "$file"

    # Проверка на пустоту
    if [[ ${#bridges[@]} -eq 0 ]]; then
        log ERROR "Bridge file is empty or contains invalid data."
        return 1
    fi

    # Возвращаем мосты через stdout
    for bridge in "${bridges[@]}"; do
        echo "$bridge"
    done
}


function check_bridge_file() {
    log INFO "Checking bridge file: $BRIDGE_FILE"

    local bridges=()

    # Чтение мостов в массив
    while IFS= read -r line || [[ -n "$line" ]]; do
        bridges+=("$line")
    done < <(get_bridges_from_file "$BRIDGE_FILE")

    # Проверка на пустоту
    if [[ ${#bridges[@]} -eq 0 ]]; then
        log ERROR "Bridge file is empty or contains invalid data."
        exit 1
    fi

    log OK "Bridges file is valid and contains data."
}
