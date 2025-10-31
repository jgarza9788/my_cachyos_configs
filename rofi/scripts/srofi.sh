#!/usr/bin/env bash
set -euo pipefail

# --- Utilities ---------------------------------------------------------------
have() { command -v "$1" >/dev/null 2>&1; }

copy_clip() {
  # Copy to Wayland or X clipboard if available
  if have wl-copy; then printf "%s" "$1" | wl-copy
  elif have xclip; then printf "%s" "$1" | xclip -selection clipboard
  fi
}

confirm() {
  local prompt="${1:-Are you sure?}"
  rofi -dmenu -p "$prompt [yes/no]" <<< "no"$'\n'"yes"
}

# --- Websites (keeps your list) ----------------------------------------------
web_entries() {
  # Label<TAB>Command
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

print_rows() {
  # Emit in script-modi format: "label\0info\x1f<command>"
  while IFS=$'\t' read -r label cmd; do
    [[ -z "$label" ]] && continue
    echo -e "${label}\0info\x1f${cmd}"
  done
}

# --- System commands ----------------------------------------------------------
locker_cmd() {
  if have hyprlock; then echo "hyprlock"
  elif have swaylock; then echo "swaylock -f"
  elif have i3lock; then echo "i3lock"
  elif have dm-tool; then echo "dm-tool lock"
  else echo "loginctl lock-session"
  fi
}

sys_entries() {
  local lock="$(locker_cmd)"
  cat <<EOF
 Lock	$lock
󰜉 Reboot	~/.config/niri/scripts/power.sh --reboot
󰜉 Restart	~/.config/niri/scripts/power.sh --reboot
󰐥 Shutdown	~/.config/niri/scripts/power.sh --poweroff
󰍃 Logout	~/.config/niri/scripts/power.sh --logout
EOF
}

sys_mode() {

  case "${ROFI_RETV:-0}" in
    0) sys_entries | print_rows; exit 0 ;;
    1)
      if [[ -n "${ROFI_INFO:-}" ]]; then
        # Confirm destructive actions
        # case "$ROFI_INFO" in
        #   *poweroff|*reboot|*hibernate|*suspend|*terminate-user*)
        #     if [[ "$(confirm "Confirm")" != "yes" ]]; then exit 0; fi
        #   ;;
        # esac
        nohup bash -lc "$ROFI_INFO" >/dev/null 2>&1 &
      fi
      exit 0
      ;;
    *) exit 0 ;;
  esac
}

# --- Quick calculator (works even without rofi-calc) --------------------------
qcalc_mode() {
  case "${ROFI_RETV:-0}" in
    0)
      # Instructions row (non-selectable)
      echo -e "Type an expression and press Enter (e.g. 2*(5+3))\0nonselectable\x1ftrue"
      # History hint (optional)
      exit 0
      ;;
    2)
      # Custom text entered by user on stdin
      expr="$(cat || true)"
      expr="${expr//[^-+*/().0-9^% eE] /}"  # keep it simple
      [[ -z "$expr" ]] && exit 0
      if have bc; then
        res="$(printf '%s\n' "$expr" | bc -l 2>/dev/null || true)"
      else
        res="(install 'bc' for evaluation)"
      fi
      # Show a row with the result, selecting it will copy to clipboard
      echo -e "$expr = $res\0info\x1fcopy:$res"
      exit 0
      ;;
    1)
      # Selection of the result row -> copy
      if [[ "${ROFI_INFO:-}" == copy:* ]]; then
        copy_clip "${ROFI_INFO#copy:}"
      fi
      exit 0
      ;;
    *) exit 0 ;;
  esac
}

# --- Websites mode dispatcher -------------------------------------------------
web_mode() {
  case "${ROFI_RETV:-0}" in
    0) web_entries | print_rows; exit 0 ;;
    1)
      if [[ -n "${ROFI_INFO:-}" ]]; then
        nohup bash -lc "$ROFI_INFO" >/dev/null 2>&1 &
      fi
      exit 0
      ;;
    *) exit 0 ;;
  esac
}


# --- History (fish, bash, zsh) ----------------------------------------------
HIST_LIMIT="${HIST_LIMIT:-2000}"   # total cap after merge/dedupe

KEEP_TERM_OPEN=1
# KEEP_TERM_OPEN=1  → keeps the terminal open after running the command
# KEEP_TERM_OPEN=0  → terminal closes when the command finishes
KEEP_TERM_OPEN="${KEEP_TERM_OPEN:-1}"

open_term() {
  local shell="$1" cmd="$2"
  # pick a terminal
  if command -v kitty >/dev/null;        then term=(kitty -e)
  elif   command -v alacritty >/dev/null;    then term=(alacritty -e)
  elif command -v footclient >/dev/null;   then term=(footclient -e)
  elif command -v gnome-terminal >/dev/null; then term=(gnome-terminal -- bash -lc)
  elif command -v konsole >/dev/null;      then term=(konsole -e)
  else term=(xterm -e)
  fi

  # choose behavior
  if [[ "$KEEP_TERM_OPEN" -eq 1 ]]; then
    case "$shell" in
      fish) nohup "${term[@]}" fish -ic "$cmd; and fish" >/dev/null 2>&1 & ;;
      bash) nohup "${term[@]}" bash -ic "$cmd; exec bash" >/dev/null 2>&1 & ;;
      zsh)  nohup "${term[@]}" zsh  -ic "$cmd; exec zsh"  >/dev/null 2>&1 & ;;
      *)    nohup "${term[@]}" bash -ic "$cmd; exec bash" >/dev/null 2>&1 & ;;
    esac
  else
    case "$shell" in
      fish) nohup "${term[@]}" fish -lc "$cmd" >/dev/null 2>&1 & ;;
      bash) nohup "${term[@]}" bash -lc "$cmd" >/dev/null 2>&1 & ;;
      zsh)  nohup "${term[@]}" zsh  -lc "$cmd"  >/dev/null 2>&1 & ;;
      *)    nohup "${term[@]}" bash -lc "$cmd" >/dev/null 2>&1 & ;;
    esac
  fi
}

hist_fish() {
  local f="$HOME/.local/share/fish/fish_history"
  [[ -r "$f" ]] || return 0
  # extract "- cmd: ..." lines; keep order newest->oldest by scanning backwards
  tac "$f" | awk '
    $1=="-"{ if ($2=="cmd:") { sub(/^- cmd: /,""); print } }
  ' | awk 'NF' | sed 's/^[[:space:]]\+//' | sed 's/[[:space:]]\+$//' \
  | awk 'seen[$0]++==0 {print}' \
  | head -n "$HIST_LIMIT" \
  | while IFS= read -r cmd; do
      printf "[fish] %s\0info\x1frun:fish:%s\n" "$cmd" "$cmd"
    done
}

hist_bash() {
  local f="$HOME/.bash_history"
  [[ -r "$f" ]] || return 0
  # drop lines like #1697050000 (timestamps), then dedupe
  awk 'BEGIN{prevts=0} /^#/ {next} {print}' "$f" \
  | awk 'NF' | sed 's/^[[:space:]]\+//' | sed 's/[[:space:]]\+$//' \
  | tac | awk 'seen[$0]++==0 {print}' \
  | head -n "$HIST_LIMIT" \
  | while IFS= read -r cmd; do
      printf "[bash] %s\0info\x1frun:bash:%s\n" "$cmd" "$cmd"
    done
}

hist_zsh() {
  local f="$HOME/.zsh_history"
  [[ -r "$f" ]] || return 0
  # format: ": 1697048793:0;ls -la"
  awk -F';' '{
    if ($0 ~ /^: [0-9]+:[0-9]+;/) {
      sub(/^: [0-9]+:[0-9]+;/,""); print
    } else { print $0 }
  }' "$f" \
  | awk 'NF' | sed 's/^[[:space:]]\+//' | sed 's/[[:space:]]\+$//' \
  | tac | awk 'seen[$0]++==0 {print}' \
  | head -n "$HIST_LIMIT" \
  | while IFS= read -r cmd; do
      printf "[zsh] %s\0info\x1frun:zsh:%s\n" "$cmd" "$cmd"
    done
}

history_entries() {
  # Merge: prefer newest (we reversed some streams with tac)
  { hist_fish; hist_zsh; hist_bash; } \
  | awk -v RS='\n' -F '\0' '1' \
  | awk -F'\0' 'seen[$0]++==0' \
  | head -n "$HIST_LIMIT"
}

history_mode() {
  case "${ROFI_RETV:-0}" in
    0) history_entries; exit 0 ;;
    1)
      if [[ -n "${ROFI_INFO:-}" ]]; then
        # ROFI_INFO = run:<shell>:<cmd...>
        IFS=: read -r _prefix shell rest <<<"${ROFI_INFO}"
        # The rest may contain colons; reconstruct the command safely:
        local cmd="${ROFI_INFO#run:${shell}:}"
        open_term "$shell" "$cmd"
      fi
      exit 0
      ;;
    2) exit 0 ;; # custom input ignored here
    *) exit 0 ;;
  esac
}



# --- Entry point for script-modi ---------------------------------------------
if [[ "${1:-}" == "--web"   ]]; then web_mode; fi
if [[ "${1:-}" == "--sys"   ]]; then sys_mode; fi
if [[ "${1:-}" == "--qcalc" ]]; then qcalc_mode; fi
# if [[ "${1:-}" == "--files" ]]; then file_mode; fi


# --- Build and launch Rofi ----------------------------------------------------
SCRIPT_PATH="$(readlink -f "$0")"

# Optional: include rofi-calc plugin if present
#MODI_CORE="window,drun,run"
MODI_CORE="window,drun"
MODI_WEB="web:${SCRIPT_PATH} --web"
MODI_SYS="sys:${SCRIPT_PATH} --sys"
MODI_HIST="history:${SCRIPT_PATH} --history"

# MODI_QCALC="qcalc:${SCRIPT_PATH} --qcalc"
# MODI_FILES="files:${SCRIPT_PATH} --files"



# If rofi-calc is installed, add native 'calc' mode to the combi too
if have rofi && rofi -help 2>/dev/null | grep -q '\bcalc\b'; then

  MODI="${MODI_CORE},${MODI_WEB},${MODI_HIST},${MODI_SYS}"
  # COMBI="window,drun,run,web,sys,history"
  COMBI="window,drun,web,history,sys"

else
  # MODI="${MODI_CORE},${MODI_WEB},${MODI_SYS},${MODI_QCALC}"
  # COMBI="window,drun,run,web,sys,qcalc"

  # MODI="${MODI_CORE},${MODI_WEB},${MODI_FILES},${MODI_SYS},${MODI_QCALC}"
  # COMBI="window,drun,run,web,files,sys,qcalc"
  
  MODI="${MODI_CORE},${MODI_WEB},${MODI_HIST},${MODI_SYS}"
  # COMBI="window,drun,run,web,sys,history"
  COMBI="window,drun,web,history,sys"
fi


# History mode entry point
if [[ "${1:-}" == "--history" ]]; then history_mode; fi




# exec rofi \
#   -sort \
#   -sorting-method "levenshtein" \
#   -modi "${MODI}" \
#   -combi-modi "${COMBI}" \
#   -show combi

exec rofi \
  -sort \
  -sorting-method "fzf" \
  -modi "${MODI}" \
  -combi-modi "${COMBI}" \
  -show combi 