#!/bin/bash

# Get the battery status using acpi
battery_status=$(acpi -b | awk '{print $4}' | tr -d ',')

# Extract the percentage from the battery status
battery_percentage="${battery_status%%%*}"

# Check if the battery percentage is less than or equal to 20
if [ "$battery_percentage" -le 20 ]; then
    # Display a notification using notify-send
    notify-send "Battery Low" "Battery level is $battery_percentage%. Please connect the charger."
fi


# chmod +x battery_notification.sh
# crontab -e
# */5 * * * * /path/to/battery_notification.sh
