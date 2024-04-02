# Void install script

- installs Void with Sway
- sets up audio (PipeWire), networking (NetwrokManager) and bluetooth…

## Notes

### In Sway config

- don't forget to **run PipeWire**
  ```
  exec pipewire
  ```
- **set XDG_CURRENT_DESKTOP** for screensharing to work
  ```
  exec dbus-update-activation-environment DISPLAY I3SOCK SWAYSOCK WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=$nameofcompositor
  ```
