#!/usr/bin/env bash
set -euo pipefail

scheme=`yq eval '.colors | alias' ${HOME}/dotfiles/alacritty/dracula-pro.yml`

if [ "$scheme" = "dark" ]; then
  sky=""
  printf '%s\nNight Mode\nnight' "$sky"
  if [ "$1" = "set" ]; then
    yq eval -i '.colors alias = "light"' ${HOME}/dotfiles/alacritty/dracula-pro.yml
    gsettings set org.gnome.desktop.interface gtk-theme 'Breeze'
    gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
    export GTK_THEME=Breeze
    emacsclient --eval '(light-theme)'
  fi
elif [ "$scheme" = "light" ]; then
  sky=""
  printf '%s\nDay Mode\nday' "$sky"
  if [ "$1" = "set" ]; then
    yq eval -i '.colors alias = "dark"' ${HOME}/dotfiles/alacritty/dracula-pro.yml
    gsettings set org.gnome.desktop.interface gtk-theme 'Dracula'
    gsettings set org.gnome.desktop.interface icon-theme 'Adwaita-dark'
    export GTK_THEME=Breeze:dark
    emacsclient --eval '(dark-theme)'
  fi
fi

pkill -RTMIN+1 waybar
