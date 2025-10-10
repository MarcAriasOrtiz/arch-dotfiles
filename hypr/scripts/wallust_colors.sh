#!/bin/bash
# ─────────────────────────────────────────────────────────────
# Script: wallust_colors.sh
# Autor: Mao 🐧
# Descripción: Genera paleta de colores con Wallust basada en
#              el wallpaper actual aplicado por Hyprland.
# ─────────────────────────────────────────────────────────────

# 📂 Configuración de rutas
SCRIPTSDIR="$HOME/.config/hypr/scripts"
ROFI_DIR="$HOME/.config/rofi/change_wallpapper"
WALLPAPER_LINK="$ROFI_DIR/.current_wallpaper"
WALLPAPER_PATH_FILE="$SCRIPTSDIR/.current_wallpaper_path"

# 📢 Logs (opcional)
log() { echo "[Wallust] $1"; }

# ─────────────────────────────────────────────────────────────
# 🧩 Comprobaciones iniciales
# ─────────────────────────────────────────────────────────────

# Asegurar que el archivo con la ruta del wallpaper exista
if [ ! -f "$WALLPAPER_PATH_FILE" ]; then
    log "⚠️ No se encontró $WALLPAPER_PATH_FILE"
    exit 1
fi

# Leer ruta actual del wallpaper
wallpaper_path=$(cat "$WALLPAPER_PATH_FILE")

# Verificar que no esté vacío
if [ -z "$wallpaper_path" ]; then
    log "⚠️ La ruta del wallpaper está vacía."
    exit 1
fi

# Verificar que el archivo exista
if [ ! -f "$wallpaper_path" ]; then
    log "⚠️ El archivo del wallpaper no existe: $wallpaper_path"
    exit 1
fi

# ─────────────────────────────────────────────────────────────
# 🔗 Crear enlace simbólico para Rofi
# ─────────────────────────────────────────────────────────────

mkdir -p "$ROFI_DIR"

ln -sf "$wallpaper_path" "$WALLPAPER_LINK"
log "📎 Enlace simbólico actualizado:"
log "$WALLPAPER_LINK → $wallpaper_path"

# ─────────────────────────────────────────────────────────────
# 🎨 Ejecutar Wallust (sin cambiar TTY o terminal)
# ─────────────────────────────────────────────────────────────

log "🎨 Generando paleta con Wallust..."
wallust run "$wallpaper_path" -s

# ─────────────────────────────────────────────────────────────
# 🔁 Reiniciar Waybar para aplicar colores nuevos
# ─────────────────────────────────────────────────────────────

if pgrep -x "waybar" >/dev/null; then
    log "🔄 Reiniciando Waybar..."
    killall waybar && waybar &
else
    log "ℹ️ Waybar no está en ejecución."
fi

log "✅ Paleta de colores actualizada correctamente."
