#!/bin/bash
set -e

echo "🍋 LemonzOS: Final Polish Version"

# 1. Fix the keys again
sudo apt-get install -y debian-archive-keyring

# 2. Complete Reset
sudo lb clean --all
rm -rf config/

# 3. Configure (The bare essentials)
lb config \
    --mode debian \
    --distribution bookworm \
    --archive-areas "main contrib non-free non-free-firmware" \
    --debian-installer false \
    --apt-recommends false

# 4. Folders
mkdir -p config/package-lists
mkdir -p config/includes.chroot/etc/gtk-3.0

# 5. The App List
cat <<EOF > config/package-lists/lemonz.list.chroot
live-boot
live-config
live-config-systemd
dde
firefox-esr
arc-theme
papirus-icon-theme
EOF

# 6. The macOS Theme
cat <<EOF > config/includes.chroot/etc/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=Arc-Dark
gtk-icon-theme-name=Papirus-Dark
EOF

# 7. Build
echo "🚀 The kitchen is hot! Building now..."
sudo lb build
