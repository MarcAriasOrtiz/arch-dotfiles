#!/bin/bash
# Convierte salida numérica de cava (0–7) a iconos unicode
# Oculta después de 'x' segundos sin audio $HIDE_DELAY

# Configuración del FIFO (tubería con nombre, First In First Out) para comunicación entre procesos 
fifo="/tmp/cava_fifo"
# Si el FIFO ya existe, lo elimina para evitar conflictos
[ -p "$fifo" ] && rm "$fifo"
# Crea un nuevo FIFO - actúa como tubería para recibir datos de cava
mkfifo "$fifo"

# Inicia cava en segundo plano redirigiendo su salida al FIFO
# -p: especifica el archivo de configuración
# 2>/dev/null: silencia los mensajes de error
# &: ejecuta en segundo plano
cava -p ~/.config/cava/config > "$fifo" 2>/dev/null &

# Guarda el PID (Process ID) de cava para poder terminarlo luego
CAVA_PID=$!

# Configura trampas para limpiar recursos cuando el script termine
# SIGINT: Ctrl+C, SIGTERM: terminación normal, EXIT: salida del script
# Mata el proceso cava y elimina el FIFO antes de terminar
trap "kill $CAVA_PID 2>/dev/null; rm -f $fifo; exit" SIGINT SIGTERM EXIT

# Array con los iconos Unicode que representarán las barras de audio
# Cada número (0-7) se mapea a un icono de diferente altura
icons=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)

# Variables para control del temporizador de silencio
silence_duration=0  # NOTA: Esta variable se declara pero no se usa en el código. Se podria usar para DEBBUG
last_audio_time=$(date +%s)  # Timestamp del último momento en que hubo audio
HIDE_DELAY=4  # Tiempo en segundos antes de ocultar el visualizador (ajustado a 4s)

# Bucle principal: lee línea por línea del FIFO (datos de cava)
while read -r line; do
  bars=""  # Cadena que almacenará los iconos resultantes
  has_audio=false  # Flag que indica si en esta línea hay audio
  current_time=$(date +%s)  # Timestamp actual
  
  # Itera sobre cada número en la línea recibida de cava
  for n in $line; do
    # Verifica si es un número válido (0-7)
    if [[ "$n" =~ ^[0-9]+$ ]] && (( n >= 0 && n < ${#icons[@]} )); then
      # Concatena el icono correspondiente al número
      bars+="${icons[$n]}"
      
      # Si el número es mayor que 0, significa que hay audio en este canal
      if [[ $n -gt 0 ]]; then
        has_audio=true  # Marca que hay audio en esta línea
        last_audio_time=$current_time  # Actualiza el timestamp del último audio
      fi
    else
      # Si no es un número válido, añade un espacio
      bars+=" "
    fi
  done
  
  # Calcula cuántos segundos han pasado desde el último audio detectado
  time_since_audio=$((current_time - last_audio_time))
  
  # Lógica de visualización:
  # Muestra las barras SI:
  #   - Hay audio en esta línea actual ($has_audio = true) O
  #   - Han pasado menos de HIDE_DELAY segundos desde el último audio
  # De lo contrario, envía cadena vacía (oculta el visualizador)
  if $has_audio || [[ $time_since_audio -lt $HIDE_DELAY ]]; then
    echo "$bars"  # Envía barras a Waybar para mostrar
  else
    echo ""  # Envía cadena vacía para ocultar en Waybar
  fi
  
done < "$fifo"  # El bucle lee desde el FIFO (salida de cava)