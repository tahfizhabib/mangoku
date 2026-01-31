#!/usr/bin/env bash

# Appearance options
options="󰔎  Themes
󰸉  Wallpapers
󰛖  Fonts"

# Show menu
chosen=$(echo "$options" | rofi -dmenu -p "Appearance" -theme ~/.config/rofi/appearance-menu.rasi)

# Execute based on choice
case $chosen in
    "󰔎  Themes")
        ~/.config/rofi/scripts/themeswitcher.sh
        ;;
    "󰸉  Wallpapers")
        ~/.config/rofi/scripts/wallpaper-menu.sh
        ;;
    "󰛖  Fonts")
        nwg-look
        ;;
esac
