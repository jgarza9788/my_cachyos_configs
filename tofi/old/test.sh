# line="App Firefox /usr/lib/firefox/firefox"
line="[web] ChatGPT chromium --app=https://chat.openai.com"

# read -r type label cmd <<<"$(
#   echo "$line" | awk -F'[][]| ' '{printf "%s %s ", $1, $2; $1=$2=$3=$4=""; print substr($0, index($0,$5))}'
# )"


read -r type label cmd <<<"$line"

echo $type
echo $label
echo $cmd