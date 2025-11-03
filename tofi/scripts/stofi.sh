# --- glyph type tags ---------------------------------------------------------
# Make sure you have a Nerd Font set in tofi (or change these to your taste)
G_NIRI=" "     # windows
G_WEB="󰖟 "      # web links
G_APP=" "      # apps (pick any icon you like) 
G_HIST="󰋚 "     # history
G_SYS=" "      # system
# an extra spaces has been added to these... we will have to adjust later



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
  cat <<EOF
$G_WEB ChatGPT	chromium --app=https://chat.openai.com
$G_WEB YouTube	chromium --app=https://youtube.com
$G_WEB Reddit	chromium --app=https://reddit.com
$G_WEB Plex	chromium --app=https://app.plex.tv
$G_WEB Netflix	chromium --app=https://netflix.com
$G_WEB Amazon	chromium --app=https://amazon.com
$G_WEB Gmail	chromium --app=https://mail.google.com
$G_WEB Google Drive	chromium --app=https://drive.google.com
$G_WEB Google Maps	chromium --app=https://maps.google.com
$G_WEB Google Photos	chromium --app=https://photos.google.com
$G_WEB Google News	chromium --app=https://news.google.com
$G_WEB Google Calendar	chromium --app=https://calendar.google.com
$G_WEB Facebook	chromium --app=https://facebook.com
$G_WEB Messenger	chromium --app=https://messenger.com
$G_WEB Instagram	chromium --app=https://instagram.com
$G_WEB Threads	chromium --app=https://threads.net
$G_WEB TikTok	chromium --app=https://tiktok.com
$G_WEB Twitter (X)	chromium --app=https://x.com
$G_WEB Discord	chromium --app=https://discord.com/app
$G_WEB Spotify	chromium --app=https://open.spotify.com
$G_WEB SoundCloud	chromium --app=https://soundcloud.com
$G_WEB Twitch	chromium --app=https://twitch.tv
$G_WEB Kick	chromium --app=https://kick.com
$G_WEB Steam	chromium --app=https://store.steampowered.com
$G_WEB Epic Games	chromium --app=https://store.epicgames.com
$G_WEB Humble Bundle	chromium --app=https://humblebundle.com
$G_WEB Itch.io	chromium --app=https://itch.io
$G_WEB GitHub	chromium --app=https://github.com
$G_WEB GitLab	chromium --app=https://gitlab.com
$G_WEB Bitbucket	chromium --app=https://bitbucket.org
$G_WEB Stack Overflow	chromium --app=https://stackoverflow.com
$G_WEB Dev.to	chromium --app=https://dev.to
$G_WEB Hacker News	chromium --app=https://news.ycombinator.com
$G_WEB Product Hunt	chromium --app=https://producthunt.com
$G_WEB LinkedIn	chromium --app=https://linkedin.com
$G_WEB Indeed	chromium --app=https://indeed.com
$G_WEB Glassdoor	chromium --app=https://glassdoor.com
$G_WEB Upwork	chromium --app=https://upwork.com
$G_WEB Fiverr	chromium --app=https://fiverr.com
$G_WEB Etsy	chromium --app=https://etsy.com
$G_WEB eBay	chromium --app=https://ebay.com
$G_WEB Walmart	chromium --app=https://walmart.com
$G_WEB Best Buy	chromium --app=https://bestbuy.com
$G_WEB Target	chromium --app=https://target.com
$G_WEB Home Depot	chromium --app=https://homedepot.com
$G_WEB Lowe's	chromium --app=https://lowes.com
$G_WEB IKEA	chromium --app=https://ikea.com
$G_WEB Wayfair	chromium --app=https://wayfair.com
$G_WEB AliExpress	chromium --app=https://aliexpress.com
$G_WEB Shein	chromium --app=https://shein.com
$G_WEB Temu	chromium --app=https://temu.com
$G_WEB Pinterest	chromium --app=https://pinterest.com
$G_WEB Canva	chromium --app=https://canva.com
$G_WEB Notion	chromium --app=https://notion.so
$G_WEB Trello	chromium --app=https://trello.com
$G_WEB Asana	chromium --app=https://asana.com
$G_WEB ClickUp	chromium --app=https://clickup.com
$G_WEB Todoist	chromium --app=https://todoist.com
$G_WEB Dropbox	chromium --app=https://dropbox.com
$G_WEB OneDrive	chromium --app=https://onedrive.live.com
$G_WEB Outlook	chromium --app=https://outlook.com
$G_WEB Zoom	chromium --app=https://zoom.us
$G_WEB Google Meet	chromium --app=https://meet.google.com
$G_WEB Microsoft Teams	chromium --app=https://teams.microsoft.com
$G_WEB Slack	chromium --app=https://slack.com
$G_WEB OpenAI Playground	chromium --app=https://platform.openai.com/playground
$G_WEB Claude AI	chromium --app=https://claude.ai
$G_WEB Perplexity AI	chromium --app=https://perplexity.ai
$G_WEB Gemini (Google AI)	chromium --app=https://gemini.google.com
$G_WEB Deepl Translate	chromium --app=https://deepl.com
$G_WEB Reverso	chromium --app=https://reverso.net
$G_WEB Wolfram Alpha	chromium --app=https://wolframalpha.com
$G_WEB Wikipedia	chromium --app=https://wikipedia.org
$G_WEB Archive.org	chromium --app=https://archive.org
$G_WEB IMDb	chromium --app=https://imdb.com
$G_WEB Rotten Tomatoes	chromium --app=https://rottentomatoes.com
$G_WEB Letterboxd	chromium --app=https://letterboxd.com
$G_WEB Tubi	chromium --app=https://tubitv.com
$G_WEB Crackle	chromium --app=https://crackle.com
$G_WEB Peacock	chromium --app=https://peacocktv.com
$G_WEB Disney+	chromium --app=https://disneyplus.com
$G_WEB HBO Max	chromium --app=https://max.com
$G_WEB Paramount+	chromium --app=https://paramountplus.com
$G_WEB Hulu	chromium --app=https://hulu.com
$G_WEB Apple TV+	chromium --app=https://tv.apple.com
$G_WEB Vimeo	chromium --app=https://vimeo.com
$G_WEB Bandcamp	chromium --app=https://bandcamp.com
$G_WEB Last.fm	chromium --app=https://last.fm
$G_WEB NYTimes	chromium --app=https://nytimes.com
$G_WEB Washington Post	chromium --app=https://washingtonpost.com
$G_WEB BBC News	chromium --app=https://bbc.com/news
$G_WEB Reuters	chromium --app=https://reuters.com
$G_WEB CNN	chromium --app=https://cnn.com
$G_WEB The Guardian	chromium --app=https://theguardian.com
$G_WEB NPR	chromium --app=https://npr.org
$G_WEB Bloomberg	chromium --app=https://bloomberg.com
$G_WEB Forbes	chromium --app=https://forbes.com
$G_WEB TechCrunch	chromium --app=https://techcrunch.com
$G_WEB Ars Technica	chromium --app=https://arstechnica.com
$G_WEB The Verge	chromium --app=https://theverge.com
$G_WEB Engadget	chromium --app=https://engadget.com
$G_WEB Tom's Hardware	chromium --app=https://tomshardware.com
$G_WEB PC Gamer	chromium --app=https://pcgamer.com
$G_WEB IGN	chromium --app=https://ign.com
$G_WEB Polygon	chromium --app=https://polygon.com
$G_WEB Gamespot	chromium --app=https://gamespot.com
$G_WEB Kotaku	chromium --app=https://kotaku.com
$G_WEB Weather.com	chromium --app=https://weather.com
$G_WEB AccuWeather	chromium --app=https://accuweather.com
$G_WEB FlightRadar24	chromium --app=https://flightradar24.com
$G_WEB Speedtest	chromium --app=https://speedtest.net
$G_WEB DuckDuckGo	chromium --app=https://duckduckgo.com
$G_WEB Bing	chromium --app=https://bing.com
$G_WEB Yahoo	chromium --app=https://yahoo.com
$G_WEB ProtonMail	chromium --app=https://proton.me
$G_WEB Bitwarden	chromium --app=https://vault.bitwarden.com
$G_WEB 1Password	chromium --app=https://1password.com
EOF
  # ...continue your list by replacing "[web] " with "$G_WEB "
}




# --- SYSTEM ------------------------------------------------------------------
sys_entries() {
  cat <<EOF
$G_SYS Lock	loginctl lock-session
$G_SYS Reboot	systemctl reboot
$G_SYS Shutdown	systemctl poweroff
$G_SYS Logout	niri msg action quit -s
EOF
}

# --- APPS (.desktop) ---------------------------------------------------------
# desktop_dirs=(
#   "$HOME/.local/share/applications"
#   "/usr/local/share/applications"
#   "/usr/share/applications"
# )
# apps_entries() {
#   # Output: "<glyph> <Name>\t<Exec>"
#   for dir in "${desktop_dirs[@]}"; do
#     [[ -d "$dir" ]] || continue
#     while IFS= read -r -d '' file; do
#       name="$(grep -m1 -E '^Name=' "$file" | sed 's/^Name=//')"
#       exec_line="$(grep -m1 -E '^Exec=' "$file" | sed 's/^Exec=//')"
#       [[ -n "${name:-}" && -n "${exec_line:-}" ]] || continue
#       exec_line="$(printf '%s' "$exec_line" | sed -E 's/ *%[fFuUdDnNickvm]//g')"
#       printf "%s %s\t%s\n" "$G_APP" "$name" "$exec_line"
#     done < <(find "$dir" -maxdepth 1 -type f -name '*.desktop' -print0 2>/dev/null)
#   done | awk -F'\t' '!seen[$1]++'
# }

# app_cache="~/.config/tofi/app_cache.txt"

# set_app_cache()
# {
#   for dir in "${desktop_dirs[@]}"; do
#     [[ -d "$dir" ]] || continue
#     while IFS= read -r -d '' file; do
#        name="$(grep -m1 -E '^Name=' "$file" | sed 's/^Name=//')"
#       #  echo $name
#       name="$(grep -m1 -E '^Name=' "$file" | sed 's/^Name=//')"
#       exec_line="$(grep -m1 -E '^Exec=' "$file" | sed 's/^Exec=//')"
#       [[ -n "${name:-}" && -n "${exec_line:-}" ]] || continue
#       exec_line="$(printf '%s' "$exec_line" | sed -E 's/ *%[fFuUdDnNickvm]//g')"
#       printf "%s %s\t%s\n" "$G_APP" "$name" "$exec_line"
#     done < <(find "$dir" -maxdepth 1 -type f -name '*.desktop' -print0 2>/dev/null)
#   done | awk -F'\t' '!seen[$1]++'

# }
# set_app_cache;

# app_cache="$HOME/.config/tofi/app_cache.txt"

# apps_entries() {
#   if [[ -f "$app_cache" ]]; then
#     # Read file contents into an array, split by newline
#   #   mapfile -t lines < "$app_cache"

#   #   # Print each line
#   #   for line in "${lines[@]}"; do
#   #     echo $line
#   #     printf '%s' "$line"
#   #   done
#   # else
#   #   echo "⚠️ Missing app cache: $app_cache" >&2
#   # fi

#   { mapfile -t lines < "$app_cache" } \ 
#   | while IFS= read -r line; do
#     printf "%s" "$line"
#   done

#   fi

# }


app_cache="$HOME/.config/tofi/app_cache.txt"

apps_entries() {
  # if [[ -f "$app_cache" ]]; then
  #   while IFS= read -r line; do
  #     printf '%s\n' "$line"
  #   done < "$app_cache"
  # else
  #   echo "⚠️ Missing app cache: $app_cache" >&2
  # fi

  cat $app_cache
}



# --- HISTORY -----------------------------------------------------------------
HIST_LIMIT="${HIST_LIMIT:-1000}"

hist_fish() { local f="$HOME/.local/share/fish/fish_history"; [[ -r "$f" ]] || return
  tac "$f" | awk '$2=="cmd:"{sub(/^- cmd: /,"");print}' | awk 'NF && !seen[$0]++' | head -n "$HIST_LIMIT"; }
hist_bash() { local f="$HOME/.bash_history"; [[ -r "$f" ]] || return
  awk '!/^#/' "$f" | tac | awk 'NF && !seen[$0]++' | head -n "$HIST_LIMIT"; }
hist_zsh()  { local f="$HOME/.zsh_history"; [[ -r "$f" ]] || return
  awk -F';' '{if($0~/^: [0-9]+:[0-9]+;/){sub(/^: [0-9]+:[0-9]+;/,"");print}else{print}}' \
  | tac | awk 'NF && !seen[$0]++' | head -n "$HIST_LIMIT"; }

history_entries() {
  # we only need the fish one
  #{ hist_fish; hist_zsh; hist_bash; } \
  { hist_fish; } \
  | while IFS= read -r cmd; do
      printf "%s %s\t%s\n" "$G_HIST" "$cmd" "$cmd"
    done
}

# --- NIRI WINDOWS ------------------------------------------------------------
# needs: niri + jq
win_entries() {
  if ! command -v niri >/dev/null || ! command -v jq >/dev/null; then return; fi
  niri msg -j windows 2>/dev/null \
    | jq -r '.[] | "\(.id)\t\(.title // "untitled")\t\(.app_id // "")"' \
    | while IFS=$'\t' read -r wid wtitle wappid; do
        label="$G_NIRI ${wtitle}"
        cmd="niri msg action focus-window --id ${wid}"
        printf "%s\t%s\n" "$label" "$cmd"
      done
}

# --- BUILD FLAT LIST ---------------------------------------------------------
build_list() {
  {
    win_entries
    apps_entries
    web_entries
    sys_entries
    history_entries
  } | awk 'NF'
}

# --- RUN ---------------------------------------------------------------------
main() {

  epoch1=$(date +%s%3N)

  all="$(build_list)"

  epoch2=$(date +%s%3N)
  diff=$((epoch2 - epoch1))
  echo $diff


  choice="$(printf "%s\n" "$all" | awk -F'\t' '{print $1}' | tofi -c ~/.config/tofi/themes/theme.conf --prompt "▶")"  || exit 0

  [[ -z "$choice" ]] && exit 0

  line="$(printf "%s\n" "$all" | grep -F -m1 "$choice" || true)"; [[ -z "$line" ]] && exit 0
  
  
  read -r type label cmd <<<"$line"
  type="$type " #adding that extra space 
  cmd="${line//$choice}"

  # echo "choice: $choice"
  echo "line: $line"
  # echo "label: $label"
  # echo "type: $type"
  # echo "label: $label"
  echo "cmd: $cmd"

  case "$type" in
    "$G_HIST")
      # history commands: run in terminal (uses your open_term wrapper)
      open_term "$cmd"
      ;;
    "$G_SYS")
      case "$cmd" in
        *poweroff|*reboot)
          printf "no\nyes" | tofi -c ~/.config/tofi/themes/theme.conf --prompt "Confirm ${label_text} ?" | grep -qx yes || exit 0 ;;
      esac
      nohup bash -lc "$cmd" >/dev/null 2>&1 &
      ;;
    "$G_NIRI"|"$G_APP"|"$G_WEB"|*)
      nohup bash -lc "$cmd" >/dev/null 2>&1 &
      ;;
  esac
}
main
