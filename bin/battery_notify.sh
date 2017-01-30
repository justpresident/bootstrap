#!/bin/bash
battery_info=$(acpi -V | grep Battery | awk 'NR==1')
battery_status=$(echo $battery_info | sed 's/^Battery 0: \([a-zA-Z]*\)\(.*\)/\1/') # Charging | Discharging
battery_percentage=$(echo $battery_info | sed 's/^Battery 0: [a-zA-Z]*, \([0-9]*\)%.*/\1/')
if [ $battery_status == "Discharging" -a $battery_percentage -lt 14 ]
  then
    notify-send "Fuck, battery is Low: ${battery_percentage}" "Move your ass to power plug"
fi
