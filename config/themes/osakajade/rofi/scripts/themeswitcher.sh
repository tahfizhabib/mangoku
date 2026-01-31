#!/bin/bash

# Enhanced Theme Switcher Script
# Author: Your Name
# Description: Switches themes from ~/.config/themes/ using rofi with auto-reload

THEMES_DIR="$HOME/.config/themes"
CONFIG_DIR="$HOME/.config"

# Papirus password handling options:
# "ask_once" - Ask for sudo password once at start
# "skip_if_needs_password" - Skip if password required
# "none" - Don't change papirus folders
PAPIRUS_MODE="ask_once"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if themes directory exists
if [ ! -d "$THEMES_DIR" ]; then
    print_error "Themes directory not found at $THEMES_DIR"
    print_info "Creating themes directory..."
    mkdir -p "$THEMES_DIR"
    print_warning "Please add theme folders to $THEMES_DIR"
    exit 1
fi

# Get list of available themes (trimmed)
themes=$(ls -1 "$THEMES_DIR" 2>/dev/null | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

if [ -z "$themes" ]; then
    print_error "No themes found in $THEMES_DIR"
    exit 1
fi

# Count themes
theme_count=$(echo "$themes" | wc -l)
print_info "Found $theme_count theme(s)"

# Function to get password via rofi
get_sudo_password() {
    if command -v rofi &> /dev/null; then
        rofi -dmenu -password -p "Sudo Password for Papirus" \
            -mesg "Enter your password to apply icon theme" \
            -theme-str 'window {width: 400px;}' \
            -theme-str 'listview {lines: 0;}'
    else
        # Fallback to terminal if rofi not available
        read -s -p "Enter sudo password: " password
        echo ""
        echo "$password"
    fi
}

# Handle sudo for papirus-folders if needed
SUDO_PASSWORD=""
if [ "$PAPIRUS_MODE" = "ask_once" ]; then
    if command -v papirus-folders &> /dev/null; then
        print_info "Requesting sudo password via rofi for papirus-folders (one-time)..."
        SUDO_PASSWORD=$(get_sudo_password)
        
        if [ -z "$SUDO_PASSWORD" ]; then
            print_warning "No password provided. Papirus folders won't be changed."
            PAPIRUS_MODE="skip_if_needs_password"
        else
            # Test the password
            echo "$SUDO_PASSWORD" | sudo -S -v 2>/dev/null
            if [ $? -ne 0 ]; then
                print_error "Incorrect password. Papirus folders won't be changed."
                PAPIRUS_MODE="skip_if_needs_password"
                SUDO_PASSWORD=""
            else
                print_success "Password accepted!"
            fi
        fi
    fi
fi

# Use rofi to select theme with custom styling
selected_theme=$(echo "$themes" | rofi -dmenu -i \
    -p "Select Theme ❯" \
    -mesg "Available themes: $theme_count" \
    -theme-str 'window {width: 500px;}' \
    -theme-str 'listview {lines: 8;}')

# Exit if no theme selected
if [ -z "$selected_theme" ]; then
    print_warning "No theme selected. Exiting."
    exit 0
fi

# Trim any spaces from selected theme name
selected_theme=$(echo "$selected_theme" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

THEME_PATH="$THEMES_DIR/$selected_theme"

# Check if selected theme directory exists
if [ ! -d "$THEME_PATH" ]; then
    print_error "Theme directory not found at $THEME_PATH"
    exit 1
fi

# Show what will be applied
print_info "Theme: $selected_theme"
print_info "Components found:"
for item in "$THEME_PATH"/*; do
    if [ -d "$item" ]; then
        echo "  - $(basename "$item")"
    fi
done

# Confirmation prompt
if command -v rofi &> /dev/null; then
    confirm=$(echo -e "Yes\nNo" | rofi -dmenu -i -p "Apply this theme?" -theme-str 'window {width: 300px;}')
    if [ "$confirm" != "Yes" ]; then
        print_warning "Theme application cancelled."
        exit 0
    fi
fi

print_info "Applying theme: $selected_theme"
echo ""

# Track applied components
applied_count=0

# Find all subdirectories in the theme folder and apply
for item in "$THEME_PATH"/*; do
    if [ -d "$item" ]; then
        app_name=$(basename "$item")
        
        # Copy theme config to ~/.config/
        cp -r "$item" "$CONFIG_DIR/"
        print_success "Applied: $app_name"
        ((applied_count++))
    fi
done

echo ""
print_info "Summary: Applied $applied_count component(s)"
echo ""

# Apply Papirus icon theme based on selected theme
apply_papirus_theme() {
    local theme_name=$1
    local color=""
    local theme="Papirus-Dark"
    
    case "${theme_name,,}" in
        *catpuccin*)
            color="magenta"
            ;;
        *gruvbox*)
            color="green"
            ;;
        *osakajade*)
            color="teal"
            ;;
        *rosepine*)
            color="pink"
            ;;
        *tokyonight*)
            color="indigo"
            ;;
        *)
            print_warning "No Papirus color mapping found for theme: $theme_name"
            return 1
            ;;
    esac
    
    if command -v papirus-folders &> /dev/null; then
        print_info "Applying Papirus folders: $color (theme: $theme)"
        
        if [ "$PAPIRUS_MODE" = "ask_once" ] && [ -n "$SUDO_PASSWORD" ]; then
            echo "$SUDO_PASSWORD" | sudo -S papirus-folders -C "$color" --theme "$theme" &>/dev/null
            if [ $? -eq 0 ]; then
                print_success "Papirus folders updated to $color"
            else
                print_error "Failed to update Papirus folders"
            fi
        elif [ "$PAPIRUS_MODE" = "skip_if_needs_password" ]; then
            sudo -n papirus-folders -C "$color" --theme "$theme" &>/dev/null
            if [ $? -eq 0 ]; then
                print_success "Papirus folders updated to $color"
            else
                print_warning "Skipped Papirus folders (needs password)"
            fi
        fi
    else
        print_warning "papirus-folders command not found, skipping icon theme change"
    fi
}

# Apply papirus theme
if [ "$PAPIRUS_MODE" != "none" ]; then
    apply_papirus_theme "$selected_theme"
fi

# Reload/restart services
print_info "Reloading services..."
echo ""

# Function to reload a service
reload_service() {
    local service_name=$1
    local reload_command=$2
    
    if pgrep -x "$service_name" > /dev/null; then
        eval "$reload_command" &>/dev/null
        print_success "Reloaded: $service_name"
        return 0
    else
        print_warning "$service_name not running, skipping reload"
        return 1
    fi
}

# Reload mako
reload_service "mako" "makoctl reload"

# Reload waybar
if pgrep -x waybar > /dev/null; then
    pkill waybar
    sleep 0.5
    waybar &>/dev/null &
    print_success "Reloaded: waybar"
fi

# Reload swayosd
if pgrep -x swayosd-server > /dev/null; then
    pkill swayosd-server
    sleep 0.5
    swayosd-server &>/dev/null &
    print_success "Reloaded: swayosd"
fi

# Reload dunst (if using)
if pgrep -x dunst > /dev/null; then
    pkill dunst
    sleep 0.5
    dunst &>/dev/null &
    print_success "Reloaded: dunst"
fi

# Reload swaync (if using)
reload_service "swaync" "swaync-client -R"

echo ""
print_success "Theme '$selected_theme' applied successfully! ✓"

# Send notification
if command -v notify-send &> /dev/null; then
    notify-send -u normal "Theme Switcher" "Applied theme: $selected_theme\nComponents updated: $applied_count" -t 3000
elif command -v mako &> /dev/null; then
    makoctl notify "Theme Switcher" "Applied theme: $selected_theme"
fi

# Auto-reload with Super+R (simulate keypress)
print_info "Triggering Super+R to reload configuration..."
sleep 0.5

# Method 1: Using ydotool (recommended for Wayland)
if command -v ydotool &> /dev/null; then
    ydotool key 125:1 19:1 19:0 125:0
    print_success "Sent Super+R via ydotool"
# Method 2: Using wtype (alternative for Wayland)
elif command -v wtype &> /dev/null; then
    wtype -M logo -P r -m logo
    print_success "Sent Super+R via wtype"
# Method 3: Using hyprctl for Hyprland
elif command -v hyprctl &> /dev/null; then
    hyprctl dispatch exec "pkill -SIGUSR1 hyprland" || hyprctl reload
    print_success "Reloaded Hyprland configuration"
# Method 4: Using swaymsg for Sway
elif command -v swaymsg &> /dev/null; then
    swaymsg reload
    print_success "Reloaded Sway configuration"
else
    print_warning "No suitable method found to send Super+R"
    print_info "Install ydotool or wtype for auto-reload: 'sudo pacman -S ydotool' or 'sudo pacman -S wtype'"
    print_info "Alternatively, press Super+R manually to reload your configuration"
fi

echo ""
print_success "All done! Enjoy your new theme! 🎨"

# Clear password from memory
if [ -n "$SUDO_PASSWORD" ]; then
    SUDO_PASSWORD=""
    unset SUDO_PASSWORD
fi

exit 0
