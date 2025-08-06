#!/bin/bash

# Ruta al archivo de configuración de Hyprland
CONFIG_FILE="$HOME/.config/hypr/conf/keybindings.conf"

# Verificar si el archivo de configuración existe
if [[ ! -f "$CONFIG_FILE" ]]; then
    notify-send "Error" "No se encontró el archivo de configuración de Hyprland."
    exit 1
fi

# Extraer los keybindings del archivo de configuración
KEYBINDINGS=$(grep -E '^bind\s*=' "$CONFIG_FILE" | sed -E 's/^bind\s*=\s*//')

# Verificar si se encontraron keybindings
if [[ -z "$KEYBINDINGS" ]]; then
    notify-send "Error" "No se encontraron keybindings en el archivo de configuración."
    exit 1
fi

# Formatear los keybindings para la notificación
MESSAGE="Keybindings de Hyprland:\n\n$KEYBINDINGS"

# Mostrar la notificación con Dunst
notify-send -t 10000 "Hyprland Keybindings" "$MESSAGE"