#!/bin/bash
set -e

echo "🍋 Welcome to the LemonzOS Kitchen!"

# 1. FIX: Install the keyring so the build doesn't get confused
sudo apt-get install -y debian-archive-keyring

# 2. Clean up from last time
sudo lb clean --all

# 3. Configure (The macOS/Deepin Formula)
lb config \
    --mode debian \
    --distribution bookworm \
    --archive-areas "main contrib non-free non-free-firmware" \
    --image-name "LemonzOS-v1" \
    --memtest none \
    --debian-installer false

# 4. Setup Folders
mkdir -p config/package-lists
mkdir -p config/includes.chroot/etc/gtk-3.0

# 5. Apps list (Keeping it light so it finishes faster)
cat <<EOF > config/package-lists/lemonz.list.chroot
live-boot
live-config
live-config-systemd
dde
firefox-esr
arc-theme
papirus-icon-theme
EOF

# 6. macOS UI Settings
cat <<EOF > config/includes.chroot/etc/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=Arc-Dark
gtk-icon-theme-name=Papirus-Dark
EOF

# 7. Start the Build
echo "🚀 Starting the big bake. This takes 15-20 minutes."
sudo lb build
