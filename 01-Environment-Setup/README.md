# RHEL 10 Development Environment Setup

## Project Overview
This repository documents the baseline configuration of a Red Hat Enterprise Linux (RHEL) 10 virtual instance. As a Linux Administrator, maintaining documentation for environment reproducibility is a priority.

## Virtual Machine Specifications (Oracle VirtualBox)
- **OS:** Red Hat Enterprise Linux 10
- **Base Memory:** 2GB (Considering basic need for now)
- **Processors:** 1 vCPU (Considering basic need for now)
- **Storage:** 40GB Dynamic VDI (Expanded from default for LVM flexibility)
- **Firmware:** EFI enabled (Modern standard for boot management)
- **Networking:** Bridge Adapter with SSH (Port 22) enabled for remote management.

## Initial Provisioning Steps
1. **User Management:** Created a non-root user `janvi` for daily operations to follow the principle of **Least Privilege**.
2. **Security:** Configured strong root credentials and enabled the SSH daemon during the Anaconda installation phase.
3. **Storage:** Allocated 40GB to allow for future Logical Volume Management (LVM) testing.

## Post-Installation Automation
After the first boot, I executed a hardening and environment prep script to ensure the system meets administrative standards.

**Administrator's Toolkit**
**vim-enhanced:** A professional text editor with color-coding to help in editing configuration files without making errors.

**bash-completion:** Enables the Tab-key shortcut, allowing us to auto-complete commands and filenames for faster work.

**net-tools:** A collection of networking utilities (like ifconfig) used to troubleshoot connections and check IP addresses.

**htop:** A visual system monitor that shows real-time CPU and RAM usage, making it easy to see if the server is overloaded.

**wget & curl:** Command-line tools used to download files or scripts directly from the internet into your server.

These tools provide the essential visibility and efficiency needed to manage a 'Minimal Install' server in a production environment.
