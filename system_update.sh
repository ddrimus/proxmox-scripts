#!/bin/bash

#####################################################################################
# Script Name: system_update.sh
# Author: ddrimus
# Repository: https://github.com/ddrimus/proxmox-scripts
# Version: 1.0
# Description: Update and clean the system.
#####################################################################################

set -e

# Ensure script runs as root
check_root() {
    if [ "$UID" -ne 0 ]; then
        exec sudo bash "$0" "$@"
    fi
}

# Check internet connection
check_internet() {
    printf "Checking internet..."
    wget -q --spider https://www.cloudflare.com > /dev/null 2>&1 && printf "[ OK ]\n" || { printf "[ ERROR ]\n"; exit 1; }
}

# Update package list
update_package_list() {
    printf "Updating package list..."
    apt-get update > /dev/null 2>&1 && printf "[ OK ]\n" || { printf "[ ERROR ]\n"; exit 1; }
}

# Upgrade installed packages
upgrade_packages() {
    printf "Upgrading packages..."
    apt-get upgrade -y > /dev/null 2>&1 && printf "[ OK ]\n" || { printf "[ ERROR ]\n"; exit 1; }
}

# Perform dist-upgrade
dist_upgrade() {
    printf "Running dist-upgrade..."
    apt-get dist-upgrade -y > /dev/null 2>&1 && printf "[ OK ]\n" || { printf "[ ERROR ]\n"; exit 1; }
}

# Clean package cache
clean_cache() {
    printf "Cleaning cache..."
    apt-get clean > /dev/null 2>&1 && printf "[ OK ]\n" || { printf "[ ERROR ]\n"; exit 1; }
}

# Remove unused packages
autoremove_packages() {
    printf "Removing unused packages..."
    apt-get autoremove -y > /dev/null 2>&1 && printf "[ OK ]\n" || { printf "[ ERROR ]\n"; exit 1; }
}

# Start the process
check_root
check_internet
update_package_list
upgrade_packages
dist_upgrade
clean_cache
autoremove_packages
printf "System update execute successfully.\n"

exit 0