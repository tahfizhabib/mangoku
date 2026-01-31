#!/usr/bin/env bash

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    notify-send "Error" "fzf is not installed. Install it with: sudo pacman -S fzf"
    exit 1
fi

# fzf configuration for package browsing
fzf_args=(
    --multi
    --preview 'pacman -Sii {1}'
    --preview-label='Alt-p: toggle preview | Tab: multi-select | Enter: install'
    --preview-label-pos='bottom'
    --preview-window 'right:65%:wrap'
    --bind 'alt-p:toggle-preview'
    --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
    --bind 'alt-k:preview-up,alt-j:preview-down'
    --color 'pointer:#c4a7e7,marker:#c4a7e7,prompt:#c4a7e7'
    --prompt='Install > '
    --header='Search packages to install'
)

# Get package list and let user select
pkg_names=$(pacman -Slq | fzf "${fzf_args[@]}")

# Install selected packages
if [[ -n "$pkg_names" ]]; then
    # Convert newline-separated selections to space-separated
    echo "$pkg_names" | tr '\n' ' ' | xargs sudo pacman -S --noconfirm
    notify-send "Installation Complete" "Packages installed successfully"
else
    notify-send "Cancelled" "No packages selected"
fi
