app_cache="$HOME/.config/tofi/app_cache.txt"

desktop_dirs=(
  "$HOME/.local/share/applications"
  "/usr/local/share/applications"
  "/usr/share/applications"
)

G_APP=" "


echo "" >> "$app_cache"

set_app_cache() {
  for dir in "${desktop_dirs[@]}"; do
    [[ -d "$dir" ]] || continue
    while IFS= read -r -d '' file; do
      name="$(grep -m1 -E '^Name=' "$file" | sed 's/^Name=//')"
      exec_line="$(grep -m1 -E '^Exec=' "$file" | sed 's/^Exec=//')"
      [[ -n "${name:-}" && -n "${exec_line:-}" ]] || continue
      exec_line="$(printf '%s' "$exec_line" | sed -E 's/ *%[fFuUdDnNickvm]//g')"
      printf "%s %s\t%s\n" "$G_APP" "$name" "$exec_line"
    done < <(find "$dir" -maxdepth 1 -type f -name '*.desktop' -print0 2>/dev/null)
  done | awk -F'\t' '!seen[$2]++' > "$app_cache"
}

set_app_cache
