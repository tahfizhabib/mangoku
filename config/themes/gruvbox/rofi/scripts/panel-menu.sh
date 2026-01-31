#!/usr/bin/env bash

# Screen Utilities menu options
options="󰹑 Screenshot
󰕧 Screen Recording
󰍹 Display Settings"

# Show menu
chosen=$(echo "$options" | rofi -dmenu -p "Panel" -theme ~/.config/rofi/systemmenu.rasi)

# Execute based on choice
case $chosen in
    "󰹑 Screenshot")
        ~/.config/rofi/scripts/screenshot-menu.sh
        ;;
    "󰕧 Screen Recording")
        ~/.config/rofi/scripts/recording-menu.sh
        ;;
    "󰍹 Display Settings")
        ~/.config/rofi/scripts/display-menu.sh
        ;;
esac
