#!/bin/bash

# Umbrales de notificación
LOW_BATTERY=20
FULL_BATTERY=100

while true; do
    # Obtener el estado de la batería
    BATTERY_STATUS=$(cat /sys/class/power_supply/BAT0/status)
    BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)

    # Notificar si la batería está baja
    if [[ "$BATTERY_STATUS" == "Discharging" && "$BATTERY_LEVEL" -le "$LOW_BATTERY" ]]; then
        notify-send "Batería baja" "La batería está en $BATTERY_LEVEL%. Conecta el cargador."
    fi

    # Notificar si la batería está completamente cargada
    if [[ "$BATTERY_STATUS" == "Charging" && "$BATTERY_LEVEL" -ge "$FULL_BATTERY" ]]; then
        notify-send "Batería cargada" "La batería está completamente cargada."
    fi

    # Esperar un minuto antes de volver a verificar
    sleep 60
done