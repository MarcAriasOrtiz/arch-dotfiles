#!/bin/bash

pgrep -x swww-daemon > /dev/null || swww-daemon &

# Edit below to control the images transition
export SWWW_TRANSITION_STEP=2
export SWWW_TRANSITION="random"
export SWWW_TRANSITION_FPS=120
export SWWW_TRANSITION_DURATION=3

# This controls (in seconds) when to switch to the next image
INTERVAL=300

#while true; do

IMAGE_DIR="/home/mao/.config/rofi/change_wallpapper/.current_wallpaper"
	#echo $IMAGE_DIR
RANDOM_IMAGE=$(find "$IMAGE_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1)

swww img $RANDOM_IMAGE #--transition-type="random" --transition-fps="120" --transition-duration="0.6"

	#sleep $INTERVAL
#done
	
