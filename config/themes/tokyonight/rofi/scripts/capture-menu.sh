#!/usr/bin/env bash

# Capture options
options="󰹑  Screenshot
󰑋  Start Recording
󰓛  Stop Recording"

# Show menu with same sized theme
chosen=$(echo "$options" | rofi -dmenu -p "Capture" -theme ~/.config/rofi/capture-menu.rasi)

# Execute based on choice
case $chosen in
    "󰹑  Screenshot")
        ~/.config/rofi/scripts/screenshot-menu.sh
        ;;
    "󰑋  Start Recording")
        gpu-screen-recorder-start
        ;;
    "󰓛  Stop Recording")
        gpu-screen-recorder-stop
        ;;
esac
