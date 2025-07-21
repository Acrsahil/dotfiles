#!/usr/bin/env sh

# === Functions ===

Wall_Update() {
    [ ! -d "${cacheDir}/${curTheme}" ] && mkdir -p "${cacheDir}/${curTheme}"

    local x_wall="$1"
    local x_update="${x_wall/$HOME/~}"
    cacheImg=$(basename "$x_wall")

    echo "DEBUG: Processing wallpaper: $x_wall"

    # Set wallpaper via swww
    "$ScrDir/swwwallbash.sh" "$x_wall" &

    # Create previews only if file exists and path is absolute (prevent // issues)
    if [ -f "$x_wall" ] && [ "${x_wall#/}" != "$x_wall" ]; then
        [ ! -f "${cacheDir}/${curTheme}/${cacheImg}" ] &&
            magick convert -strip "$x_wall" -thumbnail 500x500^ -gravity center -extent 500x500 "${cacheDir}/${curTheme}/${cacheImg}" &

        [ ! -f "${cacheDir}/${curTheme}/${cacheImg}.rofi" ] &&
            magick convert -strip -resize 2000 -gravity center -extent 2000 -quality 90 "$x_wall" "${cacheDir}/${curTheme}/${cacheImg}.rofi" &

        [ ! -f "${cacheDir}/${curTheme}/${cacheImg}.blur" ] &&
            magick convert -strip -scale 10% -blur 0x3 -resize 100% "$x_wall" "${cacheDir}/${curTheme}/${cacheImg}.blur" &
    else
        echo "WARNING: Wallpaper path invalid or file does not exist: $x_wall"
    fi

    wait

    # Update theme config line
    awk -F '|' -v thm="${curTheme}" -v wal="${x_update}" '{OFS=FS} $2==thm{$NF=wal} {print}' "${ThemeCtl}" > "${ScrDir}/tmp" \
        && mv "${ScrDir}/tmp" "${ThemeCtl}"

    ln -fs "${x_wall}" "${wallSet}"
    ln -fs "${cacheDir}/${curTheme}/${cacheImg}.rofi" "${wallRfi}"
    ln -fs "${cacheDir}/${curTheme}/${cacheImg}.blur" "${wallBlr}"
}

Wall_Change() {
    local x_switch=$1
    for ((i = 0; i < ${#Wallist[@]}; i++)); do
        if [ "${Wallist[i]}" = "${fullPath}" ]; then
            if [ "$x_switch" = 'n' ]; then
                nextIndex=$(( (i + 1) % ${#Wallist[@]} ))
            else
                nextIndex=$(( (i - 1 + ${#Wallist[@]}) % ${#Wallist[@]} ))
            fi
            Wall_Update "${Wallist[nextIndex]}"
            break
        fi
    done
}

Wall_Set() {
    [ -z "$xtrans" ] && xtrans="grow"

    swww img "$wallSet" \
        --transition-bezier .43,1.19,1,.4 \
        --transition-type "$xtrans" \
        --transition-duration 0.5 \
        --transition-fps 60 \
        --invert-y \
        --transition-pos "$(hyprctl cursorpos)"
}

# === Setup Variables ===

ScrDir="$(dirname "$(realpath "$0")")"
# Point ThemeCtl to your Arch-Walls wallpaper.ini
ThemeCtl="$HOME/.config/swww/Arch-Walls/wallpaper.ini"

cacheDir="${XDG_CACHE_HOME:-$HOME/.cache}/swww"
wallSet="${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.set"
wallBlr="${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.blur"
wallRfi="${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.rofi"

ctlLine=$(grep '^1|' "${ThemeCtl}")
[ "$(echo "$ctlLine" | wc -l)" -ne 1 ] && echo "ERROR: ${ThemeCtl} Unable to fetch theme..." && exit 1

curTheme=$(echo "$ctlLine" | awk -F '|' '{print $2}')
fullPath=$(echo "$ctlLine" | awk -F '|' '{print $NF}' | sed "s+~+$HOME+")
wallPath=$(dirname "$fullPath")

# Load wallpaper list
mapfile -d '' Wallist < <(find "$wallPath" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | sort -z)

# Fallback if fullPath doesn’t exist
if [ ! -f "$fullPath" ]; then
    fallbackDir="${XDG_CONFIG_HOME:-$HOME/.config}/swww/$curTheme"
    if [ -d "$fallbackDir" ]; then
        wallPath="$fallbackDir"
        mapfile -d '' Wallist < <(find "$wallPath" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | sort -z)
        fullPath="${Wallist[0]}"
    else
        echo "ERROR: wallpaper $fullPath not found..."
        exit 1
    fi
fi

# === Argument Handling ===

while getopts "nps" option; do
    case $option in
        n ) xtrans="grow"; Wall_Change n ;;
        p ) xtrans="outer"; Wall_Change p ;;
        s ) shift $((OPTIND - 1))
            [ -f "$1" ] && Wall_Update "$1" ;;
        * ) echo "n: next | p: previous | s: set image"; exit 1 ;;
    esac
done

# === swww startup + Set wallpaper ===

swww query || swww init
Wall_Set

