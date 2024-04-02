# Void install script

- Installs Void with Sway.
- Sets up audio (PipeWire), networking (NetwrokManager) and bluetooth…

## Notes

### In Sway config

- Don't forget to **run PipeWire**.
  ```
  exec pipewire
  ```
- **Set XDG_CURRENT_DESKTOP** for screensharing to work. **Run it before PipeWire!**
  ```
  exec dbus-update-activation-environment DISPLAY I3SOCK SWAYSOCK WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=$nameofcompositor
  ```
