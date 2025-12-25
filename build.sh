#!/bin/bash
# LemonzOS Build Script - Orchestrates the ISO creation
set -e

echo "--- Starting LemonzOS Build Process ---"

# 1. Initialize live-build configuration
echo "Initializing live-build..."
lb config \
    --debian-installer false \
    --archive-areas "main contrib non-free" \
    --apt-recommends false \
    --linux-flavours amd64

# 2. Create the folder structure
echo "Creating folders..."
mkdir -p config/package-lists
mkdir -p config/includes.chroot/etc/gtk-3.0
mkdir -p config/includes.chroot/usr/local/bin

# 3. Create the Package List (The Apps)
echo "Setting up app list..."
cat <<EOF > config/package-lists/lemonz.list.chroot
# Core & Desktop
systemd
linux-image-amd64
dde
deepin-desktop-environment

# Apps & Themes
firefox-esr
vlc
gimp
arc-theme
papirus-icon-theme
EOF

# 4. Create the macOS-style GTK config
echo "Applying macOS theme settings..."
cat <<EOF > config/includes.chroot/etc/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=Arc-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Ubuntu 11
gtk-cursor-theme-name=Deepin
gtk-application-prefer-dark-theme=1
EOF

# 5. Run the actual build
echo "Building the ISO (this takes time)..."
sudo lb build
