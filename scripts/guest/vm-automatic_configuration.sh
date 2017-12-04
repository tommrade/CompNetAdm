#!/bin/bash

# Don't touch!
export BASENAME="CNA-"

function message {
echo -e "\n\e[7m$BASENAME$ID>\e[27m $1" #($1 is the text to be displayed.)
			 }
export -f message
export ID=$(ip a | grep -m 1 '08:00:16' | cut -d ":" -f 6 | cut -d " " -f 1) # Get the VM ID by checking its MAC address.
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export FROM=4
export TO=7

# This script must be executed as "kurs" user. Exit if attempted to run as root.
if [[ $EUID -eq 0 ]]; then
   message "Run again - as a regular user rather than root."
   exit 1
fi

# Get some VM-specific color-related variables
source <(sed -n ''"$FROM"',$p;'"$TO"'q' "$DIR/vm$ID.sh")

# Set GNOME Terminal as a default one.
echo -e "TerminalEmulator=gnome-terminal" > "$HOME/.config/xfce4/helpers.rc"

# Theming to the max!
message "Applying theme..."
cd "$DIR/../../rpms" && sudo -S <<< "kursLA" rpm -i gtk2-engines-2.20.2-7.el7.x86_64.rpm clearlooks-phenix-gtk2-theme-7.0.1-3.el7.noarch.rpm clearlooks-phenix-common-7.0.1-3.el7.noarch.rpm &>/dev/null && cd
mkdir -p "$HOME/.themes/$BASENAME$ID/gtk-2.0"
cp "/usr/share/themes/Clearlooks/gtk-2.0/gtkrc" "$HOME/.themes/$BASENAME$ID/gtk-2.0/"
sed -E -i "s/86ABD9/$(printf '%02X\n' "$R")$(printf '%02X\n' "$G")$(printf '%02X\n' "$B")/g;s/EDECEB/$(printf '%02X\n' "$R")$(printf '%02X\n' "$G")$(printf '%02X\n' "$B")/g" "$HOME/.themes/$BASENAME$ID/gtk-2.0/gtkrc"
xfconf-query -c xsettings -p /Net/ThemeName -s "$BASENAME$ID"
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/use-theme-colors false
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/background-color "'rgb($R,$G,$B)'"
if test ${IsTextWhite:-0} -ge 1; then
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/foreground-color "'rgb(255,255,255)'"
else
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/foreground-color "'rgb(0,0,0)'"
fi
xfconf-query -c xfce4-panel -p /panels/panel-1/background-color -t uint -s $(($R * 255)) -t uint -s $(($G * 255)) -t uint -s $(($B * 255)) --create
xfconf-query -c xfce4-panel -p /panels/panel-1/background-style -t uint -s 1 --create
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVGA-0/workspace0/color1 -t uint -s $(($R * 255)) -t uint -s $(($G * 255)) -t uint -s $(($B * 255)) --create

# Execute the rest of scripts...
FROM=$((TO + 1))
# Administrative stuff will be done as root.
su -c "$DIR/vm-reconfigure_as_root.sh" root
