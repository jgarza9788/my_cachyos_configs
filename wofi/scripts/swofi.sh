#!/usr/bin/env bash
set -euo pipefail

# ===== Config =====
HISTORY_LIMIT="${HISTORY_LIMIT:-300}"
APPS_LIMIT="${APPS_LIMIT:-1500}"
WEBS_LIMIT="${WEBS_LIMIT:-999}"
WOFI_FLAGS=${WOFI_FLAGS:-"--dmenu --prompt Launch --insensitive"}




# ===== Utils =====
need(){ for c in "$@"; do command -v "$c" >/dev/null || { echo "Missing: $c" >&2; exit 1; }; done; }
emit(){ printf "%s\t%s\n" "$1" "$2"; }
run_bg(){ setsid -f sh -lc "$1" >/dev/null 2>&1 || true; }

# ===== Niri windows (array root) =====
niri_windows(){
  local json
  json="$(niri msg -j windows 2>/dev/null || niri msg --json windows 2>/dev/null || true)"
  [ -n "$json" ] || return 0
#   printf '%s' "$json" | jq -r '
#     .[]? | .id as $id | (.title // .app_id // "untitled") as $t
#     | ("  " + $t + " (id:" + ($id|tostring) + ")") + "\t" + ("niri msg action focus-window --id " + ($id|tostring))
#   ' 2>/dev/null || true

  printf '%s' "$json" | jq -r '
    .[]? |
    .id as $id |
    (.app_id // "???" ) as $appid |
    ($appid + (" " * (20 - ( ($appid | length) | if . < 0 then 0 else . end))) | .[0:20]) as $padded_app |
    (.title // "untitled") as $t |
    ("  " + $padded_app + " " + $t + " (id:" + ($id|tostring) + ")") + "\t" + ("niri msg action focus-window --id " + ($id|tostring))
  ' 2>/dev/null || true
  
}

# ===== Websites =====
websites(){ cat <<'EOF'
ChatGPT	chromium --app=https://chat.openai.com
YouTube	chromium --app=https://youtube.com
Reddit	chromium --app=https://reddit.com
Plex	chromium --app=https://app.plex.tv
Netflix	chromium --app=https://netflix.com
Amazon	chromium --app=https://amazon.com
Gmail	chromium --app=https://mail.google.com
Google Drive	chromium --app=https://drive.google.com
Google Maps	chromium --app=https://maps.google.com
Google Photos	chromium --app=https://photos.google.com
Google News	chromium --app=https://news.google.com
Google Calendar	chromium --app=https://calendar.google.com
Facebook	chromium --app=https://facebook.com
Messenger	chromium --app=https://messenger.com
Instagram	chromium --app=https://instagram.com
Threads	chromium --app=https://threads.net
TikTok	chromium --app=https://tiktok.com
Twitter (X)	chromium --app=https://x.com
Discord	chromium --app=https://discord.com/app
Spotify	chromium --app=https://open.spotify.com
SoundCloud	chromium --app=https://soundcloud.com
Twitch	chromium --app=https://twitch.tv
Kick	chromium --app=https://kick.com
Steam	chromium --app=https://store.steampowered.com
Epic Games	chromium --app=https://store.epicgames.com
Humble Bundle	chromium --app=https://humblebundle.com
Itch.io	chromium --app=https://itch.io
GitHub	chromium --app=https://github.com
GitLab	chromium --app=https://gitlab.com
Bitbucket	chromium --app=https://bitbucket.org
Stack Overflow	chromium --app=https://stackoverflow.com
Dev.to	chromium --app=https://dev.to
Hacker News	chromium --app=https://news.ycombinator.com
Product Hunt	chromium --app=https://producthunt.com
LinkedIn	chromium --app=https://linkedin.com
Indeed	chromium --app=https://indeed.com
Glassdoor	chromium --app=https://glassdoor.com
Upwork	chromium --app=https://upwork.com
Fiverr	chromium --app=https://fiverr.com
Etsy	chromium --app=https://etsy.com
eBay	chromium --app=https://ebay.com
Walmart	chromium --app=https://walmart.com
Best Buy	chromium --app=https://bestbuy.com
Target	chromium --app=https://target.com
Home Depot	chromium --app=https://homedepot.com
Lowe's	chromium --app=https://lowes.com
IKEA	chromium --app=https://ikea.com
Wayfair	chromium --app=https://wayfair.com
AliExpress	chromium --app=https://aliexpress.com
Shein	chromium --app=https://shein.com
Temu	chromium --app=https://temu.com
Pinterest	chromium --app=https://pinterest.com
Canva	chromium --app=https://canva.com
Notion	chromium --app=https://notion.so
Trello	chromium --app=https://trello.com
Asana	chromium --app=https://asana.com
ClickUp	chromium --app=https://clickup.com
Todoist	chromium --app=https://todoist.com
Dropbox	chromium --app=https://dropbox.com
OneDrive	chromium --app=https://onedrive.live.com
Outlook	chromium --app=https://outlook.com
Zoom	chromium --app=https://zoom.us
Google Meet	chromium --app=https://meet.google.com
Microsoft Teams	chromium --app=https://teams.microsoft.com
Slack	chromium --app=https://slack.com
OpenAI Playground	chromium --app=https://platform.openai.com/playground
Claude AI	chromium --app=https://claude.ai
Perplexity AI	chromium --app=https://perplexity.ai
Gemini (Google AI)	chromium --app=https://gemini.google.com
Deepl Translate	chromium --app=https://deepl.com
Reverso	chromium --app=https://reverso.net
Wolfram Alpha	chromium --app=https://wolframalpha.com
Wikipedia	chromium --app=https://wikipedia.org
Archive.org	chromium --app=https://archive.org
IMDb	chromium --app=https://imdb.com
Rotten Tomatoes	chromium --app=https://rottentomatoes.com
Letterboxd	chromium --app=https://letterboxd.com
Tubi	chromium --app=https://tubitv.com
Crackle	chromium --app=https://crackle.com
Peacock	chromium --app=https://peacocktv.com
Disney+	chromium --app=https://disneyplus.com
HBO Max	chromium --app=https://max.com
Paramount+	chromium --app=https://paramountplus.com
Hulu	chromium --app=https://hulu.com
Apple TV+	chromium --app=https://tv.apple.com
Vimeo	chromium --app=https://vimeo.com
Bandcamp	chromium --app=https://bandcamp.com
Last.fm	chromium --app=https://last.fm
NYTimes	chromium --app=https://nytimes.com
Washington Post	chromium --app=https://washingtonpost.com
BBC News	chromium --app=https://bbc.com/news
Reuters	chromium --app=https://reuters.com
CNN	chromium --app=https://cnn.com
The Guardian	chromium --app=https://theguardian.com
NPR	chromium --app=https://npr.org
Bloomberg	chromium --app=https://bloomberg.com
Forbes	chromium --app=https://forbes.com
TechCrunch	chromium --app=https://techcrunch.com
Ars Technica	chromium --app=https://arstechnica.com
The Verge	chromium --app=https://theverge.com
Engadget	chromium --app=https://engadget.com
Tom's Hardware	chromium --app=https://tomshardware.com
PC Gamer	chromium --app=https://pcgamer.com
IGN	chromium --app=https://ign.com
Polygon	chromium --app=https://polygon.com
Gamespot	chromium --app=https://gamespot.com
Kotaku	chromium --app=https://kotaku.com
Weather.com	chromium --app=https://weather.com
AccuWeather	chromium --app=https://accuweather.com
FlightRadar24	chromium --app=https://flightradar24.com
Speedtest	chromium --app=https://speedtest.net
DuckDuckGo	chromium --app=https://duckduckgo.com
Bing	chromium --app=https://bing.com
Yahoo	chromium --app=https://yahoo.com
ProtonMail	chromium --app=https://proton.me
Bitwarden	chromium --app=https://vault.bitwarden.com
1Password	chromium --app=https://1password.com
EOF
}
web_entries(){ websites | head -n "$WEBS_LIMIT" | while IFS=$'\t' read -r name cmd; do [ -n "$name" ] && emit "󰖟  $name" "$cmd"; done; }

# ===== Applications (gtk-launch) =====
app_dirs=("$HOME/.local/share/applications" "/usr/local/share/applications" "/usr/share/applications")
app_entries(){
  local list
  if command -v fd >/dev/null; then
    list="$(fd -t f -a '\.desktop$' "${app_dirs[@]}" 2>/dev/null | head -n "$APPS_LIMIT" || true)"
  else
    list="$(find "${app_dirs[@]}" -type f -name '*.desktop' 2>/dev/null | head -n "$APPS_LIMIT" || true)"
  fi
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    grep -qE '^NoDisplay=true' "$f" && continue
    local id name
    id="$(basename "$f")"
    name="$(grep -m1 '^Name=' "$f" | sed 's/^Name=//')"
    [ -z "${name:-}" ] && name="${id%.desktop}"
    emit "  $name" "gtk-launch $(printf '%q' "$id")"
  done <<<"$list"
}

# ===== System =====
locker_cmd(){
  command -v hyprlock >/dev/null && { echo "hyprlock -f"; return; }
  command -v swaylock  >/dev/null && { echo "swaylock -f"; return; }
  command -v i3lock    >/dev/null && { echo "i3lock"; return; }
  command -v dm-tool   >/dev/null && { echo "dm-tool lock"; return; }
  echo "loginctl lock-session"
}
sys_entries(){
  emit "  Lock"        "$(locker_cmd)"
  emit "  Sleep"       "systemctl suspend"
  emit "  Reboot"      "systemctl reboot"
  emit "  Power Off"   "systemctl poweroff"
  emit "  Log out"     "loginctl terminate-user \"$USER\""
}

# ===== History =====
# hist_bash(){ [ -f "$HOME/.bash_history" ] && tac "$HOME/.bash_history" || true; }
# hist_zsh(){  [ -f "$HOME/.zsh_history"  ] && tac "$HOME/.zsh_history"  | sed -E 's/^: [0-9]+:[0-9]+;//' || true; }
# hist_fish(){
#   local f="$HOME/.local/share/fish/fish_history"
#   [ -f "$f" ] || return 0
#   awk -F': ' '/^\s*cmd: /{print $2}' "$f" | tac || true
# }
# hist_entries(){
#   {
#     hist_bash
#     hist_zsh
#     hist_fish
#   } | awk 'NF' | awk '!seen[$0]++' | head -n "$HISTORY_LIMIT" \
#     | while IFS= read -r cmd; do emit "󱆃 $cmd" "bash -lc $(printf '%q' "$cmd")"; done
# }

# ===== Main =====
main(){
  need wofi jq niri
  local tmp pick cmd
  tmp="$(mktemp)"
  {
    niri_windows
    app_entries
    web_entries
    sys_entries
    printf '%s\t%s\n' "  Calculator" "calc"
    printf '%s\t%s\n' "  Run command..." "run"
    # hist_entries
  } | sed '/^\s*$/d' > "$tmp"

  pick="$(cut -f1 "$tmp" | wofi $WOFI_FLAGS || true)"
  [ -z "${pick:-}" ] && { rm -f "$tmp"; exit 0; }
  cmd="$(awk -F'\t' -v k="$pick" '$1==k{print $2; exit}' "$tmp" || true)"
  rm -f "$tmp"
  [ -z "${cmd:-}" ] && exit 0

  case "$cmd" in
    calc)
      expr="$(wofi $WOFI_FLAGS --prompt "Calc: 2*(5+3)" || true)"
      [ -z "${expr:-}" ] && exit 0
      if command -v bc >/dev/null; then res="$(printf '%s\n' "$expr" | bc -l 2>/dev/null || true)"; else res="(install bc)"; fi
      command -v wl-copy >/dev/null && printf '%s' "$res" | wl-copy
      exit 0
      ;;
    run)
      run_cmd="$(wofi $WOFI_FLAGS --prompt "Run command" || true)"
      [ -n "${run_cmd:-}" ] && run_bg "$run_cmd"
      exit 0
      ;;
    *poweroff|*reboot|*hibernate|*suspend|*terminate-user*)
      ok="$(printf "no\nyes\n" | wofi --dmenu --prompt 'Confirm?' || true)"
      [ "$ok" = "yes" ] && run_bg "$cmd"
      exit 0
      ;;
  esac

  # Niri focus: try multiple variants for compatibility
  case "$cmd" in
    niri\ msg\ action\ focus-window\ --id\ *|niri\ msg\ focus-window\ --id\ *|\
    niri\ msg\ action\ focus-window\ --window-id\ *|niri\ msg\ focus-window\ --window-id\ *|\
    niri\ msg\ action\ activate-window\ --id\ *|niri\ msg\ activate-window\ --id\ *)
      run_bg "$cmd" \
      || run_bg "${cmd/action /}" \
      || run_bg "$(printf '%s' "$cmd" | sed 's/ --id / --window-id /')" \
      || exit 0
      exit 0
      ;;
  esac

  run_bg "$cmd"
}
main
