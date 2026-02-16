#!/bin/bash

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

# Проверяем, передан ли аргумент
if [ $# -eq 0 ]
then
    echo "Ошибка: не указан IP-адрес"
    echo "Использование: $0 <IP-адрес>"
    echo "Пример: $0 192.168.15.108"
    exit 1
fi

IP="$1"

# Проверяем корректность IP-адреса
if ! validate_ip "$IP"
then
    echo "Ошибка: '$IP' не является корректным IP-адресом"
    exit 1
fi

echo "Пингую $IP ..."
if ping -c 4 "$IP" &> /dev/null
then
    echo "✅ Ping SUCCESS! ($IP)"
else
    echo "❌ Ping FAILED! ($IP)"
fi
