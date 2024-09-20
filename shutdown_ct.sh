#!/bin/bash

#####################################################################################
# Script Name: shutdown_ct.sh
# Author: ddrimus
# Repository: https://github.com/ddrimus/proxmox-scripts
# Version: 1.0
# Description: Stops a Proxmox CT.
# Usage: ./shutdown_ct.sh <CT_ID>
#####################################################################################

set -e

CT_ID=$1

# Ensure script runs as root
check_root() {
    if [ "$UID" -ne 0 ]; then
        exec sudo bash "$0" "$CT_ID"
    fi
}

# Check if CT_ID is provided
check_ct_id() {
    printf "Checking CT ID..."
    if [ -z "$CT_ID" ]; then
        printf "[ ERROR ]\n"
        printf "Usage: $0 <CT_ID>\n"
        exit 1
    fi
    printf "[ OK ]\n"
}

# Check if CT is running
check_ct_status() {
    printf "Checking CT status..."
    if ! pct status "$CT_ID" 2>&1 | grep -q "status: running"; then
        printf "[ NOT RUNNING ]\n"
        printf "CT $CT_ID is not running.\n"
        exit 0
    fi
    printf "[ OK ]\n"
}

# Stop the CT
stop_ct() {
    printf "Stopping CT..."
    pct stop "$CT_ID" > /dev/null 2>&1 && printf "[ OK ]\n" || { printf "[ ERROR ]\n"; exit 1; }
}

# Start the process
check_root
check_ct_id
check_ct_status
stop_ct
printf "CT $CT_ID has been stopped.\n"

exit 0