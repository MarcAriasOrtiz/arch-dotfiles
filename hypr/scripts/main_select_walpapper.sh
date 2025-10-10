#!/bin/bash
# ─────────────────────────────────────────────────────────────
# Script: main_select_wallpapper.sh
# Autor: Mao 🐧
# Descripción: Selector de wallpapers con Rofi para Hyprland.
#              Compatible con imágenes y videos. Genera paleta
#              de colores usando Wallust.
# ─────────────────────────────────────────────────────────────

# 📂 Directorios y configuraciones
terminal="kitty"
wallDIR="$HOME/projects/wallpappers/pics"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
ROFI_DIR="$HOME/.config/rofi/change_wallpapper"
rofi_theme="$ROFI_DIR/config-wallpapper.rasi"
current_wallpaper_link="$ROFI_DIR/.current_wallpaper"
wallpaper_path_file="$SCRIPTSDIR/.current_wallpaper_path"

# 🌀 Configuración de transición (swww)
FPS=60
TYPE="any"
DURATION=2
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

# ─────────────────────────────────────────────────────────────
# 🧩 Funciones auxiliares
# ─────────────────────────────────────────────────────────────

log() { echo "[Wallpaper] $1"; }

kill_wallpaper_for_video() {
  swww kill 2>/dev/null
  pkill mpvpaper swaybg hyprpaper 2>/dev/null
}

kill_wallpaper_for_image() {
  pkill mpvpaper swaybg hyprpaper 2>/dev/null
}

# ─────────────────────────────────────────────────────────────
# 🖼️ Generar lista de wallpapers
# ─────────────────────────────────────────────────────────────

mapfile -d '' PICS < <(find -L "$wallDIR" -type f \( \
  -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o \
  -iname "*.gif" -o -iname "*.bmp" -o -iname "*.tiff" -o \
  -iname "*.webp" -o -iname "*.mp4" -o -iname "*.mkv" -o \
  -iname "*.mov" -o -iname "*.webm" \) -print0)

RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME=". random"

# Obtener monitor enfocado
focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
monitor_height=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .height')
scale_factor=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .scale')

icon_size=$(echo "scale=1; ($monitor_height * 3) / ($scale_factor * 150)" | bc)
adjusted_icon_size=$(echo "$icon_size" | awk '{if ($1 < 15) $1 = 20; if ($1 > 25) $1 = 25; print $1}')
rofi_override="element-icon{size:${adjusted_icon_size}%;}"

rofi_command="rofi -i -show -dmenu -config $rofi_theme -theme-str $rofi_override"

# ─────────────────────────────────────────────────────────────
# 📜 Generar menú de selección
# ─────────────────────────────────────────────────────────────

menu() {
  IFS=$'\n' sorted_options=($(sort <<<"${PICS[*]}"))
  printf "%s\x00icon\x1f%s\n" "$RANDOM_PIC_NAME" "$RANDOM_PIC"

  for pic_path in "${sorted_options[@]}"; do
    pic_name=$(basename "$pic_path")
    if [[ "$pic_name" =~ \.gif$ ]]; then
      cache_img="$HOME/.cache/gif_preview/${pic_name}.png"
      mkdir -p "$(dirname "$cache_img")"
      [[ ! -f "$cache_img" ]] && magick "$pic_path[0]" -resize 1920x1080 "$cache_img"
      printf "%s\x00icon\x1f%s\n" "$pic_name" "$cache_img"
    elif [[ "$pic_name" =~ \.(mp4|mkv|mov|webm|MP4|MKV|MOV|WEBM)$ ]]; then
      cache_vid="$HOME/.cache/video_preview/${pic_name}.png"
      mkdir -p "$(dirname "$cache_vid")"
      [[ ! -f "$cache_vid" ]] && ffmpeg -v error -y -i "$pic_path" -ss 00:00:01.000 -vframes 1 "$cache_vid"
      printf "%s\x00icon\x1f%s\n" "$pic_name" "$cache_vid"
    else
      printf "%s\x00icon\x1f%s\n" "$(echo "$pic_name" | cut -d. -f1)" "$pic_path"
    fi
  done
}

# ─────────────────────────────────────────────────────────────
# 🧱 Aplicar wallpaper
# ─────────────────────────────────────────────────────────────

apply_image_wallpaper() {
  local image_path="$1"

  kill_wallpaper_for_image

  # Iniciar swww si no está corriendo
  if ! pgrep -x "swww-daemon" >/dev/null; then
    log "🚀 Iniciando swww-daemon..."
    swww-daemon --format xrgb &
    sleep 1
  fi

  # Aplicar imagen con transición
  log "🖼️ Aplicando wallpaper en $focused_monitor..."
  swww img -o "$focused_monitor" "$image_path" $SWWW_PARAMS

  # Guardar ruta del wallpaper actual
  echo "$image_path" > "$wallpaper_path_file"
  ln -sf "$image_path" "$current_wallpaper_link"

  # Ejecutar script de colores
  "$SCRIPTSDIR/wallust_colors.sh" &

  # Actualizar fondos para otros elementos visuales
  sleep 2
  magick "$current_wallpaper_link" -blur 0x5 "$HOME/.config/rofi/select_program/.current_wallpapper"
  magick "$current_wallpaper_link" "$HOME/projects/dotfiles/sddm/themes/mao-theme/.current_wallpaper.jpg"

  log "✅ Wallpaper aplicado y colores actualizados."
}

# ─────────────────────────────────────────────────────────────
# 🚀 Función principal
# ─────────────────────────────────────────────────────────────

main() {
  choice=$(menu | $rofi_command)
  choice=$(echo "$choice" | xargs)
  RANDOM_PIC_NAME=$(echo "$RANDOM_PIC_NAME" | xargs)

  if [[ -z "$choice" ]]; then
    log "❌ No se seleccionó nada. Saliendo."
    exit 0
  fi

  # Si selecciona “. random”
  if [[ "$choice" == "$RANDOM_PIC_NAME" ]]; then
    choice=$(basename "$RANDOM_PIC")
  fi

  choice_basename=$(basename "$choice" | sed 's/\(.*\)\.[^.]*$/\1/')
  selected_file=$(find "$wallDIR" -iname "$choice_basename.*" -print -quit)

  if [[ -z "$selected_file" ]]; then
    log "⚠️ No se encontró el archivo: $choice"
    exit 1
  fi

  log "🖼️ Seleccionado: $selected_file"
  apply_image_wallpaper "$selected_file"
}

# Evitar instancias múltiples de rofi
if pidof rofi >/dev/null; then
  pkill rofi
fi

main
