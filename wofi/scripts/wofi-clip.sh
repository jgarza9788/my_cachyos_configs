#!/usr/bin/env bash
set -euo pipefail

# Requires: cliphist, wl-clipboard, wofi
# Optional for auto-paste: wtype

AUTO=true
METHOD="type"   # or: ctrlv

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --auto) AUTO=true; shift ;;
    --method) METHOD="${2:-type}"; shift 2 ;;
    -h|--help)
      cat <<EOF
Usage: $(basename "$0") [--auto] [--method type|ctrlv]

--auto             After selecting, paste automatically.
--method type      Type the text (default).
--method ctrlv     Send Ctrl+V chord (works for images/text in GUI apps).
EOF
      exit 0
      ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

# Pick an entry from history
choice="$(cliphist list | wofi --dmenu -i -p 'Clipboard' -W 60% -H 60% || true)"
[[ -n "${choice}" ]] || exit 0

# Restore selection to clipboard (handles text/images)
cliphist decode <<< "$choice" | wl-copy

# Done if no auto-paste requested
$AUTO || exit 0

# Auto-paste:
if ! command -v wtype >/dev/null 2>&1; then
  # Notify if available, but don't fail hard
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "wofi-clip" "Auto-paste requested, but 'wtype' is not installed."
  else
    echo "Auto-paste requested, but 'wtype' is not installed." >&2
  fi
  exit 1
fi

# Heuristic: if clipboard has text, type it; else Ctrl+V (good for images)
if [[ "$METHOD" == "type" ]]; then
  if wl-paste --no-newline --type text >/dev/null 2>&1; then
    wl-paste --type text | wtype -
  else
    # Fallback to Ctrl+V if text extraction fails
    wtype -M ctrl v -m ctrl
  fi
elif [[ "$METHOD" == "ctrlv" ]]; then
  wtype -M ctrl v -m ctrl
else
  echo "Unknown --method '${METHOD}'" >&2
  exit 2
fi
