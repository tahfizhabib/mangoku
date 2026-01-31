#!/usr/bin/env bash

# Wallpaper directory
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper_previews"

# Create directories if they don't exist
mkdir -p "$WALLPAPER_DIR"
mkdir -p "$CACHE_DIR"

# Check if swww is running, if not start it
if ! pgrep -x swww-daemon > /dev/null; then
    swww-daemon &
    sleep 1
fi

# Get all image files
mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) | sort)

if [ ${#wallpapers[@]} -eq 0 ]; then
    notify-send "Wallpaper" "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Generate thumbnails using imagemagick
for wallpaper in "${wallpapers[@]}"; do
    filename=$(basename "$wallpaper")
    thumbnail="$CACHE_DIR/${filename%.*}_thumb.png"
    
    # Create thumbnail if it doesn't exist
    if [ ! -f "$thumbnail" ]; then
        convert "$wallpaper" -resize 400x300^ -gravity center -extent 400x300 "$thumbnail"
    fi
done

# Create rofi entries with preview using custom script
PREVIEW_SCRIPT="$CACHE_DIR/preview.sh"
cat > "$PREVIEW_SCRIPT" << 'PREVIEW'
#!/bin/bash
if [ -n "$1" ]; then
    thumbnail="$HOME/.cache/wallpaper_previews/$(basename "$1" | sed 's/\.[^.]*$/_thumb.png/')"
    if [ -f "$thumbnail" ]; then
        chafa -f sixel -s 400x300 "$thumbnail" 2>/dev/null || kitty +kitten icat --align left "$thumbnail" 2>/dev/null
    fi
fi
PREVIEW
chmod +x "$PREVIEW_SCRIPT"

# Create menu options
options=""
for wallpaper in "${wallpapers[@]}"; do
    filename=$(basename "$wallpaper")
    options+="$filename\x00icon\x1f$wallpaper\n"
done

# Show rofi menu with custom layout
chosen=$(echo -e "$options" | rofi -dmenu -p "Wallpaper" \
    -theme ~/.config/rofi/wallpaper-menu.rasi \
    -show-icons \
    -i)

if [ -n "$chosen" ]; then
    # Find full path of chosen wallpaper
    for wallpaper in "${wallpapers[@]}"; do
        if [[ "$(basename "$wallpaper")" == "$chosen" ]]; then
            # Set wallpaper with swww
            swww img "$wallpaper" --transition-type wipe --transition-fps 60 --transition-duration 2
            
            # Save current wallpaper path
            echo "$wallpaper" > "$HOME/.cache/current_wallpaper"
            
            notify-send "Wallpaper" "Applied: $chosen"
            break
        fi
    done
fi
