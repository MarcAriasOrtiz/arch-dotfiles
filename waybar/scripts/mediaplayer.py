#!/usr/bin/env python3
import json
import subprocess
import os

OFFSET_CACHE = "/tmp/spotify_waybar_offset"
WINDOW = 30     # Longitud de ventana visible (ajústalo a tu gusto)
SCROLL_STEP = 1 # Avance de cada tick

def get_offset():
    try:
        with open(OFFSET_CACHE, "r") as f:
            return int(f.read())
    except Exception:
        return 0

def set_offset(n):
    with open(OFFSET_CACHE, "w") as f:
        f.write(str(n))

def get_spotify_info():
    try:
        title = subprocess.check_output(
            ["playerctl", "metadata", "title", "--player=spotify"]
        ).decode().strip()
        artist = subprocess.check_output(
            ["playerctl", "metadata", "artist", "--player=spotify"]
        ).decode().strip()
        status = subprocess.check_output(
            ["playerctl", "status", "--player=spotify"]
        ).decode().strip()
        full_text = f"{artist} - {title}"

        # SCROLL/CARRUSEL
        if len(full_text) > WINDOW:
            offset = get_offset()
            # Hacemos el texto circular ("marquee")
            scroll_text = (full_text + "   ") * 2
            view = scroll_text[offset:offset + WINDOW]
            offset = (offset + SCROLL_STEP) % (len(full_text) + 3)
            set_offset(offset)
        else:
            view = full_text
            set_offset(0)

        # Salida JSON para Waybar
        return {
            "text": view,
            "alt": status,
            "tooltip": f"Spotify: {status}\n{artist} - {title}",
            "class": status.lower(),
        }
    except subprocess.CalledProcessError:
        set_offset(0)
        return {
            "text": "No music",
            "alt": "stopped",
            "tooltip": "Spotify: No music",
            "class": "stopped",
        }

print(json.dumps(get_spotify_info()))
