#!/bin/bash

display() {
    cat << "EOF"
   ____         __              __  __        __     __     
  / __/_ _____ / /____ __ _    / / / /__  ___/ /__ _/ /____ 
 _\ \/ // (_-</ __/ -_)  ' \  / /_/ / _ \/ _  / _ `/ __/ -_)
/___/\_, /___/\__/\__/_/_/_/  \____/ .__/\_,_/\_,_/\__/\__/ 
    /___/                         /_/                       
                                                     
EOF
}

display
printf "\n"

# asking for confirmation.
choice=$(gum confirm "Would you like to," \
<<<<<<< HEAD
        --prompt.foreground "#8bc0e6" \
        --affirmative "Update now!" \
        --selected.background "#8bc0e6" \
        --selected.foreground "#000001" \
=======
        --prompt.foreground "#c5cfa5" \
        --affirmative "Update now!" \
        --selected.background "#c5cfa5" \
        --selected.foreground "#0f1507" \
>>>>>>> f188f37580fc25395eea916e04b66b223acba73e
        --negative "Skip updating!"
        )

if [ $? -eq 0 ]; then
    # updating the system
    if [ -n "$(command -v pacman)" ]; then
        aur=$(command -v yay || command -v paru)
        "$aur" -Syyu --noconfirm
    elif [ -n "$(command -v dnf)" ]; then
        sudo dnf update && sudo dnf upgrade -y
    elif [ -n "$(command -v zypper)" ]; then
        sudo zypper up -y
    fi

    sleep 1

    printf "\n\n<> Please press ENTER to close "
    read
else
    gum spin \
        --spinner dot \
<<<<<<< HEAD
        --spinner.foreground "#8bc0e6" \
=======
        --spinner.foreground "#c5cfa5" \
>>>>>>> f188f37580fc25395eea916e04b66b223acba73e
        --title "Skipping updating your system..." -- \
        sleep 2
fi
