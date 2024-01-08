#!/bin/bash

# Function to display notification
show_notification() {
    notify-send "Battery Notification" "$1"
}

# Get the battery status using acpi
battery_status=$(acpi -b | awk '{print $3, $4}' | tr -d ',')

# Extract the battery percentage
battery_percentage="${battery_status%%%*}"

# Check if the battery is charging
if [[ "$battery_status" == *"Charging"* ]]; then
    show_notification "Thank you for charging! 😊"
elif [ "$battery_percentage" -le 20 ]; then
    show_notification "Battery is low! Please connect the charger."
elif [ "$battery_percentage" -gt 0 ]; then
    show_notification "Battery level is $battery_percentage%. Keep going!"
else
    show_notification "Battery is critically low! Connect the charger now."
fi



# chmod +x battery_notification.sh
# crontab -e
# */5 * * * * /path/to/battery_notification.sh
