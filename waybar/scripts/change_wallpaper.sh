#!/bin/sh

# Iniciar el daemon de swww si no está ya corriendo
pgrep -x swww-daemon > /dev/null || swww-daemon &

# Directorio de wallpapers
WALLPAPER_DIR="$HOME/wallpapers"

# Seleccionar un wallpaper aleatorio
wallpaper=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)

# Si se encontró un wallpaper, aplicarlo con swww
if [ -n "$wallpaper" ]; then
    swww img "$wallpaper" --transition-type="grow" --transition-fps="120" --transition-duration="0.6"
fi
