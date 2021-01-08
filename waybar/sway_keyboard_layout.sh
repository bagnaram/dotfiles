#!/usr/bin/env bash
set -euo pipefail

DEFAULT_LAYOUT="English (US)"

# Kill old instances since waybar don't kill them when exited
[ "$(pgrep -a 'swaymsg' | grep -c '["input"]')" -gt 0 ] &&
  pgrep -a 'swaymsg' | grep '["input"]' | cut -d ' ' -f1 | xargs -r kill

# Sleep for a short while in order to prevent startup issues in waybar
sleep 0.5

keyboard_flag() {
  while read -r layout; do
    if [ "$layout" = "English (US)" ]; then
      layout_waybar="🇺🇸"
    elif [ "$layout" = "Swedish" ]; then
      layout_waybar="🇸🇪"
    else
      layout_waybar="$layout"
    fi

    printf '%s\n' "$layout_waybar"
  done
}

swaymsg --type get_inputs | grep \"xkb_active_layout_name\" | sed -u '1!d; s/^.*xkb_active_layout_name\": \"//; s/ (US)//; s/\",//' && swaymsg --type subscribe --monitor '[\"input\"]' | sed -u 's/^.*xkb_active_layout_name\": \"//; s/\",.*$//; s/ (US)//'",

echo "$DEFAULT_LAYOUT" | keyboard_flag
swaymsg -mrt subscribe '["input"]' | jq -r --unbuffered "select(.change == \"xkb_layout\") | .input | select(.type == \"keyboard\") | .xkb_active_layout_name" | keyboard_flag
