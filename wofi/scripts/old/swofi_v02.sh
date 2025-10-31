#!/usr/bin/env bash
set -euo pipefail

# ---- deps --------------------------------------------------------------
have(){ command -v "$1" >/dev/null 2>&1; }
need(){ for c in "$@"; do have "$c" || { echo "Missing: $c" >&2; exit 1; }; done; }

copy_clip(){ if have wl-copy; then printf "%s" "$1" | wl-copy; elif have xclip; then printf "%s" "$1" | xclip -selection clipboard; fi; }
confirm(){ printf "no\nyes" | wofi --dmenu --prompt "${1:-Are you sure?}" | grep -qx "yes"; }

# ---- websites ----------------------------------------------------------
web_entries(){ cat <<'EOF'
ChatGPT	chromium --app=https://chat.openai.com
YouTube	chromium --app=https://youtube.com
Reddit	chromium --app=https://reddit.com
GitHub	chromium --app=https://github.com
Gmail	chromium --app=https://mail.google.com
Google Drive	chromium --app=https://drive.google.com
Discord	chromium --app=https://discord.com/app
Spotify	chromium --app=https://open.spotify.com
Wikipedia	chromium --app=https://wikipedia.org
Amazon	chromium --app=https://amazon.com
EOF
}

# ---- system -------------------------------------------------------------
locker_cmd(){
  if   have hyprlock; then echo "hyprlock -f"
  elif have swaylock; then echo "swaylock -f"
  elif have i3lock;   then echo "i3lock"
  elif have dm-tool;  then echo "dm-tool lock"
  else echo "loginctl lock-session"
  fi
}
sys_entries(){
  local lock; lock="$(locker_cmd)"
  cat <<EOF
Lock	$lock
Sleep (suspend)	systemctl suspend
Hibernate	systemctl hibernate
Reboot	systemctl reboot
Shutdown	systemctl poweroff
Log out	loginctl terminate-user "$USER"
EOF
}

# ---- calculator ---------------------------------------------------------
calc_prompt(){
  local expr res
  expr=$(wofi --dmenu --prompt "Calc: 2*(5+3)")
  [[ -z "$expr" ]] && exit 0
  if have bc; then res="$(printf '%s\n' "$expr" | bc -l 2>/dev/null || true)"
  else res="(install 'bc' for evaluation)"; fi
  copy_clip "$res"
  notify-send "Result copied" "$expr = $res"
}

# ---- deps --------------------------------------------------------------
have(){ command -v "$1" >/dev/null 2>&1; }
need(){ for c in "$@"; do have "$c" || { echo "Missing: $c" >&2; exit 1; }; done; }

# ... keep the rest ...

# ---- windows (Sway / Hyprland / Niri) ----------------------------------

# Sway: flatten nodes + floating_nodes, pick leaf containers with a title
sway_windows(){
  swaymsg -t get_tree 2>/dev/null \
  | jq -r '
      def leaves:
        .. | objects
        | select(.nodes? or .floating_nodes?)
        | ( .nodes[]?, .floating_nodes[]? )* 
        | select(.type == "con" and (.nodes|length==0) and ((.name // .app_id) != null));

      leaves
      | . as $w
      | ($w.name // $w.app_id // "untitled") as $title
      | "🪟 \($title) [sway:\($w.id)]\t" + "swaymsg \"[con_id=\($w.id)]\" focus"
    ' || true
}

# Hyprland: list clients and focus by address
hypr_windows(){
  hyprctl clients -j 2>/dev/null \
  | jq -r '
      .[]?
      | .address as $addr
      | ((.title // .initialTitle // "untitled") + " — " + (.class // .initialClass // "unknown")) as $title
      | "🪟 \($title) [hypr:\($addr)]\t" + "hyprctl dispatch focuswindow address:\($addr)"
    ' || true
}

# Niri: try both JSON flags; try both focus syntaxes
niri_windows(){
  # grab windows JSON with either -j or --json
  local json
  if json="$(niri msg -j windows 2>/dev/null)"; then :
  elif json="$(niri msg --json windows 2>/dev/null)"; then :
  else
    return 0
  fi

  # render lines
  printf '%s' "$json" \
  | jq -r '
      .windows[]?
      | .id as $id
      | (.title // .app_id // "untitled") as $title
      | "🪟 \($title) [niri:\($id)]\t" + "niri msg action focus-window --id \($id)"
    ' \
  | while IFS=$'\t' read -r label cmd; do
      # fallback: older builds might require `niri msg focus-window --id`
      printf '%s\t%s\n' "$label" "$cmd"
      printf '%s\t%s\n' "$label" "$(printf '%s' "$cmd" | sed 's/action //' )"
    done
}

windows_entries(){
  # Emit from the compositor you’re actually running
  # (We don’t strictly need this detection; trying all works too.)
  local printed=0
  if have swaymsg && pgrep -x sway >/dev/null 2>&1; then sway_windows; printed=1; fi
  if have hyprctl && pgrep -x Hyprland >/dev/null 2>&1; then hypr_windows; printed=1; fi
  if have niri && pgrep -x niri >/dev/null 2>&1; then niri_windows; printed=1; fi

  # Fallback: try all if nothing matched by pgrep
  if [[ $printed -eq 0 ]]; then
    have swaymsg && sway_windows
    have hyprctl && hypr_windows
    have niri && niri_windows
  fi
}


# ---- combined flat list -------------------------------------------------
all_entries(){
  {
    windows_entries
    web_entries
    sys_entries
    echo "Calculator	calc"
    echo "Run Command	run"
  } | awk 'NF' | sort -f
}

# ---- main ---------------------------------------------------------------
main(){
  need wofi
  [[ -z "${WAYLAND_DISPLAY:-}" ]] && echo "Wofi expects Wayland." >&2

  local pick cmd
  pick="$(all_entries | cut -f1 | wofi --dmenu --prompt "Launch / Switch" --insensitive)"
  [[ -z "$pick" ]] && exit 0
  cmd="$(all_entries | awk -F'\t' -v k="$pick" '$1==k{print $2; exit}')"

  case "$cmd" in
    calc) calc_prompt ;;
    run)
      read -r run_cmd < <(wofi --dmenu --prompt "Run command")
      [[ -n "${run_cmd:-}" ]] && nohup bash -lc "$run_cmd" >/dev/null 2>&1 &
      ;;
    *poweroff|*reboot|*hibernate|*suspend|*terminate-user*)
      confirm "Confirm?" && nohup bash -lc "$cmd" >/dev/null 2>&1 &
      ;;
    *)
      [[ -n "$cmd" ]] && nohup bash -lc "$cmd" >/dev/null 2>&1 &
      ;;
  esac
}
main
