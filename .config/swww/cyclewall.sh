#!/bin/bash

ini="$HOME/.config/swww/wallpaper.ini"
dir="$HOME/.config/swww/Arch-Walls/wallpapers"

# Read current wallpaper path (4th field from ini)
current=$(cut -d'|' -f4 "$ini")
basename=$(basename "$current" .jpg) # e.g., 0053
num=$((10#$basename))                # current number as int

# Direction arg: "next" or "prev"
case "$1" in
next) newnum=$((num + 1)) ;;
prev) newnum=$((num - 1)) ;;
*)
    echo "Usage: $0 {next|prev}"
    exit 1
    ;;
esac

# Wrap around if needed
if [[ "$newnum" -lt 1 ]]; then
    # go to max (last wallpaper)
    max=$(ls "$dir"/*.jpg | sort | tail -n1 | xargs -n1 basename | sed 's/\.jpg//')
    newnum=$((10#$max))
fi

nextfile=$(printf "%04d.jpg" "$newnum")

# If file doesn’t exist, wrap to 0001
if [[ ! -f "$dir/$nextfile" ]]; then
    nextfile="0001.jpg"
fi

# Update ini
echo "1|Arch-Walls|Info|$dir/$nextfile" >"$ini"

# Ensure swww is running
pgrep -x swww >/dev/null || swww init

# Apply wallpaper
swww img "$dir/$nextfile" --transition-type grow --transition-fps 60 --transition-duration 2
