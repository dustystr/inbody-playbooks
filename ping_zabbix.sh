#!/bin/bash

# Функция для показа справки
show_help() {
    echo "Использование: $0 [ОПЦИИ]"
    echo "Пинг указанного IP-адреса"
    echo ""
    echo "Опции:"
    echo "  -i, --ip IP-АДРЕС    IP-адрес для пингования (обязательно)"
    echo "  -c, --count ЧИСЛО    Количество пакетов для отправки (по умолчанию: 4)"
    echo "  -h, --help           Показать эту справку"
    echo ""
    echo "Пример:"
    echo "  $0 --ip 192.168.15.108"
    echo "  $0 -i 8.8.8.8 -c 2"
}

# Значения по умолчанию
IP=""
COUNT=4

# Обработка аргументов командной строки
while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--ip)
            IP="$2"
            shift 2
            ;;
        -c|--count)
            COUNT="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Ошибка: неизвестная опция $1"
            show_help
            exit 1
            ;;
    esac
done

# Проверяем, указан ли IP-адрес
if [ -z "$IP" ]; then
    echo "Ошибка: не указан IP-адрес"
    show_help
    exit 1
fi

# Функция для проверки корректности IP-адреса
validate_ip() {
    local ip=$1
    local stat=1
    
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

# Проверяем корректность IP-адреса
if ! validate_ip "$IP"; then
    echo "Ошибка: '$IP' не является корректным IP-адресом"
    exit 1
fi

# Проверяем, что COUNT - положительное число
if ! [[ "$COUNT" =~ ^[0-9]+$ ]] || [ "$COUNT" -lt 1 ]; then
    echo "Ошибка: количество пакетов должно быть положительным числом"
    exit 1
fi

echo "Пингую $IP ($COUNT пакетов)..."

if ping -c "$COUNT" "$IP" &> /dev/null
then
    echo "✅ Ping SUCCESS! ($IP)"
else
    echo "❌ Ping FAILED! ($IP)"
fi
