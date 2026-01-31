#!/usr/bin/env bash

# System Utilities menu options
options="󰍉 SystemMon
󰞅 Emoji Pick
 Clipboard
󰃨 Clear Clipboard"

# Show menu
chosen=$(echo "$options" | rofi -dmenu -p "Utilities" -theme ~/.config/rofi/systemmenu.rasi)

# Execute based on choice
case $chosen in
    "󰍉 SystemMon")
        foot -e btop
        ;;
    "󰞅 Emoji Pick")
        # Use rofimoji with type action to auto-paste emoji - removed --rofi-args
        rofimoji --action type --skin-tone neutral
        ;;
    " Clipboard")
        # Use cliphist for clipboard history with rofi - fixed the pipe
        selected=$(cliphist list | rofi -dmenu -p "Clipboard History" -theme $HOME/.config/rofi/clipboard.rasi)
        if [ -n "$selected" ]; then
            echo "$selected" | cliphist decode | wl-copy
        fi
        ;;
    "󰃨 Clear Clipboard")
        # Clear clipboard history
        cliphist wipe
        notify-send "Clipboard" "Clipboard history cleared" -i edit-clear
        ;;
esac
