#!/bin/bash

#IceWM
BACKGROUND_COLOR=${DESKTOP_BACKGROUND_COLOR:-'yellow'}
mkdir -p ~/.icewm
echo 'Theme="icedesert/default.theme"' >>  ~/.icewm/theme
echo "DesktopBackgroundImage = \"/root/images/$DESKTOP_BACKGROUND_COLOR.jpg\"" >> $HOME/.icewm/preferences
