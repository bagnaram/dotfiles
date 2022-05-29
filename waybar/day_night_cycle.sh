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
    sed -i 's#@theme ".*"#@theme "'"$1"'"#g' "${get_link}"
}

set_mutt_theme()
{
    CDIR="${HOME}/.mutt"
    get_link=$(readlink -f "${CDIR}/muttrc")
    sed -i "s#source ~/dotfiles/mutt/themes/.*#source ~/dotfiles/mutt/themes/$1#g" "${get_link}"
}

set_daytime()
{
    notify-send -a "day-night-cycle" "☀ Switching to daytime"
    gsettings set org.gnome.desktop.interface gtk-theme 'OneStepBack'
    gsettings set org.gnome.desktop.interface icon-theme 'Memphis98'

    crudini --inplace --set --existing ~/.config/qt5ct/qt5ct.conf Appearance style Windows
    crudini --inplace --set --existing ~/.config/qt5ct/qt5ct.conf Appearance icon_theme Memphis98
    if pgrep "emacs" >/dev/null 2>&1 ; then
      emacsclient --eval '(light-theme)' --suppress-output &
    fi
    #kitty @ --to unix:/tmp/mykitty set-colors --all --configured ~/.config/kitty/Belafonte_Day.conf &
    #yq eval -i '.colors alias = "light"' ${HOME}/dotfiles/alacritty/dracula-pro.yml &
    # set sway theme
    swaymsg "client.focused_inactive #414D58 #414D58 #F8F8F2 #414D58 #414D58;
             client.focused          #556995 #556995 #FCFBF9 #556995 #556995;
             client.unfocused        #F7F3EE #F7F3EE #605A52 #292d2e #F7F3EE;
             client.urgent           #708CA9 #FF5555 #F8F8F2 #FF5555 #FF5555;
             client.placeholder      #8F5652 #8F5652 #F8F8F2 #0B0D0F #0B0D0F"
    set_rofi_theme /usr/share/rofi/themes/paper-float.rasi
    set_mutt_theme mutt-colors-solarized-light-256.muttrc
    echo 1 > ~/DAY
    pkill -RTMIN+1 waybar
    pkill -USR1 zsh
}

set_nighttime(){
    notify-send -a "day-night-cycle" "🌙 Switching to nighttime"
    gsettings set org.gnome.desktop.interface gtk-theme 'Dracula'
    gsettings set org.gnome.desktop.interface icon-theme 'Memphis98'

    crudini --set --existing ~/.config/qt5ct/qt5ct.conf Appearance style Adwaita-Dark
    crudini --set --existing ~/.config/qt5ct/qt5ct.conf Appearance icon_theme WhiteSur-dark

    if pgrep "emacs" >/dev/null 2>&1 ; then
      emacsclient --eval '(dark-theme)' --suppress-output &
    fi
    #kitty @ --to unix:/tmp/mykitty set-colors --all --configured ~/.config/kitty/dracula.conf &
    #yq eval -i '.colors alias = "dark"' ${HOME}/dotfiles/alacritty/dracula-pro.yml &
    # set sway theme
    swaymsg "client.focused_inactive #414D58 #414D58 #F8F8F2 #414D58 #414D58;
             client.focused          #708CA9 #708CA9 #F8F8F2 #708CA9 #708CA9;
             client.unfocused        #0B0D0F #0B0D0F #BFBFBF #0B0D0F #0B0D0F;
             client.urgent           #708CA9 #FF5555 #F8F8F2 #FF5555 #FF5555;
             client.placeholder      #0B0D0F #0B0D0F #F8F8F2 #0B0D0F #0B0D0F"

    set_rofi_theme /usr/share/rofi/themes/purple.rasi
    set_mutt_theme dracula.muttrc
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
        notify-send -a "gammastep" "gammastep period change at $(date "+%H:%M")" "$(echo "$@")"
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
