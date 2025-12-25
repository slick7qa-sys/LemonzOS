#!/bin/bash
set -e

echo "🍋 LemonzOS: Anti-Error Build"

# 1. Standard Fixes
sudo apt-get install -y debian-archive-keyring

# 2. Hard Reset (Cleaning the pipes)
sudo lb clean --all
sudo rm -rf config/

# 3. Configure - Added 'DEBIAN_FRONTEND' fix
lb config \
    --mode debian \
    --distribution bookworm \
    --archive-areas "main contrib non-free non-free-firmware" \
    --debian-installer false \
    --apt-recommends false

# 4. CRITICAL FIX: This prevents 'Exit Code 100' during package install
mkdir -p config/includes.chroot/etc/apt/apt.conf.d/
echo 'Dpkg::Options { "--force-confdef"; "--force-confold"; };' > config/includes.chroot/etc/apt/apt.conf.d/99force-conf

# 5. App List (Cleaned up)
mkdir -p config/package-lists
cat <<EOF > config/package-lists/lemonz.list.chroot
live-boot
live-config
live-config-systemd
dde
firefox-esr
EOF

# 6. Build with "Non-Interactive" mode forced
echo "🚀 Cooking now... No interruptions allowed!"
sudo DEBIAN_FRONTEND=noninteractive lb build
