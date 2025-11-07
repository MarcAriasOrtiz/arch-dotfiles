#!/bin/bash
# Convierte salida numérica de cava (0–7) a iconos unicode

fifo="/tmp/cava_fifo"
[ -p "$fifo" ] && rm "$fifo"  # Si existe el FIFO, lo elimina
mkfifo "$fifo"                # Crea un FIFO (tubería con nombre)

# Inicia cava en segundo plano, mandando su salida numérica al fifo
cava -p ~/.config/cava/config > "$fifo" 2>/dev/null &

CAVA_PID=$!  # Guarda el PID de cava
trap "kill $CAVA_PID 2>/dev/null; rm -f $fifo; exit" SIGINT SIGTERM EXIT

# Define los iconos a usar según el valor (0=▁, 1=▂, ..., 7=█)
icons=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)

# Leer líneas y mapear números a iconos
while read -r line; do
  bars=""
  for n in $line; do
    # Si el número está fuera de rango, usa un espacio
    if [[ "$n" =~ ^[0-9]+$ ]] && (( n >= 0 && n < ${#icons[@]} )); then
      bars+="${icons[$n]}"  # Concatena el icono correspondiente
    else
      bars+=" "  # Carácter vacío si no es número válido
    fi
  done
  # Si la línea está vacía, imprime espacio para evitar errores en Waybar
  [[ -z "$bars" ]] && bars=" "
  echo "$bars"  # Imprime la línea de barras resultante
done < "$fifo"  # Lee desde el FIFO