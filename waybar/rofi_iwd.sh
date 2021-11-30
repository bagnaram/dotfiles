#!/usr/bin/env zsh

script=$(basename "$0")
help="$script [-h/--help] -- script to connect to wlan with iwd
  Usage:
    depending on how the script is named,
    it will be executed either with dmenu or with rofi
  Examples:
    dmenu_iwd.sh
    rofi_iwd.sh"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    printf "%s\n" "$help"
    exit 0
fi

function wofi() {
    command wofi -d -I "$@"
}
function rofi() {
    command rofi -m -1 -l 3 -theme solarized -dmenu -i "$@"
}
function ssid-scan(){
    ~/dotfiles/waybar/iwd-scan.py "$@"
}

case $script in
    dmenu_*)
        label_interface="interface »"
        menu_interface="dmenu -l 3 -c -bw 2 -r -i"
        label_ssid="ssid »"
        menu_ssid="dmenu -l 10 -c -bw 2 -r -i"
        label_psk="passphrase »"
        menu_psk="dmenu -l 1 -c -bw 2 -i"
        ;;
    rofi_*)
        label_interface=""
        #menu_interface="rofi -m -1 -l 3 -theme solarized -dmenu -i"
        menu_interface="wofi -d -I"
        label_ssid=""
        #menu_ssid="rofi -m -1 -l 10 -theme solarized -dmenu -i"
        menu_ssid="wofi -d -I"
        label_psk=""
        #menu_psk="rofi -m -1 -l 1 -theme solarized -dmenu -i"
        menu_psk="wofi -d -I"
        ;;
    *)
        printf "%s\n" "$help"
        exit 1
        ;;
esac

remove_escape_sequences() {
    tail -n +5 \
        | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g;/^\s*$/d"
}

get_interface() {
    interface=$(iwctl device list \
        | remove_escape_sequences \
        | awk '{printf("%-12s %-9s %s\n", $1, $2, $3)}' \
        | wofi -p "$label_interface" \
        | awk '{print $1}'
    )
    [ -n "$interface" ] \
        || exit 1
}

scan_ssid() {
    #iwctl station "$interface" scan

    #scan_result=$(iwctl station wlan0 get-networks | remove_escape_sequences | awk '/\*/{ printf("%-40ls%-8ls%ls\n", substr($0,5,32), substr($0, 37, 4), substr($0,41,44)) }')
    scan_result=$(ssid-scan | gawk 'NR%3{printf("%-32ls",$0) ;next;}1')

#    scan_result=$(iwctl station "$interface" get-networks \
#        | remove_escape_sequences \
#        | sed 's/ psk / ; psk ; /;s/ open / ; [open] ; /;s/\s\+/ /g; s/> />/g' \
#        | awk '/\*/{ printf( substr($0,5,32) }'
#        | awk -F " ; " '{printf("%-70ls%-8ls%ls\n", $1, $2, $3)}' \
#    )
}

get_ssid() {

    #notify-send.sh $scan_result
    select=$(printf "🔁[RESCAN]\n%s" "$scan_result" \
        | wofi -p "$label_ssid" \
    )



    if [[ "$select" =~ '^>' ]]
    then
        notify-send.sh "iNet wireless daemon" "Already connected to this network."
        exit 0
    elif [[ "$select" =~ 'open *$' ]]
    then
        open=1
    elif [[ "$select" = "🔁[RESCAN]" ]]
    then
        scan_ssid
        get_ssid
        return
    elif ! [[ -v select ]] || [[ "$select" = "" ]]
    then
        exit 1
    fi

    # Get just list of SSIDsin raw
    ssids=$(ssid-scan ssid)

    # iterate through raw SSID list to determine which one to connect to
    while IFS= read -r ssid_list
    do
        if [[ $select =~ $ssid_list ]] then
            ssid=$ssid_list
            return
        fi
    done <<< "$ssids"
}

get_psk() {
    psk=$(printf 'press esc or enter if you had already insert a passphrase before!\n' \
        | wofi -p "$label_psk" \
    )
}

connect_iwd() {
    if [[ "$open" = 1 ]]
    then
        iwctl station "$interface" connect ''$ssid''
    else
        get_psk
        iwctl station "$interface" connect "$ssid" -P "$psk"
    fi
    notify-send "iNet wireless daemon" "connected to \"$ssid\""
}

get_interface \
    && scan_ssid \
    && get_ssid \
    && connect_iwd
