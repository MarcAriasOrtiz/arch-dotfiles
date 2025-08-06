#!/bin/bash

STEP=5  # cantidad de volumen a subir o bajar

case "$1" in
    -o)
        case "$2" in
            i)
                pactl set-sink-volume @DEFAULT_SINK@ +${STEP}%
                ;;
            d)
                pactl set-sink-volume @DEFAULT_SINK@ -${STEP}%
                ;;
            m)
                pactl set-sink-mute @DEFAULT_SINK@ toggle
                ;;
            *)
                echo "Opción no válida"
                ;;
        esac
        ;;
    *)
        echo "Uso: $0 -o [i|d|m]"
        ;;
esac