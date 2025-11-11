#!/bin/bash

# 1) Export important vars to the user bus
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE

# 2) Bounce the portal services so they inherit the right env
systemctl --user stop xdg-desktop-portal{,-wlr,-gtk,-gnome,-kde}.service 2>/dev/null
# (the services you don't have will just warn)

# 3) Start the main portal in verbose mode to verify
/usr/lib/xdg-desktop-portal -rv

