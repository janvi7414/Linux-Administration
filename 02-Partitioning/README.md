
# GPT Partitioning & LVM Management

A practical guide demonstrating production-level storage engineering in Linux. This project covers physical storage slicing via `fdisk` using modern GPT layouts, building an elastic Logical Volume Management (LVM) layer, handling swap configuration maintenance, and executing a safe, clean process.

**Architectural Blueprint**

Rather than binding filesystems directly to rigid physical partitions, I implemented **Logical Volume Management (LVM)**. This adds a virtualization layer over physical disks, allowing me to resize volumes easily when storage demands shift.

**Step-by-Step Implementation Guide**

### 1. Creating Partitions

I explicitly transform the partition mapping from MBR/DOS to a **GUID Partition Table (GPT)**. GPT provides robust structural redundancy, supports block configurations past 2TB, and handles up to 128 primary partitions cleanly.

```bash
fdisk /dev/sdb

```

**Interactive Sequence Inside fdisk:**

* Type `g` -> Changes disk label to GPT.
* Type `n` -> Add partition 1 (hit enter for default number and start sector, use +2G for last sector).
* Type `n` -> Add partition 2 (hit enter for default number and start sector, use +3G for last sector).
* Type `w` -> Write block structural tables to disk and exit.

```bash
# Inspect generated block devices
fdisk -l /dev/sdb

```

### 2. Establishing the LVM Topology

I built the storage stack sequentially: Physical Volumes (PV) -> Volume Groups (VG) -> Logical Volumes (LV). I also demonstrate how to rename a Volume Group after creation, proving storage management flexibility.

```bash
# Step A: Register physical partitions to LVM layer
pvcreate /dev/sdb1 /dev/sdb2
pvdisplay

# Step B: Pool devices into an temporary VG, then rename to production targets
vgcreate vg_temp /dev/sdb1 /dev/sdb2
vgrename vg_temp vg_production
vgdisplay vg_production

# Step C: Carve out distinct logical block allocations
lvcreate -L 500M -n apps vg_production
lvcreate -L 400M -n data vg_production
lvdisplay

```
### 3. File System Creation & Persistent Mounting

To make sure my storage configurations survive an unexpected reboot, I defined permanent mounting instructions within the filesystem table (`/etc/fstab`) using vim editor.

```bash
# Format allocations with distinct enterprise roles
mkfs.ext4 /dev/vg_production/apps
mkswap /dev/vg_production/data

# Generate landing path nodes
mkdir -p /database /store

# Launch visual file editor
vim /etc/fstab

```

**Paragraph updates to insert at the bottom of /etc/fstab:**
```
/dev/vg_production/apps   /database   ext4    defaults    0 0
/dev/vg_production/data   none        swap    defaults    0 0

```

*(Inside vim, I press `i` to type, paste the text above, press `Esc`, then type `:wq` and hit Enter to save and exit).*

```bash
# Commit configurations and verify current operational properties
mount -a
swapon -a
lsblk -f

```

### 4. Resizing Partitions

Swap memory mappings interact directly with kernel-level memory management tables. To scale my swap volume safely, I must swapoff it, wipeoff file system, expand it at the block layer via `lvresize`, and fully re-initialize it.

```bash
# Deactivate active operating components safely
swapoff /dev/vg_production/data

# Wipe old file system before block resizing
wipefs -a /dev/vg_production/data

# Structural volume scale processing using lvresize
lvresize -L 700M /dev/vg_production/data

# Re-initialize filesystem environment and spin volume back online
mkswap /dev/vg_production/data
swapon /dev/vg_production/data

# Post-resize integrity and details inspection
lsblk -f

```
### 5. Removing Partitions

To remove partitions safely working backward. If any metadata signatures are left behind, the OS can encounter locking conflicts or boot hangs. I systematically clear filesystems before dropping my logical structures.

```bash
# Unmount and stop active processing streams
umount /database
swapoff /dev/vg_production/data

# Clean out active lines from /etc/fstab using vim
vim /etc/fstab

# Wipe metadata signatures directly from LVs before removal
wipefs -a /dev/vg_production/apps
wipefs -a /dev/vg_production/data

# Complete removal of LVM layouts
lvremove -f /dev/vg_production/apps
lvremove -f /dev/vg_production/data
vgremove vg_production
pvremove /dev/sdb1 /dev/sdb2

# rechecking partition for sdb
fdisk /dev/sdb

```

**Interactive Sequence Inside fdisk to clear partitions:**

* Type `d` -> Select partition 2 to delete.
* Type `d` -> Select partition 1 to delete.
* Type `w` -> Commit configuration updates to disk.

```bash
# Force operating system kernel to sync block structures immediately
partprobe /dev/sdb

# Final structural verification status check
fdisk -l /dev/sdb
lsblk

```
