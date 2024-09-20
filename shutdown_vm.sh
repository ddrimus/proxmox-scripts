#!/bin/bash

#####################################################################################
# Script Name: shutdown_vm.sh
# Author: ddrimus
# Repository: https://github.com/ddrimus/proxmox-scripts
# Version: 1.0
# Description: Unlocks and stops a Proxmox VM.
# Usage: ./shutdown_vm.sh <VM_ID>
#####################################################################################

set -e

VM_ID=$1

# Ensure script runs as root
check_root() {
    if [ "$UID" -ne 0 ]; then
        exec sudo bash "$0" "$VM_ID"
    fi
}

# Check if VM_ID is provided
check_vm_id() {
    printf "Checking VM ID..."
    if [ -z "$VM_ID" ]; then
        printf "[ ERROR ]\n"
        printf "Usage: $0 <VM_ID>\n"
        exit 1
    fi
    printf "[ OK ]\n"
}

# Check if VM is running
check_vm_status() {
    printf "Checking VM status..."
    if ! qm status "$VM_ID" 2>&1 | grep -q "status: running"; then
        printf "[ NOT RUNNING ]\n"
        printf "VM $VM_ID is not running.\n"
        exit 0
    fi
    printf "[ OK ]\n"
}

# Unlock the VM
unlock_vm() {
    printf "Unlocking VM..."
    qm unlock "$VM_ID" > /dev/null 2>&1 && printf "[ OK ]\n" || { printf "[ ERROR ]\n"; exit 1; }
}

# Remove lock file
remove_lock_file() {
    printf "Removing lock file..."
    rm -f "/run/lock/qemu-server/lock-$VM_ID.conf" > /dev/null 2>&1 && printf "[ OK ]\n" || { printf "[ ERROR ]\n"; exit 1; }
}

# Stop the VM
stop_vm() {
    printf "Stopping VM..."
    qm stop "$VM_ID" > /dev/null 2>&1 && printf "[ OK ]\n" || { printf "[ ERROR ]\n"; exit 1; }
}

# Start the process
check_root
check_vm_id
check_vm_status
unlock_vm
remove_lock_file
stop_vm
printf "VM $VM_ID has been stopped.\n"

exit 0