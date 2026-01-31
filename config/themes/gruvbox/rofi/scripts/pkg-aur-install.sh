#!/usr/bin/env bash

# Check if fzf and yay are installed
if ! command -v fzf &> /dev/null; then
    notify-send "Error" "fzf is not installed"
    exit 1
fi

if ! command -v yay &> /dev/null; then
    notify-send "Error" "yay is not installed"
    exit 1
fi

# fzf configuration for AUR packages
fzf_args=(
    --multi
    --preview 'yay -Sii {1}'
    --preview-label='Alt-p: toggle preview | Tab: multi-select | Enter: install'
    --preview-label-pos='bottom'
    --preview-window 'right:65%:wrap'
    --bind 'alt-p:toggle-preview'
    --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
    --bind 'alt-k:preview-up,alt-j:preview-down'
    --color 'pointer:#c4a7e7,marker:#c4a7e7,prompt:#c4a7e7'
    --prompt='AUR > '
    --header='Search AUR packages to install'
)

# Get AUR package list
pkg_names=$(yay -Slqa | fzf "${fzf_args[@]}")

# Install selected packages
if [[ -n "$pkg_names" ]]; then
    echo "$pkg_names" | tr '\n' ' ' | xargs yay -S --noconfirm
    notify-send "Installation Complete" "AUR packages installed successfully"
else
    notify-send "Cancelled" "No packages selected"
fi
