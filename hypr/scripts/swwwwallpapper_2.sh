#!/bin/bash

WALLPAPER_DIR="$HOME/wallpapers"
FILE=$(yad --file-selection --filename="$WALLPAPER_DIR/" --title="Selecciona un wallpaper")

if [ -n "$FILE" ]; then
    swww img "$FILE" --transition-type="grow" --transition-fps="120" --transition-duration="0.6"
fi
