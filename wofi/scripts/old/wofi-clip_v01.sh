#!/usr/bin/env bash
# Show history, pick one in wofi, restore it to clipboard (text/images both work)

choice="$(cliphist list | wofi --dmenu -p 'Clipboard')"
[ -n "$choice" ] || exit 0

# Put the selected item back on the clipboard (handles text and images)
cliphist decode <<< "$choice" | wl-copy

# OPTIONAL: automatically “paste” it into the focused window
# Uncomment the next line if you installed wtype and want auto-paste:
# wl-paste | wtype -
