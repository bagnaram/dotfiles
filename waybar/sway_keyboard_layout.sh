#!/usr/bin/env bash
set -euo pipefail

DEFAULT_LAYOUT="English (US)"

# Kill old instances since waybar don't kill them when exited
[ "$(pgrep -a 'swaymsg' | grep -c '["input"]')" -gt 0 ] &&
  pgrep -a 'swaymsg' | grep '["input"]' | cut -d ' ' -f1 | xargs -r kill

# Sleep for a short while in order to prevent startup issues in waybar
sleep 0.5

layout=`swaymsg --type get_inputs --raw | jq '.[] | select(.type == "keyboard") | select(.name == "AT Translated Set 2 keyboard") | .xkb_active_layout_name' -r`

keyboard_flag() {
  while read -r layout; do
    if [ "$layout" = "English (Dvorak)" ]; then
      layout_waybar="       DV"
    elif [ "$layout" = "English (US)" ]; then
      layout_waybar="  "
    else
      layout_waybar="$DEFAULT_LAYOUT"
    fi

    printf '%s\n' "$layout_waybar"
  done
}


echo $layout | keyboard_flag
# swaymsg -mrt subscribe '["input"]' | jq -r --unbuffered 'select(.change == "xkb_layout") | .input | select(.type == "keyboard") | .xkb_active_layout_name' | keyboard_flag
