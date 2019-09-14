#!/bin/bash

# Reads the current battery percentage, and determines if the value is critically low.
# Displays a a notification when percentage is critically low.
# Relies on notify-send.sh, bundled with https://github.com/bagnaram/hotkey-ctl

acpiV=$(acpi)
value=$(echo $acpiV | cut -d " " -f 4 | sed -e 's/%//' | sed -e 's/,//')
con=$(echo $acpiV | cut -d " " -f 3 | sed -e 's/,//')

if [[ $value -lt 11 && "$con" == "Discharging" ]]; then
    ~bagnaramatt/hotkey-ctl/notify-send.sh/notify-send.sh -u "critical" "Low Battery" "$value% remaining"
fi    
