#!/usr/bin/env bash
set -o pipefail

local start_ns end_ns diff_ns
start_ns=$(date +%s%N)


ACTIVE=""
INACTIVE=""
URGENT="󰎃"
FACTIVE="󰄶"
FINACTIVE="󰄷"

get() { niri msg -j "$1" 2>/dev/null || niri msg --json "$1" 2>/dev/null || true; }


windows="$(get windows)"
workspaces="$(get workspaces)"

# for item in $(echo "$workspaces" | jq -r '.[]');  do
#     echo "Item: $item"
# done

# echo $windows

echo "$workspaces" | jq -c 'sort_by(-.id)[]' | while read -r ws; do
    # echo "workspace: $ws"

	id=$(jq -r '.id' <<< "$ws")
	# echo "$id"

	fwswindows="$(printf '%s' "$windows" | jq --arg ws_id "$id" '
    [ .[]? 
      | select((.workspace_id | tostring) == $ws_id)
	  | select(.is_floating  == true)
      | . + {order: (.layout.pos_in_scrolling_layout[0] // .layout.tile_pos_in_workspace_view[0] // 999999)}
    ] | sort_by(.order)
    ')"

	count="$(printf '%s' "$fwswindows" | jq 'length')"

	index=$count
	echo "$fwswindows" | jq -c 'sort_by(-.order)[]' | while read -r win; do 
		# echo $win

		order=$(jq -r '.layout.pos_in_scrolling_layout[0]' <<< "$win" || -1)
		focused=$(jq -r '.is_focused' <<< "$win" || false)
		urgent=$(jq -r '.is_urgent' <<< "$win" || false)
		floating=$(jq -r '.is_floating' <<< "$win" || false)
		title=$(jq -r '.title' <<< "$win" || "unknown")
		app_id=$(jq -r '.app_id' <<< "$win" || "unknown")

		text="$id | "
		for i in $(seq 1 $count); do
			#if [[ "$focused" == "true" ]]; then 
			if [[ "$i" == "$index" ]]; then 
				char="$FACTIVE"; 
			else 
				char="$FINACTIVE"; 
			fi

			text+="$char "
		done
		echo "$text   $title $app_id	"

		# echo "$index"
		((index--))

	done

	wswindows="$(printf '%s' "$windows" | jq --arg ws_id "$id" '
    [ .[]? 
      | select((.workspace_id | tostring) == $ws_id)
	  | select(.is_floating  == false)
      | . + {order: (.layout.pos_in_scrolling_layout[0] // 999999)}
    ] | sort_by(.order)
    ')"

	count="$(printf '%s' "$wswindows" | jq 'length')"
	# echo $count

	# text="$id | "
	echo "$wswindows" | jq -c 'sort_by(-.order)[]' | while read -r win; do 
		# echo $win

		order=$(jq -r '.order' <<< "$win" || -1)
		focused=$(jq -r '.is_focused' <<< "$win" || false)
		urgent=$(jq -r '.is_urgent' <<< "$win" || false)
		floating=$(jq -r '.is_floating' <<< "$win" || false)
		title=$(jq -r '.title' <<< "$win" || "unknown")
		app_id=$(jq -r '.app_id' <<< "$win" || "unknown")

		text="$id | "
		for i in $(seq 1 $count); do
			if [[ $i -eq $order ]]; then 
				char="$ACTIVE"; 
			else 
				char="$INACTIVE"; 
			fi

			if [[ "$urgent" == "true" ]]; then 
				char="$URGENT"
			fi

			text+="$char "
		done
		echo "$text   $title $app_id	"

	done


	# text+="hello"
	# echo "$text"

done


end_ns=$(date +%s%N)
diff_ns=$(( end_ns - start_ns ))
echo "windows_entries exec-time ${diff_ns}ns"