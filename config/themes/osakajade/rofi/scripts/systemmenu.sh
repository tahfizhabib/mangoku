#!/usr/bin/env bash

# Menu options
options="󰀻  Apps
󰃀  Bookmarks
󰄀  Capture
  Config
󰔎  Themes
󰇚  Install
󰩺  Remove
󰍉  Resources
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
        firefox --new-window about:bookmarks &
        ;;
    "󰄀  Capture")
        ~/.config/rofi/scripts/screenshot-menu.sh
        ;;
    "󰏘  Config")
        ~/.config/rofi/scripts/config-menu.sh
        ;;
    "󰔎  Themes")
        ~/.config/rofi/scripts/themeswitcher.sh
        ;;
    "󰇚  Install")
        ~/.config/rofi/scripts/install-menu.sh
        ;;
    "󰩺  Remove")
        foot -e bash ~/.config/rofi/scripts/pkg-remove.sh
        ;;
    "󰍉  Resources")
        foot -e btop
        ;;
    "󰋼  About")
        foot -e sh -c "fastfetch; read -p 'Press Enter to close...'"
        ;;
    "󰒓  System")
        ~/.config/rofi/scripts/power-menu.sh
        ;;
esac
