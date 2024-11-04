#!/bin/bash

#####################################################################################
# Script Name: pveproxy_toggle.sh
# Author: ddrimus
# Repository: https://github.com/ddrimus/proxmox-scripts
# Version: 1.0
# Description: Manages Proxmox GUI access configuration.
#####################################################################################

set -e

CONFIG_FILE="/etc/default/pveproxy"
RESTRICTION='ALLOW_FROM="127.0.0.1,192.168.1.210"'
DENY_ALL='DENY_FROM="all"'

# Ensure script runs as root
check_root() {
    if [ "$UID" -ne 0 ]; then
        exec sudo bash "$0" "$@"
    fi
}

# Toggle configuration
toggle_config() {
    printf "Toggling configuration..."
    if grep -q "$RESTRICTION" "$CONFIG_FILE"; then
        sed -i "/$RESTRICTION/d" "$CONFIG_FILE"
        sed -i "/$DENY_ALL/d" "$CONFIG_FILE"
        MESSAGE="Proxmox GUI accessible from everywhere."
    else
        printf "%s\n" "$DENY_ALL" > "$CONFIG_FILE"
        printf 'POLICY="allow"\n' >> "$CONFIG_FILE"
        printf "%s\n" "$RESTRICTION" >> "$CONFIG_FILE"
        MESSAGE="Proxmox GUI access restricted."
    fi
    [ $? -eq 0 ] && printf "[ OK ]\n" || { printf "[ ERROR ]\n"; exit 1; }
}

# Restart pveproxy service
restart_service() {
    printf "Restarting pveproxy..."
    service pveproxy restart > /dev/null 2>&1 && printf "[ OK ]\n" || { printf "[ ERROR ]\n"; exit 1; }
}

# Start the process
check_root
toggle_config
restart_service
printf "%s\n" "$MESSAGE"

exit 0