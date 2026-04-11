#!/bin/bash
set -e

MOUNT="/mnt/wsl"

# List of known WSL/Docker vhdx files. To update, run:
# fd -e vhdx . /mnt/windows-1/Users --type f
VHDX_LIST=(
    "/mnt/windows-1/Users/Noah Burghardt/AppData/Local/Docker/wsl/main/ext4.vhdx"
    "/mnt/windows-1/Users/Noah Burghardt/AppData/Local/Docker/wsl/disk/docker_data.vhdx"
    "/mnt/windows-1/Users/Noah Burghardt/AppData/Local/Packages/TheDebianProject.DebianGNULinux_76v4gfsz19hv4/LocalState/ext4.vhdx"
    "/mnt/windows-1/Users/Noah Burghardt/AppData/Local/Packages/CanonicalGroupLimited.Ubuntu22.04LTS_79rhkp1fndgsc/LocalState/ext4.vhdx"
)

cleanup() {
    echo "Unmounting..."
    sudo umount -n "$MOUNT" 2>/dev/null || true
    sudo qemu-nbd -d /dev/nbd0 2>/dev/null || true
}

trap cleanup EXIT

VHDX=$(printf '%s\n' "${VHDX_LIST[@]}" | fzf --prompt="Select WSL disk: ")

if [ -z "$VHDX" ]; then
    echo "No disk selected, exiting."
    exit 0
fi

echo "Selected: $VHDX"

sudo modprobe nbd
sudo qemu-nbd -r -c /dev/nbd0 "$VHDX"
sudo mkdir -p "$MOUNT"
sudo mount -n /dev/nbd0 "$MOUNT"

echo "Mounted at $MOUNT. Press enter to unmount."
read
