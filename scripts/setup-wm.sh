#!/bin/bash

#IceWM
BACKGROUND_COLOR=${DESKTOP_BACKGROUND_COLOR:-'yellow'}
mkdir -p ~/.icewm
echo 'Theme="icedesert/default.theme"' > ~/.icewm/theme

# The theme sets its own background image, and only prefoverride takes priority over the theme.
# This script runs on every container start: replace our line and keep any other settings.
PREFERENCES_FILE="$HOME/.icewm/prefoverride"
touch "$PREFERENCES_FILE"
sed -i '/^DesktopBackgroundImage[[:space:]]*=/d' "$PREFERENCES_FILE"
echo "DesktopBackgroundImage = \"/root/images/$BACKGROUND_COLOR.jpg\"" >> "$PREFERENCES_FILE"

# Create a simple IceWM Programs menu with xterm if no menu is defined yet
MENU_FILE="$HOME/.icewm/menu"
if [[ ! -s "$MENU_FILE" ]]; then
  cat > "$MENU_FILE" <<'EOF'
prog "XTerm" xterm xterm
EOF
fi
