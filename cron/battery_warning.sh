#!/bin/sh

# Reads the current battery percentage, and determines if the value is critically low.
# Displays a a notification when percentage is critically low.
# Relies on notify-send.sh

value=$(</sys/class/power_supply/BAT0/capacity)
status=$(</sys/class/power_supply/BAT0/status)

if [[ $value -lt 11 && "$status" == "Discharging" ]]; then
    notify-send.sh -u "critical" "Low Battery" "$value% remaining"
fi
