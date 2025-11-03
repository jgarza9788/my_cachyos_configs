#!/usr/bin/env bash
set -euo pipefail

# --- Utilities ---------------------------------------------------------------
have() { command -v "$1" >/dev/null 2>&1; }

copy_clip() {
  if have wl-copy; then printf "%s" "$1" | wl-copy
  elif have xclip; then printf "%s" "$1" | xclip -selection clipboard
  fi
}

confirm() {
  local prompt="${1:-Are you sure?}"
  printf "no\nyes" | tofi --prompt "$prompt [yes/no]" | grep -qx "yes"
}

# --- Websites ----------------------------------------------------------------
web_entries() {
  cat <<'EOF'
ChatGPT	chromium --app=https://chat.openai.com
YouTube	chromium --app=https://youtube.com
Reddit	chromium --app=https://reddit.com
Plex	chromium --app=https://app.plex.tv
Netflix	chromium --app=https://netflix.com
GitHub	chromium --app=https://github.com
Gmail	chromium --app=https://mail.google.com
Google Drive	chromium --app=https://drive.google.com
EOF
}

web_mode() {
  local choice
  choice="$(web_entries | awk -F'\t' '{print $1}' | tofi --prompt "🌐 Web App >")" || exit 0
  [ -z "$choice" ] && exit 0
  local cmd
  cmd="$(web_entries | grep -F "$choice" | cut -f2-)"
  nohup bash -lc "$cmd" >/dev/null 2>&1 &
}

# --- System ------------------------------------------------------------------
sys_entries() {
  cat <<EOF
 Lock	loginctl lock-session
󰜉 Reboot	systemctl reboot
󰐥 Shutdown	systemctl poweroff
󰍃 Logout	niri msg action quit -s
EOF
}

sys_mode() {
  local choice cmd
  choice="$(sys_entries | awk -F'\t' '{print $1}' | tofi --prompt "⚙ System >")" || exit 0
  [ -z "$choice" ] && exit 0
  cmd="$(sys_entries | grep -F "$choice" | cut -f2-)"
  confirm "$choice" && nohup bash -lc "$cmd" >/dev/null 2>&1 &
}

# --- Calculator --------------------------------------------------------------
qcalc_mode() {
  local expr res
  expr="$(tofi --prompt "🧮 calc >")" || exit 0
  [ -z "$expr" ] && exit 0
  if have bc; then
    res="$(printf '%s\n' "$expr" | bc -l 2>/dev/null || true)"
  else
    res="(install 'bc' for evaluation)"
  fi
  printf "%s = %s" "$expr" "$res" | tofi --prompt "Result (Enter=copy)" >/dev/null
  copy_clip "$res"
}

# --- Shell History -----------------------------------------------------------
HIST_LIMIT="${HIST_LIMIT:-1000}"

hist_fish() {
  local f="$HOME/.local/share/fish/fish_history"
  [[ -r "$f" ]] || return
  tac "$f" | awk '$2=="cmd:"{sub(/^- cmd: /,"");print}' \
    | awk 'seen[$0]++==0' | head -n "$HIST_LIMIT"
}

hist_bash() {
  local f="$HOME/.bash_history"
  [[ -r "$f" ]] || return
  awk '!/^#/' "$f" | tac | awk 'seen[$0]++==0' | head -n "$HIST_LIMIT"
}

hist_zsh() {
  local f="$HOME/.zsh_history"
  [[ -r "$f" ]] || return
  awk -F';' '{if($0~/^: [0-9]+:[0-9]+;/){sub(/^: [0-9]+:[0-9]+;/,"");print}else{print}}' "$f" \
    | tac | awk 'seen[$0]++==0' | head -n "$HIST_LIMIT"
}

history_mode() {
  local entries choice
  entries="$( (hist_fish; hist_bash; hist_zsh) | awk 'NF' )"
  choice="$(printf "%s\n" "$entries" | tofi --prompt "💻 Run >")" || exit 0
  [ -z "$choice" ] && exit 0
  nohup bash -lc "$choice" >/dev/null 2>&1 &
}

# --- Main Menu ---------------------------------------------------------------
main_menu() {
  cat <<EOF
window
drun
web
history
sys
calc
EOF
}

mode="$(main_menu | tofi --prompt "🚀 Launcher >")" || exit 0

case "$mode" in
  web) web_mode ;;
  history) history_mode ;;
  sys) sys_mode ;;
  calc) qcalc_mode ;;
  window) tofi-drun --show window ;;
  drun) tofi-drun --show drun ;;
  *) exit 0 ;;
esac
