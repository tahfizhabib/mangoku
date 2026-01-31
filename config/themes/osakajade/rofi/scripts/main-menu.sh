#!/usr/bin/env bash

# Menu options
options="󰀻  Apps
󰃀  Bookmarks
󰄀  Panel
󰒓  Config
󰔎  Appearance
󰇚  Install
󰩺  Remove
󰘳  Utilities
󰋼  About
󰒓  System"

# Show menu
chosen=$(echo "$options" | rofi -dmenu -p "System" -theme ~/.config/rofi/systemmenu.rasi)

# Execute based on choice
case $chosen in
    "󰀻  Apps")
        rofi -show drun
        ;;
    "󰃀  Bookmarks")
        ~/.config/rofi/scripts/bookmarks-menu.sh
        ;;
    "󰄀  Panel")
        ~/.config/rofi/scripts/panel-menu.sh
        ;;
    "󰒓  Config")
        ~/.config/rofi/scripts/config-menu.sh
        ;;
    "󰔎  Appearance")
        ~/.config/rofi/scripts/appearance-menu.sh
        ;;
    "󰇚  Install")
        ~/.config/rofi/scripts/install-menu.sh
        ;;
    "󰩺  Remove")
        foot -e bash ~/.config/rofi/scripts/pkg-remove.sh
        ;;
    "󰘳  Utilities")
        ~/.config/rofi/scripts/utilities-menu.sh
        ;;
    "󰋼  About")
        foot -e sh -c "fastfetch; read -p 'Press Enter to close...'"
        ;;
    "󰒓  System")
        ~/.config/rofi/scripts/power-menu.sh
        ;;
esac
