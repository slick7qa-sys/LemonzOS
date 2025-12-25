#!/bin/bash
# LemonzOS Build Script - THE "FORCE DEBIAN" VERSION
set -e

echo "--- Starting LemonzOS Build Process ---"

# 1. Clean up any old "stubborn" config files from previous failed runs
echo "Cleaning old config..."
sudo lb clean --all || true
rm -rf config/

# 2. Initialize live-build (CRITICAL: added --mode debian)
echo "Initializing live-build for Debian Bookworm..."
lb config \
    --mode debian \
    --distribution bookworm \
    --debian-installer false \
    --archive-areas "main contrib non-free non-free-firmware" \
    --apt-recommends false \
    --linux-flavours amd64 \
    --mirror-bootstrap "http://deb.debian.org/debian/" \
    --mirror-chroot "http://deb.debian.org/debian/"

# 3. Re-create the folder structure
echo "Re-creating folders..."
mkdir -p config/package-lists
mkdir -p config/includes.chroot/etc/gtk-3.0

# 4. Write the app list
echo "Setting up app list..."
cat <<EOF > config/package-lists/lemonz.list.chroot
systemd
linux-image-amd64
live-boot
live-config
dde
firefox-esr
arc-theme
papirus-icon-theme
EOF

# 5. Run the build
echo "Building the ISO (this time for real)..."
sudo lb build
