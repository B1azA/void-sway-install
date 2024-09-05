# Void BTRFS manual installation

## Better shell

- /bin/bash

## Keyboard layout

- loadkeys cz-qwertz

## Partitioning

- cfdisk /dev/sdX
  - GPT label

### BIOS

- 1MB BIOS Boot

### UEFI

- 1GB EFI System

## Filesystem

### BIOS

- mkfs.btrfs /dev/sdXm

### EFI

- mkfs.vfat /dev/sdXn
- mkfs.btrfs /dev/sdXm

## Subvolumes

- mount /dev/sdXm /mnt
- btrfs su cr /mnt/@
- btrfs su cr /mnt/@home
- umount /mnt

## Mounting

- mount -o noatime,compress=lzo,space_cache=v2,subvol=@ /dev/sdXm /mnt
- mkdir /mnt/home
- mount -o noatime,compress=lzo,space_cache=v2,subvol=@home /dev/sdXm /mnt/home

### EFI

- mkdir -p /mnt/boot/efi
- mount /dev/sdX1 /mnt/boot/efi

## Install system

- REPO=https://repo-default.voidlinux.org/current
- ARCH=x86_64
- mkdir -p /mnt/var/db/xbps/keys
- cp /var/db/xbps/keys/\* /mnt/var/db/xbps/keys/
- XBPS_ARCH=$ARCH xbps-install -S -r /mnt -R "$REPO" base-system

## Chroot

- xchroot /mnt /bin/bash
- xbps-install -Su
- xbps-install neovim
- change hostname (/etc/hostname)
- ln -s /usr/share/zoninfo/Europe/Prague /etc/localtime
- uncomment locale (/etc/default/libc-locales)
- xbps-reconfigure -f glibc-locales
- keymap (/etc/rc.conf)

## Password and user

- passwd
- useradd username
- usermod -aG wheel username
- uncoment wheel (visudo)
- passwd username

## Fstab

- cp /proc/mounts /etc/fstab
- delete all extra mountings (leave only /dev/sdXx) in /etc/fstab
- change last column value to 1 (root /dev/sdXm)
- change last column value to 2 for others
- change names for UUIDs (when using multiple discs)
  - use blkid to find UUID of a disc
  - /dev/sdc2 -> UUID=88e242u842s8283…
- add "tmpfs /tmp tmpfs defaults,nosuid,nodev 0 0"

## GRUB

### EFI

- xbps-install grub-x86_64-efi
- grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id="Void"

### BIOS

- xbps-install grub
- grub-install /dev/sdX

- xbps-reconfigure -fa
- exit
- umount -R /mnt
- shutdown -r now

## Post install

- sudo ln -s /etc/sv/dhcpcd /var/service
- install timeshift
  - timeshift-gtk
- install and setup grub-btrfs and grub-btrfs-runit
