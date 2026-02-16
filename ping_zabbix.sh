#!/bin/bash

IP="192.168.15.108"

if ping -c 4 "$IP" &> /dev/null
then
    echo "Ping SUCCESS!"
else
    echo "Ping FAILED!"
fi
