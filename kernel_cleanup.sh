#!/bin/bash

#####################################################################################
# Script Name: kernel_cleanup.sh
# Author: ddrimus
# Repository: https://github.com/ddrimus/proxmox-scripts
# Version: 1.0
# Description: Cleans up old Proxmox kernels and updates GRUB.
#####################################################################################

set -e

# Ensure script runs as root
check_root() {
    if [ "$UID" -ne 0 ]; then
        exec sudo bash "$0" "$@" || { printf "[ ERROR ]\n"; exit 1; }
    fi
}

# Get current kernel version
get_current_kernel() {
    CURRENT_KERNEL=$(uname -r)
    printf "Current kernel: $CURRENT_KERNEL\n"
}

# Find old kernels
find_old_kernels() {
    printf "Finding old kernels..."
    KERNELS_TO_REMOVE=$(dpkg --list | grep 'kernel-.*-pve' | awk '{print $2}' | grep -v "$CURRENT_KERNEL" | sort -V)
    if [ -z "$KERNELS_TO_REMOVE" ]; then
        printf "[ NOT FOUND ]\n"
        printf "No old kernels found to remove.\n"
        exit 0
    fi
    printf "[ FOUND ]\n"
    printf "Kernels to be removed: $KERNELS_TO_REMOVE\n"
}

# Confirm removal
confirm_removal() {
    printf "Confirming removal..."
    read -p "Proceed with removing old kernels? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        printf "[ ABORTED ]\n"
        printf "Aborted by user.\n"
        exit 0
    fi
    printf "[ CONFIRMED ]\n"
}

# Remove old kernels
remove_old_kernels() {
    printf "Removing old kernels..."
    apt purge -y $KERNELS_TO_REMOVE > /dev/null 2>&1 && printf "[ OK ]\n" || { printf "[ ERROR ]\n"; exit 1; }
}

# Update GRUB
update_grub() {
    printf "Updating GRUB..."
    update-grub > /dev/null 2>&1 && printf "[ OK ]\n" || { printf "[ ERROR ]\n"; exit 1; }
}

# Start the process
check_root
get_current_kernel
find_old_kernels
confirm_removal
remove_old_kernels
update_grub
printf "Kernel cleanup completed.\n"

exit 0
