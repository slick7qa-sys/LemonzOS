#!/bin/bash
# LemonzOS Build Script - FIXED VERSION
set -e

echo "--- Starting LemonzOS Build Process ---"

# 1. Initialize live-build configuration (FIXED with distribution and mirrors)
echo "Initializing live-build..."
lb config \
    --distribution bookworm \
    --debian-installer false \
    --archive-areas "main contrib non-free non-free-firmware" \
    --apt-recommends false \
    --linux-flavours amd64 \
    --mirror-bootstrap "http://deb.debian.org/debian/" \
    --mirror-chroot "http://deb.debian.org/debian/"

# 2. Create the folder structure
echo "Creating folders..."
mkdir -p config/package-lists
mkdir -p config/includes.chroot/etc/gtk-3.0
mkdir -p config/includes.chroot/usr/local/bin

# 3. Create the Package List
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

# 4. Theme settings
cat <<EOF > config/includes.chroot/etc/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=Arc-Dark
gtk-icon-theme-name=Papirus-Dark
EOF

# 5. Run the build
echo "Building the ISO (this should work now)..."
sudo lb build
