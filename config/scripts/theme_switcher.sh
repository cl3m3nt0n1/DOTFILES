#!/bin/sh

#  _____ _  _ ___ __  __ ___ 
# |_   _| || | __|  \/  | __|
#   | | | __ | _|| |\/| | _| 
#   |_| |_||_|___|_|  |_|___|
#                            


dir="$HOME/.config/rofi/launchers/type-1"
theme='style-9'

launch_rofi()
{
    rofi -dmenu \
    -p "Choose a theme" \
    -theme "${dir}/${theme}.rasi" \ 
    # -theme-str '@import "~/.config/rofi/colors/gruvbox.rasi"'
}

THEME_FOLDER=$HOME/.config/hypr/themes

chosen=$(find "$THEME_FOLDER" -maxdepth 1 -type d -exec basename {} \; | launch_rofi)

if [ -z "$chosen" ]; then
    exit 1
elif [ $chosen = 'themes' ]; then
    echo "ERROR: choose another option."
    exit
else
    killall waybar swaync
    sed -i "s/\$CURRENT_THEME\s*=\s*.*/\$CURRENT_THEME = $chosen/g"   $HOME/.config/hypr/current_theme.conf
    waybar -c "$THEME_FOLDER/$chosen/waybar/config.jsonc" -s "$THEME_FOLDER/$chosen/waybar/style.css" &
    swaync -c $THEME_FOLDER/$chosen/swaync/config.json -s $THEME_FOLDER/$chosen/swaync/style.css &
    echo "$chosen"
    exit
fi
exit
