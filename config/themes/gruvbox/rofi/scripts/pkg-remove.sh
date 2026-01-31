#!/usr/bin/env bash

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    notify-send "Error" "fzf is not installed. Install it with: sudo pacman -S fzf"
    exit 1
fi

# fzf configuration for package removal
fzf_args=(
    --multi
    --preview 'pacman -Qi {1}'
    --preview-label='Alt-p: toggle preview | Tab: multi-select | Enter: remove'
    --preview-label-pos='bottom'
    --preview-window 'right:65%:wrap'
    --bind 'alt-p:toggle-preview'
    --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
    --bind 'alt-k:preview-up,alt-j:preview-down'
    --color 'pointer:#eb6f92,marker:#eb6f92,prompt:#eb6f92'
    --prompt='Remove > '
    --header='Search packages to remove'
)

# Get installed packages and let user select
pkg_names=$(pacman -Qq | fzf "${fzf_args[@]}")

# Remove selected packages
if [[ -n "$pkg_names" ]]; then
    # Convert newline-separated selections to space-separated
    # -Rns removes package, config files, and dependencies
    echo "$pkg_names" | tr '\n' ' ' | xargs sudo pacman -Rns --noconfirm
    notify-send "Removal Complete" "Packages removed successfully"
else
    notify-send "Cancelled" "No packages selected"
fi
