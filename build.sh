#!/bin/bash
set -e

# 1. Setup
lb config --mode debian --distribution bookworm --archive-areas "main contrib non-free non-free-firmware" --apt-recommends false

# 2. CREATE ALL FOLDERS FIRST
mkdir -p config/package-lists
mkdir -p config/includes.chroot/etc/gtk-3.0
mkdir -p config/includes.chroot/usr/local/bin

# 3. Packages
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

# 4. macOS Theme Config
cat <<EOF > config/includes.chroot/etc/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=Arc-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Ubuntu 11
EOF

# 5. Run build
sudo lb build
