#!/bin/sh

# __      ___   _    _    ___  _   ___ ___ ___ 
# \ \    / /_\ | |  | |  | _ \/_\ | _ \ __| _ \
#  \ \/\/ / _ \| |__| |__|  _/ _ \|  _/ _||   /
#   \_/\_/_/ \_\____|____|_|/_/ \_\_| |___|_|_\


dir="$HOME/.config/rofi/launchers/type-3"
theme='style-10'

launch_rofi()
{
    rofi -dmenu \
    -show-icons \
    -i \
    -p "Choose a wallpaper" \
    -theme "${dir}/${theme}.rasi" \ 
    -theme-str '@import "~/.config/rofi/colors/gruvbox.rasi"'
}

CACHE_DIR=$HOME/.cache/rofi_wallpaper_picker
WALLPAPER_FOLDER=$HOME/Images/Wallpapers


if [ ! -d "${CACHE_DIR}" ] ; then
    mkdir -p "${CACHE_DIR}"
fi


for wallpaper in "$WALLPAPER_FOLDER"/*.{jpg,jpeg,png}; do
    if [ -f "$wallpaper" ]; then
        wallpaper_name=$(basename "$wallpaper")
        if [ ! -f "${CACHE_DIR}/${wallpaper_name}" ] ; then
            magick "$wallpaper" -thumbnail '320x180>' "${CACHE_DIR}/${wallpaper_name}"
        fi
    fi
done

files=$(find "$WALLPAPER_FOLDER" -type f -printf "%f\n")

if [ -z "$files" ]; then
    echo "No wallpapers found in $WALLPAPER_FOLDER"
    exit 1
fi

chosen=$(find "${WALLPAPER_FOLDER}" -type f -printf "%P\n" | sort | while read -r A ; do echo -en "$A\x00icon\x1f""${CACHE_DIR}"/"$A\n" ; done | launch_rofi)

if [ -z "$chosen" ]; then
    exit 1
else
    killall swaybg
    sed -i "2s|\$WALLPAPER_FOLDER\/.*|"\$WALLPAPER_FOLDER"/$chosen|" $HOME/.config/hypr/current_wallpaper.conf
    swaybg -i "$WALLPAPER_FOLDER/$chosen" &
    exit
fi
exit
