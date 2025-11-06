#!/bin/bash
# Convierte salida numérica de cava (0–7) a iconos unicode

fifo="/tmp/cava_fifo"
[ -p "$fifo" ] && rm "$fifo"
mkfifo "$fifo"

# Inicia cava en segundo plano, mandando su salida numérica al fifo
cava -p ~/.config/cava/config > "$fifo" 2>/dev/null &

CAVA_PID=$!
trap "kill $CAVA_PID 2>/dev/null; rm -f $fifo; exit" SIGINT SIGTERM EXIT

# Define los iconos a usar según el valor
icons=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)

# Leer líneas y mapear números a iconos
while read -r line; do
  bars=""
  for n in $line; do
    # Si el número está fuera de rango, usa un espacio
    if [[ "$n" =~ ^[0-9]+$ ]] && (( n >= 0 && n < ${#icons[@]} )); then
      bars+="${icons[$n]}"
    else
      bars+=" "
    fi
  done
  # Si la línea está vacía, imprime espacio para evitar errores en Waybar
  [[ -z "$bars" ]] && bars=" "
  echo "$bars"
done < "$fifo"
