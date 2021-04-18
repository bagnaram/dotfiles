#!/bin/sh
set -euo pipefail

#sleep 0.5

scheme=`yq eval '.colors | alias' ${HOME}/dotfiles/alacritty/dracula-pro.yml`

if [ "$scheme" = "dark" ]; then
  sky=""
  printf '%s\nNight Mode\nnight' "$sky"
  if [ "$1" = "set" ]; then
    gsettings set org.gnome.desktop.interface gtk-theme 'Breeze'
    gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
    if pgrep "emacs" >/dev/null 2>&1 ; then
      emacsclient --eval '(light-theme)' --suppress-output &
    fi
    yq eval -i '.colors alias = "light"' ${HOME}/dotfiles/alacritty/dracula-pro.yml
    pkill -RTMIN+1 waybar
  fi
elif [ "$scheme" = "light" ]; then
  sky=""
  printf '%s\nDay Mode\nday' "$sky"
  if [ "$1" = "set" ]; then
    gsettings set org.gnome.desktop.interface gtk-theme 'Dracula'
    gsettings set org.gnome.desktop.interface icon-theme 'Adwaita-dark'
    if pgrep "emacs" >/dev/null 2>&1 ; then
      emacsclient --eval '(dark-theme)' --suppress-output &
    fi
    yq eval -i '.colors alias = "dark"' ${HOME}/dotfiles/alacritty/dracula-pro.yml
    pkill -RTMIN+1 waybar
  fi
fi
