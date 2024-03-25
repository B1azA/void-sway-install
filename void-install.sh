#!/bin/bash
# After install
# - microcode

echo "Install microcode and graphics"

# Update
xbps-install -Syu

# Install packages
xbps-install -S \
  socklog-void \
  cronie \
  chrony \
  NetworkManager \
  elogind \
  polkit \
  mesa-dri \
  wayland \
  sway \
  xdg-utils \
  xdg-user-dirs \
  xdg-desktop-portal-wlr

# Create services
ln -s /etc/sv/socklog-unix /var/service
ln -s /etc/sv/nanoklogd /var/service
ln -s /etc/sv/cronie /var/service
ln -s /etc/sv/chronyd /var/service
ln -s /etc/sv/NetworkManager /var/service
ln -s /etc/sv/seatd /var/service
ln -s /etc/sv/dbus /var/service

# Remove services
rm /var/service/dhcpcd
rm /var/service/wpa_supplicant

# Run services
sv up socklog-unix
sv up nanoklogd
sv up cronie
sv up chronyd
sv up NetworkManager
sv up seatd
sv up dbus

# Trimming for SSD
echo '#!/bin/sh
fstrim /' > /etc/cron.weekly/fstrim

chmod u+x /etc/cron.weekly/fstrim

echo "Reboot!!!"
