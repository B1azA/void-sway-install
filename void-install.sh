#!/bin/bash
# After install
# - microcode

echo "Install microcode and graphics"

# Update
xbps-install -Syu

# Install packages
xbps-install -S socklog-void cronie chrony NetworkManager seatd mesa-dri wayland sway xorg-utils xorg-user-dirs xorg-desktop-portal-wlr

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
echo -e "#!/bin/sh
fstrim /" > /etc/cron.weekly/fstrim

chmod u+x /etc/cron.weekly/fstrim

# Set XDG_RUNTIME_DIR (/etc/profile)
echo -e "if [[ "$(tty)" == "/dev/tty1" ]]; then
  if test -z "${XDG_RUNTIME_DIR}"; then
    export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
    if ! test -d "${XDG_RUNTIME_DIR}"; then
      mkdir "${XDG_RUNTIME_DIR}"
      chmod 0700 "${XDG_RUNTIME_DIR}"
    fi
  fi
fi" > /etc/profile

echo "Reboot!!!"
