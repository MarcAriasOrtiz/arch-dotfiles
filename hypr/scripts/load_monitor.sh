#!/bin/bash

# Monitors
LAPTOP_MONITOR="eDP-1"
EXTERNAL_MONITOR="HDMI-A-1"

# Screen res
DESIRED_RESOLUTION="1920x1080@60"

sleep 5

if [[ "$(cat /sys/class/drm/*$EXTERNAL_MONITOR*/status 2>/dev/null)" == "connected" ]]; then
    
    hyprctl keyword monitor "$EXTERNAL_MONITOR,$DESIRED_RESOLUTION,0x0,1"
    
    hyprctl keyword monitor "$LAPTOP_MONITOR,disable"

else

    hyprctl keyword monitor "$LAPTOP_MONITOR,preferred,auto,1"
    
    hyprctl keyword monitor "$EXTERNAL_MONITOR,disable"
fi