#!/usr/bin/env bash
set -euo pipefail

# --- types -------------------------------------------------------------------
win="󰣆"
web="󰖟"
app="󱓻"
hist="󰋚"
sys="󰐥"



# --- utils -------------------------------------------------------------------
have(){ command -v "$1" >/dev/null 2>&1; }
copy_clip(){ have wl-copy && printf "%s" "$1" | wl-copy || true; }


# KEEP_TERM_OPEN=1  → keeps the terminal open after running the command
# KEEP_TERM_OPEN=0  → terminal closes when the command finishes
KEEP_TERM_OPEN=1
KEEP_TERM_OPEN="${KEEP_TERM_OPEN:-1}"


open_term() {
  local cmd="${1:-}" shell="${2:-}" 
  local term=()

  # pick a terminal
  if have kitty; then term=(kitty -e)
  elif have alacritty; then term=(alacritty -e)
  elif have footclient; then term=(footclient -e)
  elif have wezterm; then term=(wezterm start --)
  elif have tilix; then term=(tilix -e)
  elif have gnome-terminal; then term=(gnome-terminal --)    # pass shell after --
  elif have konsole; then term=(konsole -e)
  else term=(xterm -e)
  fi

  # default shell: current login shell or bash
  if [[ -z "$shell" ]]; then
    shell="$(basename "${SHELL:-bash}")"
  fi

  # normalize common paths like /bin/bash → bash
  case "$shell" in
    */* ) shell="$(basename "$shell")" ;;
  esac

  echo "cmd: $cmd"
  echo "shell: $shell"
  echo "term: $term"


  # run with correct flags per shell and keep-open behavior
  if [[ "${KEEP_TERM_OPEN:-1}" -eq 1 ]]; then
    case "$shell" in
      fish) nohup "${term[@]}" fish -ic "$cmd; and fish" >/dev/null 2>&1 & ;;
      zsh)  nohup "${term[@]}" zsh  -ic "$cmd; exec zsh"  >/dev/null 2>&1 & ;;
      bash|*) nohup "${term[@]}" bash -ic "$cmd; exec bash" >/dev/null 2>&1 & ;;
    esac
  else
    case "$shell" in
      fish) nohup "${term[@]}" fish -lc "$cmd" >/dev/null 2>&1 & ;;
      zsh)  nohup "${term[@]}" zsh  -lc "$cmd" >/dev/null 2>&1 & ;;
      bash|*) nohup "${term[@]}" bash -lc "$cmd" >/dev/null 2>&1 & ;;
    esac
  fi
}


# --- WEB ---------------------------------------------------------------------
web_entries() {
  cat <<'EOF'
[web] ChatGPT	chromium --app=https://chat.openai.com
[web] YouTube	chromium --app=https://youtube.com
[web] Reddit	chromium --app=https://reddit.com
[web] Plex	chromium --app=https://app.plex.tv
[web] Netflix	chromium --app=https://netflix.com
[web] Amazon	chromium --app=https://amazon.com
[web] Gmail	chromium --app=https://mail.google.com
[web] Google Drive	chromium --app=https://drive.google.com
[web] Google Maps	chromium --app=https://maps.google.com
[web] Google Photos	chromium --app=https://photos.google.com
[web] Google News	chromium --app=https://news.google.com
[web] Google Calendar	chromium --app=https://calendar.google.com
[web] Facebook	chromium --app=https://facebook.com
[web] Messenger	chromium --app=https://messenger.com
[web] Instagram	chromium --app=https://instagram.com
[web] Threads	chromium --app=https://threads.net
[web] TikTok	chromium --app=https://tiktok.com
[web] Twitter (X)	chromium --app=https://x.com
[web] Discord	chromium --app=https://discord.com/app
[web] Spotify	chromium --app=https://open.spotify.com
[web] SoundCloud	chromium --app=https://soundcloud.com
[web] Twitch	chromium --app=https://twitch.tv
[web] Kick	chromium --app=https://kick.com
[web] Steam	chromium --app=https://store.steampowered.com
[web] Epic Games	chromium --app=https://store.epicgames.com
[web] Humble Bundle	chromium --app=https://humblebundle.com
[web] Itch.io	chromium --app=https://itch.io
[web] GitHub	chromium --app=https://github.com
[web] GitLab	chromium --app=https://gitlab.com
[web] Bitbucket	chromium --app=https://bitbucket.org
[web] Stack Overflow	chromium --app=https://stackoverflow.com
[web] Dev.to	chromium --app=https://dev.to
[web] Hacker News	chromium --app=https://news.ycombinator.com
[web] Product Hunt	chromium --app=https://producthunt.com
[web] LinkedIn	chromium --app=https://linkedin.com
[web] Indeed	chromium --app=https://indeed.com
[web] Glassdoor	chromium --app=https://glassdoor.com
[web] Upwork	chromium --app=https://upwork.com
[web] Fiverr	chromium --app=https://fiverr.com
[web] Etsy	chromium --app=https://etsy.com
[web] eBay	chromium --app=https://ebay.com
[web] Walmart	chromium --app=https://walmart.com
[web] Best Buy	chromium --app=https://bestbuy.com
[web] Target	chromium --app=https://target.com
[web] Home Depot	chromium --app=https://homedepot.com
[web] Lowe's	chromium --app=https://lowes.com
[web] IKEA	chromium --app=https://ikea.com
[web] Wayfair	chromium --app=https://wayfair.com
[web] AliExpress	chromium --app=https://aliexpress.com
[web] Shein	chromium --app=https://shein.com
[web] Temu	chromium --app=https://temu.com
[web] Pinterest	chromium --app=https://pinterest.com
[web] Canva	chromium --app=https://canva.com
[web] Notion	chromium --app=https://notion.so
[web] Trello	chromium --app=https://trello.com
[web] Asana	chromium --app=https://asana.com
[web] ClickUp	chromium --app=https://clickup.com
[web] Todoist	chromium --app=https://todoist.com
[web] Dropbox	chromium --app=https://dropbox.com
[web] OneDrive	chromium --app=https://onedrive.live.com
[web] Outlook	chromium --app=https://outlook.com
[web] Zoom	chromium --app=https://zoom.us
[web] Google Meet	chromium --app=https://meet.google.com
[web] Microsoft Teams	chromium --app=https://teams.microsoft.com
[web] Slack	chromium --app=https://slack.com
[web] OpenAI Playground	chromium --app=https://platform.openai.com/playground
[web] Claude AI	chromium --app=https://claude.ai
[web] Perplexity AI	chromium --app=https://perplexity.ai
[web] Gemini (Google AI)	chromium --app=https://gemini.google.com
[web] Deepl Translate	chromium --app=https://deepl.com
[web] Reverso	chromium --app=https://reverso.net
[web] Wolfram Alpha	chromium --app=https://wolframalpha.com
[web] Wikipedia	chromium --app=https://wikipedia.org
[web] Archive.org	chromium --app=https://archive.org
[web] IMDb	chromium --app=https://imdb.com
[web] Rotten Tomatoes	chromium --app=https://rottentomatoes.com
[web] Letterboxd	chromium --app=https://letterboxd.com
[web] Tubi	chromium --app=https://tubitv.com
[web] Crackle	chromium --app=https://crackle.com
[web] Peacock	chromium --app=https://peacocktv.com
[web] Disney+	chromium --app=https://disneyplus.com
[web] HBO Max	chromium --app=https://max.com
[web] Paramount+	chromium --app=https://paramountplus.com
[web] Hulu	chromium --app=https://hulu.com
[web] Apple TV+	chromium --app=https://tv.apple.com
[web] Vimeo	chromium --app=https://vimeo.com
[web] Bandcamp	chromium --app=https://bandcamp.com
[web] Last.fm	chromium --app=https://last.fm
[web] NYTimes	chromium --app=https://nytimes.com
[web] Washington Post	chromium --app=https://washingtonpost.com
[web] BBC News	chromium --app=https://bbc.com/news
[web] Reuters	chromium --app=https://reuters.com
[web] CNN	chromium --app=https://cnn.com
[web] The Guardian	chromium --app=https://theguardian.com
[web] NPR	chromium --app=https://npr.org
[web] Bloomberg	chromium --app=https://bloomberg.com
[web] Forbes	chromium --app=https://forbes.com
[web] TechCrunch	chromium --app=https://techcrunch.com
[web] Ars Technica	chromium --app=https://arstechnica.com
[web] The Verge	chromium --app=https://theverge.com
[web] Engadget	chromium --app=https://engadget.com
[web] Tom's Hardware	chromium --app=https://tomshardware.com
[web] PC Gamer	chromium --app=https://pcgamer.com
[web] IGN	chromium --app=https://ign.com
[web] Polygon	chromium --app=https://polygon.com
[web] Gamespot	chromium --app=https://gamespot.com
[web] Kotaku	chromium --app=https://kotaku.com
[web] Weather.com	chromium --app=https://weather.com
[web] AccuWeather	chromium --app=https://accuweather.com
[web] FlightRadar24	chromium --app=https://flightradar24.com
[web] Speedtest	chromium --app=https://speedtest.net
[web] DuckDuckGo	chromium --app=https://duckduckgo.com
[web] Bing	chromium --app=https://bing.com
[web] Yahoo	chromium --app=https://yahoo.com
[web] ProtonMail	chromium --app=https://proton.me
[web] Bitwarden	chromium --app=https://vault.bitwarden.com
[web] 1Password	chromium --app=https://1password.com
EOF
}

# --- SYSTEM ------------------------------------------------------------------
sys_entries() {
  cat <<'EOF'
[sys] Lock	loginctl lock-session
[sys] Reboot	systemctl reboot
[sys] Shutdown	systemctl poweroff
[sys] Logout	niri msg action quit -s
EOF
}

# --- HISTORY -----------------------------------------------------------------
HIST_LIMIT="${HIST_LIMIT:-1000}"

hist_fish() {
  local f="$HOME/.local/share/fish/fish_history"
  [[ -r "$f" ]] || return
  tac "$f" | awk '$2=="cmd:"{sub(/^- cmd: /,"");print}' \
    | awk 'NF && !seen[$0]++' | head -n "$HIST_LIMIT" \
    | sed 's/^/[hist] /'
}
hist_bash() {
  local f="$HOME/.bash_history"
  [[ -r "$f" ]] || return
  awk '!/^#/' "$f" | tac | awk 'NF && !seen[$0]++' | head -n "$HIST_LIMIT" \
    | sed 's/^/[hist] /'
}
hist_zsh() {
  local f="$HOME/.zsh_history"
  [[ -r "$f" ]] || return
  awk -F';' '{if($0~/^: [0-9]+:[0-9]+;/){sub(/^: [0-9]+:[0-9]+;/,"");print}else{print}}' "$f" \
    | tac | awk 'NF && !seen[$0]++' | head -n "$HIST_LIMIT" \
    | sed 's/^/[hist] /'
}

history_entries() {
  { hist_fish; hist_zsh; hist_bash; } | awk 'NF && !seen[$0]++'
}

# --- APPS (.desktop) ---------------------------------------------------------
# Parses Name and Exec (first non-localized Name, ignores Terminal=true nuance).
desktop_dirs=(
  "$HOME/.local/share/applications"
  "/usr/local/share/applications"
  "/usr/share/applications"
)

apps_entries() {
  # Output format: "[app] <Name>\t<Exec>"
  for dir in "${desktop_dirs[@]}"; do
    [[ -d "$dir" ]] || continue
    while IFS= read -r -d '' file; do
      # Pull first Name= and Exec= (ignore localized Name[xx]=)
      name="$(grep -m1 -E '^Name=' "$file" | sed 's/^Name=//')"
      exec_line="$(grep -m1 -E '^Exec=' "$file" | sed 's/^Exec=//')"
      [[ -n "${name:-}" && -n "${exec_line:-}" ]] || continue
      # Strip field codes like %U %u %F %f etc.
      exec_line="$(printf '%s' "$exec_line" | sed -E 's/ *%[fFuUdDnNickvm]//g')"
      # Skip desktop helpers that cannot run
      printf "[app] %s\t%s\n" "$name" "$exec_line"
    done < <(find "$dir" -maxdepth 1 -type f -name '*.desktop' -print0 2>/dev/null)
  done | awk -F'\t' '!seen[$1]++'  # de-dup by name
}

# --- BUILD FLAT LIST ---------------------------------------------------------
build_list() {
  {
    apps_entries
    web_entries
    sys_entries
    # turn shell history lines into "<label>\t<command>"
    history_entries | awk '{print $0"\t"substr($0, index($0,$3)) }'
  } | awk 'NF'
}

# --- RUN ---------------------------------------------------------------------
main() {
  # Show just labels (left of TAB) to tofi; keep full line for lookup
  all="$(build_list)"
  label="$(printf "%s\n" "$all" | awk -F'\t' '{print $1}' | tofi --prompt "▶" )" || exit 0
  [[ -z "$label" ]] && exit 0

  line="$(printf "%s\n" "$all" | grep -F -m1 "$label" || true)"
  [[ -z "$line" ]] && exit 0

  # echo $line

  # If it's a history item, execute in terminal; else run command directly
  # cmd="$(printf "%s" "$line" | awk -F'\t' '{print $2}')"

  # echo $label
  # echo $line
  # echo $cmd

  # cmd="$(echo "$label" | sed 's/^\[[^]]*\] *//')"

  # echo $label
  # echo $cmd

  read -r type label cmd <<<"$(
    echo "$line" | awk -F'[][]| ' '{printf "%s %s ", $2, $4; $1=$2=$3=$4=""; print substr($0, index($0,$5))}'
  )"


  if [[ "$label" == "[hist]"* ]]; then
    open_term "$cmd"

  elif [[ "$label" == "[web]"* ]]; then
    open_term "$cmd"

  elif [[ "$label" == "[sys]"* ]]; then
    # Optional confirm for destructive actions:
    case "$cmd" in
      *poweroff|*reboot) printf "no\nyes" | tofi --prompt "Confirm $label ?" | grep -qx yes || exit 0 ;;
    esac
    nohup bash -lc "$cmd" >/dev/null 2>&1 &
  else
    nohup bash -lc "$cmd" >/dev/null 2>&1 &
  fi
}


main

