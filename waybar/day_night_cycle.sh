#!/usr/bin/env sh
set -uo pipefail
scheme=$(<~/DAY)

set_rofi_theme()
{
    CDIR="${XDG_CONFIG_HOME:-${HOME}/.config}/rofi"
    if [ ! -d "${CDIR}" ]
    then
        mkdir -p "${CDIR}"
    fi
    get_link=$(readlink -f "${CDIR}/config.rasi")
    sed -i '/^\s*\(@theme\s\+".*"\)/d' "${get_link}" 1> /dev/null 2>&1
    echo "@theme \"${1}\"" >> "${get_link}"
}

set_daytime()
{
    notify-send "Switching to daytime"
    gsettings set org.gnome.desktop.interface gtk-theme 'OneStepBack'
    gsettings set org.gnome.desktop.interface icon-theme 'Memphis98'

    crudini --inplace --set --existing ~/.config/qt5ct/qt5ct.conf Appearance style Adwaita
    crudini --inplace --set --existing ~/.config/qt5ct/qt5ct.conf Appearance icon_theme Memphis98
    if pgrep "emacs" >/dev/null 2>&1 ; then
      emacsclient --eval '(light-theme)' --suppress-output &
    fi
    #kitty @ --to unix:/tmp/mykitty set-colors --all --configured ~/.config/kitty/Belafonte_Day.conf &
    #yq eval -i '.colors alias = "light"' ${HOME}/dotfiles/alacritty/dracula-pro.yml &
    set_rofi_theme /usr/share/rofi/themes/paper-float.rasi
    echo 1 > ~/DAY
    pkill -RTMIN+1 waybar
    pkill -USR1 zsh
}

set_nighttime(){
    notify-send "Switching to nighttime"
    gsettings set org.gnome.desktop.interface gtk-theme 'Dracula'
    gsettings set org.gnome.desktop.interface icon-theme 'Memphis98'

    crudini --set --existing ~/.config/qt5ct/qt5ct.conf Appearance style Adwaita-Dark
    crudini --set --existing ~/.config/qt5ct/qt5ct.conf Appearance icon_theme WhiteSur-dark

    if pgrep "emacs" >/dev/null 2>&1 ; then
      emacsclient --eval '(dark-theme)' --suppress-output &
    fi
    #kitty @ --to unix:/tmp/mykitty set-colors --all --configured ~/.config/kitty/dracula.conf &
    #yq eval -i '.colors alias = "dark"' ${HOME}/dotfiles/alacritty/dracula-pro.yml &
    set_rofi_theme /usr/share/rofi/themes/purple.rasi
    echo 0 > ~/DAY
    pkill -RTMIN+1 waybar
    pkill -USR1 zsh
}

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit
fi

# Handle invocation as gammastep hook
case "$1" in
    "period-changed")
        # Test some echos
        notify-send "gammastep period change at $(date "+%H:%M")" "$(echo "$@")"
        if [ "$2" = "daytime" ] && [ "$3" = "transition" ]; then
            scheme="1"
            set_nighttime
        elif [ "$2" = "none" ] && [ "$3" = "transition" ]; then
            scheme="1"
            set_nighttime
        elif [ "$2" = "daytime" ] && [ "$3" = "night" ]; then
            scheme="1"
            set_nighttime
        elif [ "$3" = "daytime" ]; then
            scheme="0"
            set_daytime
        elif [ "$3" = "none" ]; then
            scheme="0"
            set_daytime
        fi
    ;;
    "set")
        if [[ "$scheme" = "0" ]]; then
        sky=""
        printf '%s\nNight Mode\nnight' "$sky"
        set_daytime
        elif [[ "$scheme" = "1" ]]; then
        sky=""
        printf '%s\nDay Mode\nday' "$sky"
        set_nighttime
        fi
    ;;
    "get")
        if [[ "$scheme" = "0" ]]; then
        sky=""
        printf '%s\nNight Mode\nnight' "$sky"
        elif [[ "$scheme" = "1" ]]; then
        sky=""
        printf '%s\nDay Mode\nday' "$sky"
        fi
        exit
    ;;
    *)
        echo "Invalid option: $1"
    ;;
esac
