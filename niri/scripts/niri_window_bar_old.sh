#!/usr/bin/env bash
set -o pipefail

# Tokens (override in Waybar exec env)
ACTIVE_TOKEN="${NWB_ACTIVE:-[X]}"
INACTIVE_TOKEN="${NWB_INACTIVE:-[O]}"
SEPARATOR="${NWB_SEP:-}"
EMPTY_TEXT="${NWB_EMPTY:-}"

get() { niri msg -j "$1" 2>/dev/null || niri msg --json "$1" 2>/dev/null || true; }
emit() {
  jq -nc --arg text "$1" --arg tooltip "$2" --argjson count "${3:-0}" --argjson idx "${4:-0}" \
    '{text:$text, tooltip:$tooltip, class:["niri-windows", ("count-" + ($count|tostring)), ("index-" + ($idx|tostring))]}'
}

last_sig=""

while :; do
  windows="$(get windows)"
  workspaces="$(get workspaces)"

  # figure focused workspace
  ws_id="$(printf '%s' "$workspaces" | jq -r '.[]? | select(.focused or .is_focused) | .id' | head -n1)"
  [[ -z "$ws_id" || "$ws_id" == null ]] && \
    ws_id="$(printf '%s' "$windows" | jq -r '.[]? | select(.focused or .is_focused) | (.workspace.id // .workspace // .workspace_id)' | head -n1)"

  if [[ -z "$ws_id" || "$ws_id" == null ]]; then
    sig="empty"
    if [[ "$sig" != "$last_sig" ]]; then
      last_sig="$sig"
      emit "$EMPTY_TEXT" "No focused workspace" 0 0
      echo
    fi
    sleep 0.2
    continue
  fi

  # windows on focused workspace, sorted by layout.pos_in_scrolling_layout[0]
  arr="$(printf '%s' "$windows" | jq --arg ws_id "$ws_id" '
    [ .[]? 
      | select(((.workspace.id // .workspace // .workspace_id) | tostring) == $ws_id)
      | . + {order: (.layout.pos_in_scrolling_layout[0] // 999999)}
    ] | sort_by(.order)
  ')"

  count="$(printf '%s' "$arr" | jq 'length')"
  idx="$(printf '%s' "$arr" | jq 'map(.focused==true or .is_focused==true) | index(true)')"
  [[ "$idx" == null || -z "$idx" ]] && idx=0

  # signature of state (ids, focus, order) to avoid redundant prints
  sig="$(printf '%s' "$arr" | jq -c '[.[].id, .[].focused, .[].is_focused, .[].order]' 2>/dev/null)"
  if [[ "$sig" == "$last_sig" ]]; then
    sleep 0.2
    continue
  fi
  last_sig="$sig"

  # build text
  if [[ "$count" -gt 0 ]]; then
    text=""
    for i in $(seq 0 $((count-1))); do
      if [[ $i -eq $idx ]]; then tok="$ACTIVE_TOKEN"; else tok="$INACTIVE_TOKEN"; fi
      text+="$tok"
      [[ $i -lt $((count-1)) ]] && text+="$SEPARATOR"
    done
  else
    text="$EMPTY_TEXT"
  fi

  # tooltip
  tooltip="$(printf '%s' "$arr" | jq -r --argjson active "$idx" '
    to_entries | map(
      if .key == $active
      then "• " + (.value.title // .value.app_id // "untitled")
      else "  " + (.value.title // .value.app_id // "untitled")
      end
    ) | join("\n")
  ')"
  [[ -z "$tooltip" ]] && tooltip="No windows"

  # emit one compact JSON line
  # emit "$text" "$tooltip" "$count" "$idx"
  # echo
  echo "$text"

  sleep 0.2
done
