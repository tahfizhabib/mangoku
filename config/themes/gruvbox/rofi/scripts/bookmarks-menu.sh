#!/usr/bin/env bash

# Bookmarks file
BOOKMARKS_FILE="$HOME/.config/rofi/bookmarks.txt"

# Create bookmarks file with defaults if it doesn't exist
if [ ! -f "$BOOKMARKS_FILE" ]; then
    cat > "$BOOKMARKS_FILE" << 'DEFAULTS'
Arch Linux Wiki|https://wiki.archlinux.org/
MangoWC Wiki|https://github.com/DreamMaoMao/mangowc/wiki
DEFAULTS
fi

# Read bookmarks and create menu options
options="󰖟  Arch Linux Wiki
󰖟  MangoWC Wiki"

# Add custom bookmarks
while IFS='|' read -r name url; do
    if [ "$name" != "Arch Linux Wiki" ] && [ "$name" != "MangoWC Wiki" ]; then
        options+="\n󰖟  $name"
    fi
done < "$BOOKMARKS_FILE"

# Add management options
options+="\n  Add Bookmark"
options+="\n  Remove Bookmark"

# Show menu
chosen=$(echo -e "$options" | rofi -dmenu -p "Bookmarks" -theme ~/.config/rofi/bookmarks-menu.rasi)

# Execute based on choice
case $chosen in
    "󰖟  Arch Linux Wiki")
        xdg-open "https://wiki.archlinux.org/" &
        ;;
    "󰖟  MangoWC Wiki")
        xdg-open "https://github.com/DreamMaoMao/mangowc/wiki" &
        ;;
    "  Add Bookmark")
        foot -e bash -c '
            BOOKMARKS_FILE="$HOME/.config/rofi/bookmarks.txt"
            
            clear
            echo "┌────────────────────────────────────────────────────────────────┐"
            echo "│                      ADD BOOKMARK                              │"
            echo "└────────────────────────────────────────────────────────────────┘"
            echo ""
            
            read -p "  Name: " name
            
            if [ -z "$name" ]; then
                echo ""
                echo "  ERROR: Name cannot be empty"
                sleep 2
                exit 1
            fi
            
            read -p "  URL:  " url
            
            if [ -z "$url" ]; then
                echo ""
                echo "  ERROR: URL cannot be empty"
                sleep 2
                exit 1
            fi
            
            if [[ ! "$url" =~ ^https?:// ]]; then
                echo ""
                echo "  ERROR: URL must start with http:// or https://"
                sleep 2
                exit 1
            fi
            
            # Check for duplicates
            if grep -q "^$name|" "$BOOKMARKS_FILE" 2>/dev/null; then
                echo ""
                read -p "  Bookmark exists. Overwrite? (y/N): " overwrite
                if [[ "$overwrite" =~ ^[Yy]$ ]]; then
                    sed -i "/^$name|/d" "$BOOKMARKS_FILE"
                else
                    echo "  Cancelled"
                    sleep 1
                    exit 0
                fi
            fi
            
            echo "$name|$url" >> "$BOOKMARKS_FILE"
            
            echo ""
            echo "  SUCCESS: Bookmark added"
            sleep 2
        '
        ;;
    "  Remove Bookmark")
        foot -e bash -c '
            BOOKMARKS_FILE="$HOME/.config/rofi/bookmarks.txt"
            
            clear
            echo "┌────────────────────────────────────────────────────────────────┐"
            echo "│                    REMOVE BOOKMARK                             │"
            echo "└────────────────────────────────────────────────────────────────┘"
            echo ""
            
            if [ ! -f "$BOOKMARKS_FILE" ] || [ ! -s "$BOOKMARKS_FILE" ]; then
                echo "  No bookmarks found"
                sleep 2
                exit 0
            fi
            
            echo "  Available bookmarks:"
            echo ""
            
            i=1
            declare -a names
            declare -a urls
            
            while IFS="|" read -r name url; do
                names[$i]="$name"
                urls[$i]="$url"
                printf "    %2d. %s\n" "$i" "$name"
                i=$((i + 1))
            done < "$BOOKMARKS_FILE"
            
            total=$((i - 1))
            
            if [ "$total" -eq 0 ]; then
                echo "  No bookmarks available"
                sleep 2
                exit 0
            fi
            
            echo ""
            read -p "  Select (1-$total, 0 to cancel): " num
            
            if ! [[ "$num" =~ ^[0-9]+$ ]] || [ "$num" -lt 0 ] || [ "$num" -gt "$total" ]; then
                echo ""
                echo "  ERROR: Invalid selection"
                sleep 2
                exit 1
            fi
            
            if [ "$num" -eq 0 ]; then
                echo "  Cancelled"
                sleep 1
                exit 0
            fi
            
            echo ""
            echo "  Remove: ${names[$num]}"
            read -p "  Confirm? (y/N): " confirm
            
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                sed -i "${num}d" "$BOOKMARKS_FILE"
                echo ""
                echo "  SUCCESS: Bookmark removed"
                sleep 2
            else
                echo "  Cancelled"
                sleep 1
            fi
        '
        ;;
    *)
        # Handle custom bookmarks
        bookmark_name="${chosen#󰖟  }"
        while IFS='|' read -r name url; do
            if [ "$name" = "$bookmark_name" ]; then
                xdg-open "$url" &
                break
            fi
        done < "$BOOKMARKS_FILE"
        ;;
esac
