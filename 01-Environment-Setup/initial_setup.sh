#!/bin/bash

# ************
# Script Name: initial_setup.sh
# Description: Post-install settings and environment preps.
# *************

echo "--- Starting System Provisioning with YUM ---"

# 1. Update the System
# Keeping the system secure by pulling the latest patches.
echo "[1/4] Checking for system updates..."
sudo yum update -y

# 2. Install Administrator Tooling
# Adding tools that are missing from the "Minimal" install.
echo "[2/4] Installing essential admin tools..."
sudo yum install -y vim-enhanced bash-completion net-tools htop wget curl

# 3. Network & Security Hardening
# Standardizing firewall rules for a secure server baseline.
echo "[3/4] Configuring firewall for remote access..."
sudo systemctl enable --now firewalld
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload

# 4. Environment Standardization
# Organizing the workspace for future administration tasks.
echo "[4/4] Creating admin directory structure..."
mkdir -p ~/scripts ~/backups ~/logs

echo "--- Setup Complete: RHEL 10 Instance is Ready ---"
