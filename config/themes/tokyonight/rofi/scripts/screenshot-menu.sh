#!/usr/bin/env bash

# Screenshot options
options="󰩭  Area
󰍹  Full Screen
󰖲  Window"

# Show menu
chosen=$(echo "$options" | rofi -dmenu -p "Screenshot" -theme ~/.config/rofi/power-menu.rasi)

# Screenshots directory
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Filename with timestamp
FILENAME="$SCREENSHOT_DIR/$(date +%Y%m%d_%H%M%S).png"

# Execute based on choice
case $chosen in
    "󰩭  Area")
        grim -g "$(slurp)" "$FILENAME"
        wl-copy < "$FILENAME"
        ;;
    "󰍹  Full Screen")
        grim "$FILENAME"
        wl-copy < "$FILENAME"
        ;;
    "󰖲  Window")
        grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.focused?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')" "$FILENAME"
        wl-copy < "$FILENAME"
        ;;
esac
