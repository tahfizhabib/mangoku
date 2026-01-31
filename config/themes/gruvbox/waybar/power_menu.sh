#!/bin/bash

# Power menu script for Waybar with MangoWC
choice=$(echo -e "🔒 Lock\n🚪 Logout\n💤 Suspend\n🔄 Reboot\n⏻ Shutdown" | rofi -dmenu -p "Power Menu" -theme-str 'window {width: 250px; height: 200px;}')

case "$choice" in
    "🔒 Lock")
        swaylock -f
        ;;
    "🚪 Logout")
        mangowc --quit
        ;;
    "💤 Suspend")
        systemctl suspend
        ;;
    "🔄 Reboot")
        systemctl reboot
        ;;
    "⏻ Shutdown")
        systemctl poweroff
        ;;
esac
