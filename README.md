# Proxmox Scripts

A collection of Bash scripts designed to automate and simplify various tasks in a Proxmox environment.

## Scripts

1. **kernel_cleanup.sh**: Cleans up old Proxmox kernels and updates GRUB.
2. **pveproxy_toggle.sh**: Manages Proxmox GUI access configuration.
3. **shutdown_ct.sh**: Stops a Proxmox Container (CT).
4. **shutdown_vm.sh**: Unlocks and stops a Proxmox VM.
5. **system_update.sh**: Updates and cleans the Proxmox system.

## Getting Started

### Prerequisites

- Proxmox VE installed
- Root access to the Proxmox server

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/ddrimus/proxmox-scripts.git
   cd proxmox-scripts
   ```

2. Make the scripts executable:
   ```bash
   chmod +x *.sh
   ```

## Usage

### kernel_cleanup.sh

Cleans up old Proxmox kernels and updates GRUB.

```bash
sudo ./kernel_cleanup.sh
```

### pveproxy_toggle.sh

Toggles Proxmox GUI access configuration between restricted and open access.

```bash
sudo ./pveproxy_toggle.sh
```

#### Configuration

The `pveproxy_toggle.sh` script can be configured to restrict access to specific IP addresses. To customize the script:

1. Open the script in a text editor:
   ```bash
   sudo nano pveproxy_toggle.sh
   ```

2. Locate the following lines near the beginning of the script:
   ```bash
   RESTRICTION='ALLOW_FROM="127.0.0.1,192.168.1.210"'
   DENY_ALL='DENY_FROM="all"'
   ```

3. Modify the `ALLOW_FROM` value to include the IP addresses you want to allow access from. For example:
   ```bash
   RESTRICTION='ALLOW_FROM="127.0.0.1,192.168.1.210,10.0.0.50"'
   ```

4. Save the changes and exit the text editor.

The script will now toggle between allowing access only from the specified IP addresses and allowing access from everywhere.

### shutdown_ct.sh

Stops a specified Proxmox Container (CT).

```bash
sudo ./shutdown_ct.sh <CT_ID>
```

### shutdown_vm.sh

Unlocks and stops a specified Proxmox VM.

```bash
sudo ./shutdown_vm.sh <VM_ID>
```

### system_update.sh

Updates and cleans the Proxmox system.

```bash
sudo ./system_update.sh
```

## Contributing

Contributions are welcome! If you have ideas for improvements or new scripts, feel free to submit a pull request.

## Acknowledgments

- Inspired by the need for automated management tasks in Proxmox environments.
- Thanks to the Proxmox community for their valuable insights and feedback.