#! /bin/bash

# Указываем путь к логам на рабочем столе
LOG_FILE="$HOME/Desktop/tor_log.txt"
TEST_LOG_FILE="/tmp/tor_bridge_test.log"

function log {
    # Простая функция логирования
    echo "$1"
}

function stop_tor {
    log INFO "Stopping any running instances of Tor"
    killall tor
}

function start_tor {
    log INFO "Starting Tor service"

    # Перезапуск Tor с использованием brew
    if tor_output=$(brew services start tor 2>&1); then
        log OK "Tor service has been started successfully"
    else
        log ERROR "Failed to start Tor service."
        echo "$tor_output"
        return 1
    fi
}

function test_tor_bridge {
    log INFO "Testing Tor connection with the current configuration"

    # Проверка конфигурации
    if ! tor --quiet --verify-config > /dev/null 2>&1; then
        log ERROR "Invalid Tor configuration. Please check your torrc file."
        tor --verify-config  # Вывести подробности для диагностики
        return 1
    fi
    log OK "Tor configuration is valid"

    # Очистка старых логов
    rm -f "$LOG_FILE"
    rm -f "$TEST_LOG_FILE"

    # Проверим, занят ли порт 9050
    if lsof -i :9050 > /dev/null; then
        log INFO "Port 9050 is already in use, stopping existing Tor instance."
        stop_tor
        sleep 2
    fi

    # Запуск Tor с логированием в файл на рабочем столе
    log INFO "Attempting to connect using the configured bridge"

    # Запуск Tor в фоновом режиме с логированием в файл на рабочем столе
    tor --Log "notice file $LOG_FILE" > /dev/null 2>&1 &

    # Даем Tor время на подключение (можно настроить задержку в зависимости от сети)
    sleep 10

    # Проверяем, был ли создан лог
    if [ ! -f "$LOG_FILE" ]; then
        log ERROR "Log file $LOG_FILE was not created. Tor might not have started correctly."
        return 1
    fi

    # Проверяем логи на успешное подключение
    if grep -q "Bootstrapped 100%" "$LOG_FILE"; then
        log OK "Tor successfully connected using the bridge."
        return 0
    else
        log ERROR "Tor failed to connect using the bridge. Check logs for more details."
        cat "$LOG_FILE"  # Вывести лог для диагностики
        return 1
    fi
}

# Основная логика
