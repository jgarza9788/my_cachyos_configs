# fzfLauncher

`fzfLauncher` is a fuzzy launcher script for Linux / Wayland (with first-class Niri support).  
It lets you drive almost everything from one fzf menu:

- 🪟 Switch between **Niri windows**
- 🧩 Launch **apps** (.desktop + flatpak)
- 🕒 Search **shell history** (fish / zsh / bash)
- 🌐 Open **web shortcuts** in app mode
- 📋 Browse and re-copy **clipboard history**
- ⚙️ Run **system commands** (lock, reboot, shutdown, logout)
- ⭐ Run your own **custom commands**

The UI is driven by `fzf` and everything is just `label<TAB>command` under the hood.

---

## Support
[Buy Me ☕](https://buymeacoffee.com/jgarza97885)  
... or just support one of the other projects below.


---

## Requirements

* Bash 
	* (script uses `bash` features + `set -euo pipefail`)
* [`fzf`](https://github.com/junegunn/fzf)
* For Niri integration:
  * [`niri`](https://github.com/YaLTeR/niri`)
  * Optional: `jq` for JSON IPC (falls back to `awk` if missing)
* For app launching:
  * Standard `.desktop` directories:
    `~/.local/share/applications`, `/usr/share/applications`, `/var/lib/snapd/desktop/applications`
  * Optional: `flatpak` for Flatpak app entries
* For clipboard integration:
  * Preferred: `cliphist` + `wl-copy`
  * Or: `wl-paste-history`
  * Or (no history): `xclip`
* For system actions:
  * One or more of: `hyprlock`, `swaylock`, `i3lock`, `dm-tool`, `loginctl`
* A terminal emulator: `kitty`, `alacritty`, `footclient`, `gnome-terminal`, `konsole`, or `xterm`

### 🔤 Recommended: Install a Nerd Font

`fzfLauncher` uses many glyph icons (apps, windows, history, clipboard, system icons).  
To ensure the UI looks correct inside your terminal, **a Nerd Font is strongly recommended**.

Best choices:

- **JetBrainsMono Nerd Font** (recommended)
- FiraCode Nerd Font
- Caskaydia Cove (Cascadia Code) Nerd Font
- Hack Nerd Font

Download: https://www.nerdfonts.com/font-downloads

If icons appear as empty squares, your terminal is not using a Nerd Font.

---

## Installation

1. Put the script somewhere in your `$PATH`, e.g.:

   ```bash
   mkdir -p "$HOME/.local/bin"
   cp fzfLauncher.sh "$HOME/.local/bin/fzfLauncher"
   chmod +x "$HOME/.local/bin/fzfLauncher"
   ```


