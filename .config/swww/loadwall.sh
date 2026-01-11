#!/bin/bash

ini="$HOME/.config/swww/wallpaper.ini"
wall=$(cut -d'|' -f4 "$ini")

# If swww isn’t running, start it
pgrep -x swww >/dev/null || swww init

# Restore last wallpaper
if [[ -f "$wall" ]]; then
    swww img "$wall" --transition-type simple --transition-fps 60 --transition-duration 1
fi
