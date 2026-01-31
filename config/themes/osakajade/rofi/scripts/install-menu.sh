#!/usr/bin/env bash

# Install options
options="󰏖  Pacman
󰮯  AUR"

# Show menu with same sized theme
chosen=$(echo "$options" | rofi -dmenu -p "Install" -theme ~/.config/rofi/install-menu.rasi)

# Execute based on choice
case $chosen in
    "󰏖  Pacman")
        foot -e bash ~/.config/rofi/scripts/pkg-install.sh
        ;;
    "󰮯  AUR")
        foot -e bash ~/.config/rofi/scripts/pkg-aur-install.sh
        ;;
esac
