#!/usr/bin/env bash

# Power options with Nerd Font icons
options="󰌾  Lock
󰍃  Logout
󰒲  Suspend
󰜉  Reboot
󰐥  Shutdown"

# Show menu
chosen=$(echo "$options" | rofi -dmenu -p "Power" -theme ~/.config/rofi/power-menu.rasi)

# Execute based on choice
case $chosen in
    "󰌾  Lock")
        swaylock
        ;;
    "󰍃  Logout")
        swaymsg exit
        ;;
    "󰒲  Suspend")
        systemctl suspend
        ;;
    "󰜉  Reboot")
        systemctl reboot
        ;;
    "󰐥  Shutdown")
        systemctl poweroff
        ;;
esac
