#!/usr/bin/env bash

set -euo pipefail

ROFI_THEME="$HOME/.config/rofi/themes/wallpaper-grid.rasi"
WALL_DIR="$HOME/.config/wallpapers"
DEFAULT_WALL="/usr/share/hypr/wall0.png"

WALLPAPER=''
[[ -d "$WALL_DIR" ]] || WALL_DIR="/usr/share/hypr"
case "${1:-}" in 
  S|s|Select)
    IMAGES=''
    while IFS= read -r -d '' img; do
      IMAGES+="$img\0icon\x1f$img\n"
    done < <(
      find -L "$WALL_DIR" -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
        -print0
      )
      WALLPAPER=$(printf "%b" "$IMAGES" | rofi -dmenu -theme "$ROFI_THEME")
      [[ -n "$WALLPAPER" ]] || exit 0
    ;;
  *)
    IMAGES=()
    while IFS= read -r -d '' img; do
      IMAGES+=("$img")
    done < <(
      find -L "$WALL_DIR" -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
        -print0
      )
    if (( ${#IMAGES[@]} == 0 )); then
        WALLPAPER="$DEFAULT_WALL"
    else
        WALLPAPER="${IMAGES[RANDOM % ${#IMAGES[@]}]}"
    fi
    ;;
  esac

[[ -f "$WALLPAPER" ]] || WALLPAPER="$DEFAULT_WALL"

mkdir -p ~/.cache
ln -sf "$WALLPAPER" ~/.cache/current_wallpaper

if ! pgrep -x swww-daemon >/dev/null; then
    /usr/bin/swww-daemon &>/dev/null &
    sleep 0.3
fi

swww img "$WALLPAPER" \
  --transition-type any \
  --transition-duration 1.2 \
  --transition-fps 60

echo "Wallpaper: $(basename "$WALLPAPER")"

