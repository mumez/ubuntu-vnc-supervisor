#!/bin/bash

#IceWM
BACKGROUND_COLOR=${BACKGROUND_COLOR:-'yellow'}
mkdir -p ~/.icewm
echo 'Theme="icedesert/default.theme"' >>  ~/.icewm/theme
echo "DesktopBackgroundImage = \"/root/images/$BACKGROUND_COLOR.jpg\"" >> $HOME/.icewm/preferences
