#!/usr/bin/env bash
set -euo pipefail

# --- Utilities ---------------------------------------------------------------
have() { command -v "$1" >/dev/null 2>&1; }

copy_clip() {
  if have wl-copy; then printf "%s" "$1" | wl-copy
  elif have xclip; then printf "%s" "$1" | xclip -selection clipboard
  fi
}

# Confirm prompt using wofi
confirm() {
  local prompt="${1:-Are you sure?}"
  local choice
  choice=$(printf "no\nyes" | wofi --dmenu --prompt "$prompt")
  [[ "$choice" == "yes" ]]
}

# --- Websites ---------------------------------------------------------------
web_entries() {
  cat <<'EOF'
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

open_website() {
  local entry cmd
  entry=$(web_entries | cut -f1 | wofi --dmenu --prompt "Open Website")
  [[ -z "$entry" ]] && exit 0
  cmd=$(web_entries | grep -F "$entry" | cut -f2)
  nohup bash -lc "$cmd" >/dev/null 2>&1 &
}

# --- System commands --------------------------------------------------------
locker_cmd() {
  if have hyprlock; then echo "hyprlock -f"
  elif have swaylock; then echo "swaylock -f"
  elif have i3lock; then echo "i3lock"
  elif have dm-tool; then echo "dm-tool lock"
  else echo "loginctl lock-session"
  fi
}

sys_menu() {
  local options="Lock\nSleep (suspend)\nHibernate\nReboot\nShutdown\nLog out"
  local choice
  choice=$(printf "$options" | wofi --dmenu --prompt "System Action")
  case "$choice" in
    "Lock") eval "$(locker_cmd)" ;;
    "Sleep (suspend)") systemctl suspend ;;
    "Hibernate") systemctl hibernate ;;
    "Reboot") confirm "Reboot?" && systemctl reboot ;;
    "Shutdown") confirm "Power off?" && systemctl poweroff ;;
    "Log out") confirm "Log out?" && loginctl terminate-user "$USER" ;;
    *) exit 0 ;;
  esac
}

# --- Calculator -------------------------------------------------------------
calc_menu() {
  local expr res
  expr=$(wofi --dmenu --prompt "Calculator" --allow-markup --hide-scroll)
  [[ -z "$expr" ]] && exit 0
  if have bc; then
    res="$(printf '%s\n' "$expr" | bc -l 2>/dev/null || true)"
  else
    res="(install 'bc' for evaluation)"
  fi
  copy_clip "$res"
  notify-send "Result copied" "$expr = $res"
}

# # --- Main menu --------------------------------------------------------------
# main_menu() {
#   local options="Run Command\nOpen Website\nSystem Actions\nCalculator"
#   local choice
#   choice=$(printf "$options" | wofi --dmenu --prompt "Launcher")

#   case "$choice" in
#     "Run Command")
#       local cmd
#       cmd=$(wofi --dmenu --prompt "Run Command")
#       [[ -n "$cmd" ]] && nohup bash -lc "$cmd" >/dev/null 2>&1 &
#       ;;
#     "Open Website") open_website ;;
#     "System Actions") sys_menu ;;
#     "Calculator") calc_menu ;;
#     *) exit 0 ;;
#   esac
# }

# main_menu



# ---- windows (Sway / Hyprland / Niri) ----------------------------------
sway_windows(){
  # label<TAB>command
  swaymsg -t get_tree \
  | jq -r '
    # flatten nodes & floating_nodes, pick leaves with a name
    (.. | objects | select(has("nodes")) ) as $root
    | $root
    | [recurse(.nodes[]? + .floating_nodes[]?)] 
    | .[]
    | select(.type == "con" and (.nodes|length==0) and (.name or .app_id))
    | . as $w
    | ( $w.name // $w.app_id // "untitled") as $title
    | ( ( ($w | path(..|select(.type?=="workspace")))[0] // empty ) ) as $ws
    | "🪟 \($title) [sway:\($w.id)]\t"swaymsg \"[con_id=\($w.id)]\" focus
  ' 2>/dev/null || true
}

hypr_windows(){
  hyprctl clients -j 2>/dev/null \
  | jq -r '
    .[] 
    | .address as $addr
    | ((.title // .initialTitle // "untitled") + " — " + (.class // .initialClass // "unknown")) as $title
    | "🪟 \($title) [hypr:\($addr)]\t" + "hyprctl dispatch focuswindow address:\($addr)"
  ' || true
}

niri_windows(){
  # niri >= 0.1.9: `niri msg windows` (use -j for JSON); focus via --id
  niri msg -j windows 2>/dev/null \
  | jq -r '
    .windows[]
    | .id as $id
    | (.title // .app_id // "untitled") as $title
    | "🪟 \($title) [niri:\($id)]\t" + "niri msg action focus-window --id \($id)"
  ' || true
}

windows_entries(){
  if have swaymsg && have jq; then sway_windows; fi
  if have hyprctl && have jq; then hypr_windows; fi
  if have niri && have jq;     then niri_windows; fi
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

# --- Main flat menu ----------------------------------------------------------
main_flat() {
  local entry cmd
  entry=$(all_entries | cut -f1 | wofi --dmenu --prompt "Launcher" --insensitive)
  [[ -z "$entry" ]] && exit 0
  cmd=$(all_entries | grep -F "$entry" | cut -f2-)

  case "$cmd" in
    calc) calc_entry ;;
    run)
      local run_cmd
      run_cmd=$(wofi --dmenu --prompt "Run Command")
      [[ -n "$run_cmd" ]] && nohup bash -lc "$run_cmd" >/dev/null 2>&1 &
      ;;
    *poweroff|*reboot|*hibernate|*suspend|*terminate-user*)
      if confirm "Confirm?"; then nohup bash -lc "$cmd" >/dev/null 2>&1 & fi
      ;;
    *)
      [[ -n "$cmd" ]] && nohup bash -lc "$cmd" >/dev/null 2>&1 &
      ;;
  esac
}

main_flat