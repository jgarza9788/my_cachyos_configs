#!/bin/bash

scripts_dir="$HOME/.config/niri/scripts"
current_wallpaper="$HOME/.config/niri/.cache/current_wallpaper.png"
current_mode=$(cat "$HOME/.config/niri/.cache/.current_mode")


# colorthief 
# haishoku 
# colorz 
# $backend="colorz"
# $backend="colorthief"

current_wallpaper="$HOME/.config/niri/.cache/current_wallpaper.png"
if [[ -f "$current_wallpaper" ]]; then
    rm -rf "$HOME/.cache/wal/schemes"
    if [[ -f "$HOME/.config/niri/.cache/.current_mode" ]]; then
        if [[ "$current_mode" == "dark" ]]; then
            # wal -q -e --backend colorz -i "$current_wallpaper"
            wal -q -e -i "$current_wallpaper"
        elif [[ "$current_mode" == "light" ]]; then
            # wal -q -e -l --backend colorz -i "$current_wallpaper"
            wal -q -e -l -i "$current_wallpaper"
        fi
    else
        # wal -q -e --backend colorz -i "$current_wallpaper"
        wal -q -e -i "$current_wallpaper"
    fi
fi



colors_file="$HOME/.cache/wal/colors.json"

# setting kitty colors 
kitty_colors="$HOME/.cache/wal/colors-kitty.conf"
kitty="$HOME/.config/kitty/kitty.conf"

# Define a function to extract a specific color
extract_color() {
  color_keyword="$1"
  grep "^${color_keyword}" $kitty_colors | awk '{print $2}'
}

# Extract background and foreground colors
active_border_color=$(extract_color "foreground")
inactive_border_color=$(extract_color "color5")

# kitty colors
sed -i "s/active_border_color .*$/active_border_color $active_border_color/g" "$kitty"
sed -i "s/inactive_border_color .*$/inactive_border_color $inactive_border_color/g" "$kitty"

ln -sf "$HOME/.cache/wal/colors-kitty.conf" "$HOME/.config/kitty/"

# niri colors.
niriConfig="$HOME/.config/niri/config.kdl"
sed -i "s/active-color .*$/active-color \"$active_border_color\"/g" "$niriConfig"
sed -i "s/inactive-color .*$/inactive-color \"$inactive_border_color\"/g" "$niriConfig"

# hyprland colors.
ln -sf "$HOME/.cache/wal/colors-hyprland.conf" "$HOME/.config/hypr/colors-hyprland.conf"

# Apply new colors dynamically
kill -SIGUSR1 $(pidof kitty)

# setting rofi theme
ln -sf "$HOME/.cache/wal/colors-rofi-dark.rasi" "$HOME/.config/rofi/themes/rofi-colors.rasi"

# setting waybar colors
ln -sf "$HOME/.cache/wal/colors-waybar.css" "$HOME/.config/waybar/theme.css"

# setting swaync colors
[[ -n "$(command -v swaync)" ]] && ln -sf "$HOME/.cache/wal/colors-swaync.css" "$HOME/.config/swaync/colors.css"

# setting wlogout colors
ln -sf "$HOME/.cache/wal/colors-waybar.css" "$HOME/.config/wlogout/colors.css"

# updated system update gum colors.
sysupd_script="$scripts_dir/pkgupdate.sh"
monitor_setup_script="$scripts_dir/monitor.sh"
settings_script="$scripts_dir/settings.sh"
avatar_script="$scripts_dir/sddm_avatar.sh"

background_color=$(jq -r '.special.background' "$colors_file")
foreground_color=$(jq -r '.special.foreground' "$colors_file")

colors_file="$HOME/.cache/wal/colors.json"
color0=$(jq -r '.colors.color0' "$colors_file")
color1=$(jq -r '.colors.color1' "$colors_file")
color2=$(jq -r '.colors.color2' "$colors_file")
color3=$(jq -r '.colors.color3' "$colors_file")

## tofi colors
#tofiThemeConfig="$HOME/.config/tofi/themes/theme.conf"
#background_color_tofi="${background_color}e0"
#echo $background_color_tofi
#sed -i "s/background-color=.*$/background-color=\"$background_color_tofi\"/g" "$tofiThemeConfig"
#sed -i "s/border-color=.*$/border-color=\"$color2\"/g" "$tofiThemeConfig"
#sed -i "s/prompt-background=.*$/prompt-background=\"$background_color_tofi\"/g" "$tofiThemeConfig"
#sed -i "s/selection-color=.*$/selection-color=\"$background_color_tofi\"/g" "$tofiThemeConfig"
#sed -i "s/prompt-color=.*$/prompt-color=\"$color2\"/g" "$tofiThemeConfig"
#sed -i "s/selection-background=.*$/selection-background=\"$color2\"/g" "$tofiThemeConfig"

# btop dwon't update when the theme file changes anyways
# btopTheme="$HOME/.config/btop/themes/mytheme.theme"
# sed -i "s/theme\[main_bg\].*/theme[main_bg]=\"$foreground_color\"/g" "$btopTheme"
# sed -i "s/theme\[main_fg\].*/theme[main_fg]=\"$foreground_color\"/g" "$btopTheme"
# sed -i "s/theme\[title\].*/theme[title]=\"$color1\"/g" "$btopTheme"
# sed -i "s/theme\[hi_fg\].*/theme[hi_fg]=\"$color1\"/g" "$btopTheme"
# sed -i "s/theme\[selected_bg\].*/theme[selected_bg]=\"$color2\"/g" "$btopTheme"
# sed -i "s/theme\[selected_fg\].*/theme[selected_fg]=\"$foreground_color\"/g" "$btopTheme"
# sed -i "s/theme\[inactive_fg\].*/theme[inactive_fg]=\"$foreground_color\"/g" "$btopTheme"
# sed -i "s/theme\[proc_misc\].*/theme[proc_misc]=\"$foreground_color\"/g" "$btopTheme"
# sed -i "s/theme\[cpu_box\].*/theme[cpu_box]=\"$color3\"/g" "$btopTheme"
# sed -i "s/theme\[mem_box\].*/theme[mem_box]=\"$color3\"/g" "$btopTheme"
# sed -i "s/theme\[net_box\].*/theme[net_box]=\"$color3\"/g" "$btopTheme"
# sed -i "s/theme\[proc_box\].*/theme[proc_box]=\"$color3\"/g" "$btopTheme"
# sed -i "s/theme\[div_line\].*/theme[div_line]=\"$foreground_color\"/g" "$btopTheme"
# sed -i "s/theme\[temp_start\].*/theme[temp_start]=\"$color1\"/g" "$btopTheme"
# sed -i "s/theme\[temp_mid\].*/theme[temp_mid]=\"$color2\"/g" "$btopTheme"
# sed -i "s/theme\[temp_end\].*/theme[temp_end]=\"$color3\"/g" "$btopTheme"
# sed -i "s/theme\[cpu_start\].*/theme[cpu_start]=\"$color1\"/g" "$btopTheme"
# sed -i "s/theme\[cpu_mid\].*/theme[cpu_mid]=\"$color2\"/g" "$btopTheme"
# sed -i "s/theme\[cpu_end\].*/theme[cpu_end]=\"$color3\"/g" "$btopTheme"
# sed -i "s/theme\[free_start\].*/theme[free_start]=\"$color1\"/g" "$btopTheme"
# sed -i "s/theme\[free_mid\].*/theme[free_mid]=\"$color2\"/g" "$btopTheme"
# sed -i "s/theme\[free_end\].*/theme[free_end]=\"$color3\"/g" "$btopTheme"
# sed -i "s/theme\[cached_start\].*/theme[cached_start]=\"$color1\"/g" "$btopTheme"
# sed -i "s/theme\[cached_mid\].*/theme[cached_mid]=\"$color2\"/g" "$btopTheme"
# sed -i "s/theme\[cached_end\].*/theme[cached_end]=\"$color3\"/g" "$btopTheme"
# sed -i "s/theme\[available_start\].*/theme[available_start]=\"$color1\"/g" "$btopTheme"
# sed -i "s/theme\[available_mid\].*/theme[available_mid]=\"$color2\"/g" "$btopTheme"
# sed -i "s/theme\[available_end\].*/theme[available_end]=\"$color3\"/g" "$btopTheme"
# sed -i "s/theme\[used_start\].*/theme[used_start]=\"$color1\"/g" "$btopTheme"
# sed -i "s/theme\[used_mid\].*/theme[used_mid]=\"$color2\"/g" "$btopTheme"
# sed -i "s/theme\[used_end\].*/theme[used_end]=\"$color3\"/g" "$btopTheme"
# sed -i "s/theme\[download_start\].*/theme[download_start]=\"$color1\"/g" "$btopTheme"
# sed -i "s/theme\[download_mid\].*/theme[download_mid]=\"$color2\"/g" "$btopTheme"
# sed -i "s/theme\[download_end\].*/theme[download_end]=\"$color3\"/g" "$btopTheme"
# sed -i "s/theme\[upload_start\].*/theme[upload_start]=\"$color1\"/g" "$btopTheme"
# sed -i "s/theme\[upload_mid\].*/theme[upload_mid]=\"$color2\"/g" "$btopTheme"
# sed -i "s/theme\[upload_end\].*/theme[upload_end]=\"$color3\"/g" "$btopTheme"


sed -i "s/--prompt.foreground .*/--prompt.foreground \"$foreground_color\" \\\/g" "$sysupd_script"
sed -i "s/--selected.background .*/--selected.background \"$foreground_color\" \\\/g" "$sysupd_script"
sed -i "s/--selected.foreground .*/--selected.foreground \"$background_color\" \\\/g" "$sysupd_script"
sed -i "s/--spinner.foreground .*/--spinner.foreground \"$foreground_color\" \\\/g" "$sysupd_script"
sed -i "s/--spinner.foreground .*/--spinner.foreground \"$foreground_color\" \\\/g" "$monitor_setup_script"
sed -i "s/--title.foreground .*/--title.foreground \"$foreground_color\" \\\/g" "$monitor_setup_script"
sed -i "s/--header.foreground .*/--header.foreground \"$foreground_color\" \\\/g" "$monitor_setup_script"
sed -i "s/--selected.foreground .*/--selected.foreground \"$foreground_color\" \\\/g" "$monitor_setup_script"
sed -i "s/--cursor.foreground .*/--cursor.foreground \"$foreground_color\" \\\/g" "$monitor_setup_script"
sed -i "s/--header.foreground .*/--header.foreground \"$foreground_color\" \\\/g" "$settings_script"
sed -i "s/--cursor.foreground .*/--cursor.foreground \"$foreground_color\" \\\/g" "$settings_script"
sed -i "s/--header.foreground .*/--header.foreground \"$foreground_color\" \\\/g" "$avatar_script"
sed -i "s/--placeholder.foreground .*/--placeholder.foreground \"$foreground_color\" \\\/g" "$avatar_script"

# ----- Dunst
dunst_file="$HOME/.config/dunst/dunstrc"
colors_file="$HOME/.cache/wal/colors.json"

# Function to update Dunst colors
update_dunst_colors() {
    frame=$(jq -r '.special.foreground' "$colors_file")
    low_bg=$(jq -r '.colors.color0' "$colors_file")
    low_fg=$(jq -r '.colors.color7' "$colors_file")
    normal_bg=$(jq -r '.special.background' "$colors_file")
    normal_fg=$(jq -r '.special.foreground' "$colors_file")

    # Update Dunst configuration
    sed -i "s/frame_color = .*/frame_color = \"$frame\"/g" "$dunst_file"
    sed -i "/^\[urgency_low\]/,/^\[/ s/^    background = .*/    background = \"$low_bg\"/g" "$dunst_file"
    sed -i "/^\[urgency_low\]/,/^\[/ s/^    foreground = .*/    foreground = \"$low_fg\"/g" "$dunst_file"
    sed -i "/^\[urgency_normal\]/,/^\[/ s/^    background = .*/    background = \"${normal_bg}80\"/g" "$dunst_file"
    sed -i "/^\[urgency_normal\]/,/^\[/ s/^    foreground = .*/    foreground = \"$normal_fg\"/g" "$dunst_file"
    sed -i "/^\[urgency_critical\]/,/^\[/ s/^    foreground = .*/    foreground = \"$normal_fg\"/g" "$dunst_file"
}

[[ -n "$(command -v dunst)" ]] && update_dunst_colors


# remove these part if you don't like the colors according to your wallpaper.
if [ -f "$colors_file" ]; then
    # Extract background and foreground colors using jq
    background_color=$(jq -r '.special.background' "$colors_file")
    foreground_color=$(jq -r '.special.foreground' "$colors_file")

    # Path to VS Code settings.json file
    vscode_settings_file="$HOME/.config/Code/User/settings.json"

    # Check if the VS Code settings file exists
    if [[ -f "$vscode_settings_file" ]]; then
        sed -i "s/\"editor.background\":\ \".*\"/\"editor.background\": \"$background_color\"/" "$vscode_settings_file"
        sed -i "s/\"sideBar.background\":\ \".*\"/\"sideBar.background\": \"$background_color\"/" "$vscode_settings_file"

        # Uncomment and update more settings as neede
        sed -i "s/\"sideBar.border\":\ \".*\"/\"sideBar.border\": \"$background_color\"/" "$vscode_settings_file"
        sed -i "s/\"sideBar.foreground\":\ \".*\"/\"sideBar.foreground\": \"$foreground_color\"/" "$vscode_settings_file"
        sed -i "s/\"editorGroupHeader.tabsBackground\":\ \".*\"/\"editorGroupHeader.tabsBackground\": \"$background_color\"/" "$vscode_settings_file"
        sed -i "s/\"activityBar.background\":\ \".*\"/\"activityBar.background\": \"$background_color\"/" "$vscode_settings_file"
        sed -i "s/\"activityBar.border\":\ \".*\"/\"activityBar.border\": \"$background_color\"/" "$vscode_settings_file"
        sed -i "s/\"activityBar.foreground\":\ \".*\"/\"activityBar.foreground\": \"$foreground_color\"/" "$vscode_settings_file"
        sed -i "s/\"tab.activeBackground\":\ \".*\"/\"tab.activeBackground\": \"$background_color\"/" "$vscode_settings_file"
        sed -i "s/\"tab.activeForeground\":\ \".*\"/\"tab.activeForeground\": \"$foreground_color\"/" "$vscode_settings_file"
        sed -i "s/\"tab.activeBorder\":\ \".*\"/\"tab.activeBorder\": \"$background_color\"/" "$vscode_settings_file"
        sed -i "s/\"tab.border\":\ \".*\"/\"tab.border\": \"$background_color\"/" "$vscode_settings_file"
        sed -i "s/\"tab.inactiveBackground\":\ \".*\"/\"tab.inactiveBackground\": \"$background_color\"/" "$vscode_settings_file"
        sed -i "s/\"tab.inactiveForeground\":\ \".*\"/\"tab.inactiveForeground\": \"$foreground_color\"/" "$vscode_settings_file"
        sed -i "s/\"terminal.foreground\":\ \".*\"/\"terminal.foreground\": \"$foreground_color\"/" "$vscode_settings_file"
        sed -i "s/\"terminal.background\":\ \".*\"/\"terminal.background\": \"$background_color\"/" "$vscode_settings_file"
    fi
else
    echo "Colors file not found!"
    exit 1
fi

# Refresh the scripts
sleep 0.5
"${scripts_dir}/Refresh.sh"

# ------------------------
