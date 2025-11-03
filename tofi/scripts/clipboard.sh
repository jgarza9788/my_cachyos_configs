#!/usr/bin/env bash
set -euo pipefail

# deps: cliphist, tofi, wl-copy

# Show history in Tofi, get the selected entry
selection="$(cliphist list | tofi -c ~/.config/tofi/themes/theme.conf --prompt 'Clipboard' 2>/dev/null || true)"

# If the user cancelled or nothing was chosen, exit quietly
[[ -z "${selection:-}" ]] && exit 0

# Decode the entry and copy it to the Wayland clipboard
printf '%s' "$selection" | cliphist decode | wl-copy
