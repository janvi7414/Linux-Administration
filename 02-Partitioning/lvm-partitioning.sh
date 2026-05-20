#!/usr/bin/env bash

# Define the hard drive we are working on
TARGET_DISK="/dev/sdb"

echo "-> Initializing GPT Partition Table on $TARGET_DISK..."
fdisk "$TARGET_DISK" << EOF
g
n
1

+2G
n
2

+3G
w
EOF

echo "-> Informing the kernel of partition updates..."
partprobe "$TARGET_DISK"

echo "-> Creating LVM Physical Volumes (PV)..."
pvcreate /dev/sdb1 /dev/sdb2

echo "-> Creating Volume Group (VG) as vg_temp..."
vgcreate vg_temp /dev/sdb1 /dev/sdb2

echo "-> Renaming Volume Group to vg_production..."
vgrename vg_temp vg_production

echo "-> Creating Logical Volumes (LV): apps and data..."
lvcreate -L 500M -n apps vg_production
lvcreate -L 400M -n data vg_production

echo "-> Formatting apps with ext4 and data with Swap..."
mkfs.ext4 /dev/vg_production/apps
mkswap /dev/vg_production/data

echo "-> Creating mount directories..."
mkdir -p /database /store

echo "-> Permanently adding mounts to /etc/fstab..."
echo "/dev/vg_production/apps /database ext4 defaults 0 0" >> /etc/fstab
echo "/dev/vg_production/data none swap defaults 0 0" >> /etc/fstab

echo "-> Activating storage mounts and swap memory..."
mount -a
swapon -a

echo "[SUCCESS] Storage setup complete!"
lsblk -f "$TARGET_DISK"
