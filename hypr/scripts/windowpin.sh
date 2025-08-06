#!/bin/bash

# Obtener la ventana enfocada
WIN=$(hyprctl activewindow -j | jq -r '.address')

# Verificar si se obtuvo una ventana válida
if [[ -z "$WIN" ]]; then
    echo "No hay una ventana activa."
    exit 1
fi

# Verificar si la ventana está anclada
PINNED=$(hyprctl activewindow -j | jq -r '.pinned')

# Alternar el estado de anclado
if [[ "$PINNED" == "true" ]]; then
    hyprctl dispatch pin
    echo "Ventana desanclada: $WIN"
else
    hyprctl dispatch pin
    echo "Ventana anclada: $WIN"
fi