#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run with sudo!"
  exit
fi

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
  lxsession \
  mesa-dri \
  wayland \
  wlroots \
  sway \
  xdg-utils \
  xdg-user-dirs \
  xdg-desktop-portal-wlr \
  foot \
  dmenu \
  wmenu \
  noto-fonts-ttf \
  qt5-wayland \
  pipewire \
  bluez \
  libspa-bluetooth \
  blueman \
  wl-clipboard \
  grim \
  slurp

# Create services
ln -s /etc/sv/socklog-unix /var/service
ln -s /etc/sv/nanoklogd /var/service
ln -s /etc/sv/cronie /var/service
ln -s /etc/sv/chronyd /var/service
ln -s /etc/sv/NetworkManager /var/service
ln -s /etc/sv/dbus /var/service
ln -s /etc/sv/bluetoothd /var/service

# Remove services
rm /var/service/dhcpcd
rm /var/service/wpa_supplicant

echo "Enable periodic trimming for root directory (/)? Check which devices allow TRIM with: lsblk --discard."
select trim in Yes No; do
  echo $trim;
  case $trim in
    Yes)
      echo '#!/bin/sh
      fstrim /' > /etc/cron.weekly/fstrim
      break
      chmod u+x /etc/cron.weekly/fstrim
      ;;
    No)
      break
      ;;
    *)
      echo "Select 1 or 2."
    ;;
  esac
done

echo 'export QT_QPA_PLATFORM=wayland-eql
export ELM_DISPLAY=wl
export SDL_VIDEODRIVER=wayland
export MOZ_ENABLE_WAYLAND=1

# Start sway if TTY1
if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec sway
fi' >> /etc/profile

# Sway
mkdir /home/$SUDO_USER/.config
mkdir /home/$SUDO_USER/.config/sway
cp ./config /home/$SUDO_USER/.config/sway/
chown -R $SUDO_USER /home/$SUDO_USER/.config

# Audio
mkdir -p /etc/pipewire/pipewire.conf.d
ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/

# Bluetooth
usermod -a -G bluetooth $SUDO_USER

echo "Don't forget to install microcode and graphics!"
echo "Reboot now!!!"
