#!/bin/bash

# Nerd Font icons embedded directly
options="󰜉  Swayosd
󰒓  Environment
󰘳  Launcher
󰍃  Waybar
󰂛  Mako
󰍉  Btop
󰌾  Swaylock
󰒲  Fastfetch
󰍜  Rofi Config
󰍜  Rofi Menu"

selected=$(echo -e "$options" | rofi -dmenu -p "Config" -theme ~/.config/rofi/systemmenu.rasi)

case $selected in
    *Swayosd*)
        if [ -f ~/.config/swayosd/style.css ]; then
            code ~/.config/swayosd/style.css 2>/dev/null || nvim ~/.config/swayosd/style.css
        fi
        ;;
    *Mako*)
        if [ -f ~/.config/mako/config ]; then
            code ~/.config/mako/config 2>/dev/null || nvim ~/.config/mako/config
        fi
        ;;
    *Environment*)
        if [ -f ~/.config/mango/config.conf ]; then
            code ~/.config/mango/config.conf 2>/dev/null || nvim ~/.config/mango/config.conf
        elif [ -f ~/.config/hypr/hyprland.conf ]; then
            code ~/.config/hypr/hyprland.conf 2>/dev/null || nvim ~/.config/hypr/hyprland.conf
        elif [ -f ~/.config/niri/config.kdl ]; then
            code ~/.config/niri/config.kdl 2>/dev/null || nvim ~/.config/niri/config.kdl
        fi
        ;;
    *Launcher*)
        if [ -f ~/.config/rofi/config.rasi ]; then
            code ~/.config/rofi/config.rasi 2>/dev/null || nvim ~/.config/rofi/config.rasi
        fi
        ;;
    *Waybar*)
        if [ -f ~/.config/waybar/config.jsonc ]; then
            code ~/.config/waybar/config.jsonc 2>/dev/null || nvim ~/.config/waybar/config.jsonc
        fi
        ;;
    *Btop*)
        if [ -f ~/.config/btop/btop.conf ]; then
            code ~/.config/btop/btop.conf 2>/dev/null || nvim ~/.config/btop/btop.conf
        fi
        ;;
    *Swaylock*)
        if [ -f ~/.config/swaylock/config ]; then
            code ~/.config/swaylock/config 2>/dev/null || nvim ~/.config/swaylock/config
        fi
        ;;
    *Fastfetch*)
        if [ -f ~/.config/fastfetch/config.jsonc ]; then
            code ~/.config/fastfetch/config.jsonc 2>/dev/null || nvim ~/.config/fastfetch/config.jsonc
        fi
        ;;
    *"Rofi Config"*)
        if [ -f ~/.config/rofi/config.rasi ]; then
            code ~/.config/rofi/config.rasi 2>/dev/null || nvim ~/.config/rofi/config.rasi
        fi
        ;;
    *"Rofi Menu"*)
        if [ -f ~/.config/rofi/scripts/main-menu.sh ]; then
            code ~/.config/rofi/scripts/main-menu.sh 2>/dev/null || nvim ~/.config/rofi/scripts/main-menu.sh
        fi
        ;;
esac
