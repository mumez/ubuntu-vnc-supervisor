#!/bin/bash

#IceWM
BACKGROUND_COLOR=${DESKTOP_BACKGROUND_COLOR:-'yellow'}
mkdir -p ~/.icewm
echo 'Theme="icedesert/default.theme"' >>  ~/.icewm/theme
echo "DesktopBackgroundImage = \"/root/images/$DESKTOP_BACKGROUND_COLOR.jpg\"" >> $HOME/.icewm/preferences

# Create a simple IceWM Programs menu with xterm if no menu is defined yet
MENU_FILE="$HOME/.icewm/menu"
if [[ ! -s "$MENU_FILE" ]]; then
  cat > "$MENU_FILE" <<'EOF'
prog "XTerm" xterm xterm
EOF
fi
