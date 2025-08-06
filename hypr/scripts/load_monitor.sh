#!/bin/bash

sleep 0.5  # Espera para que DRM esté listo

HDMI_STATUS="/sys/class/drm/card1-HDMI-A-1/status"
if [ -f "$HDMI_STATUS" ] && grep -q connected "$HDMI_STATUS"; then

    # Si HDMI está conectado, usar solo HDMI
    hyprctl keyword monitor "HDMI-A-1,1920x1080@60,0x0,1"
    hyprctl keyword monitor "eDP-1,disable"

else

    # Si no hay HDMI, usar pantalla del portátil
    hyprctl keyword monitor "eDP-1,preferred,auto,1"
    hyprctl keyword monitor "HDMI-A-1,disable"
fi


