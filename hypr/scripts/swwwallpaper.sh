#!/bin/sh

pgrep -x swww-daemon > /dev/null || swww-daemon &

# Directorio de wallpapers
WALLPAPER_DIR="$HOME/wallpapers/PixelArt"

# Seleccionar wallpaper con Rofi
wallpaper=$(ls "$WALLPAPER_DIR" | rofi -dmenu -i -p "Select wallpaper:" -font "Inconsolata Nerd Font 11" -config "$HOME/.config/rofi/config-wallpaper.rasi")

# Si se seleccionó un wallpaper, aplicarlo con swww
if [ -n "$wallpaper" ]; then
    swww img "$WALLPAPER_DIR/$wallpaper" --transition-type="grow" --transition-fps="120" --transition-duration="0.6"
fi