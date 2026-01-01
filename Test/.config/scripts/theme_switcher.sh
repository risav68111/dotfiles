#!/usr/bin/env bash
set -euo pipefail

STOW_DIR="$HOME/dotfiles"
STATE_FILE="$HOME/.config/.current_theme"
DEFAULT_THEME="Default"

mkdir -p "$(dirname "$STATE_FILE")"
if [[ ! -f "$STATE_FILE" ]]; then
  echo "$DEFAULT_THEME" > "$STATE_FILE"
fi

mapfile -t THEMES < <(
  find "$STOW_DIR" \
    -mindepth 1 -maxdepth 1 \
    -type d \
    ! -name '.*' \
    -printf '%f\n' | sort
)

[[ ${#THEMES[@]} -eq 0 ]] && {
  notify-send "Theme switcher" "No themes found"
  exit 1
}

SELECTED_THEME=$(
  printf "%s\n" "${THEMES[@]}" | \
  rofi -dmenu -p "Select theme" -i
)

[[ -z "$SELECTED_THEME" ]] && exit 0
PREV_THEME=$(<"$STATE_FILE")
cd "$STOW_DIR"

if [[ -n "$PREV_THEME" && -d "$PREV_THEME" ]]; then
  stow -D "$PREV_THEME"
fi

stow "$SELECTED_THEME"

( sleep 1
  bash ~/.config/scripts/wallpaper.sh ) &

hyprctl reload
pkill waybar &&
waybar &
pkill -USR1 kitty

echo "$SELECTED_THEME" > "$STATE_FILE"
notify-send "Theme switched" "$PREV_THEME → $SELECTED_THEME"

