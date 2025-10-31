#!/bin/bash

#cliphist list | wofi --show dmenu | cliphist decode | wl-copy

# rofi (Wayland build works too)
cliphist list | rofi -dmenu -i -p "Clipboard" | cliphist decode | wl-copy
