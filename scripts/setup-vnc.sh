#!/bin/bash

source $HOME/.bashrc

# Setup VNC
mkdir -p "$HOME/.x11vnc"
PASSWD_PATH="$HOME/.x11vnc/passwd"

if [[ -f $PASSWD_PATH ]]; then
    rm -f $PASSWD_PATH
fi

x11vnc -storepasswd "$VNC_PW" "$PASSWD_PATH"
chmod 600 $PASSWD_PATH

Xvfb :0 -screen 0 1280x1220x24 -nolisten tcp 2>/dev/null &
x11vnc -display :0 -bg -listen 0.0.0.0 -rfbauth $PASSWD_PATH -forever -shared 2>/dev/null
DISPLAY=:0 icewm-session 2>/dev/null &

NO_VNC_CERT_FILE_PATH=$NO_VNC_HOME/utils/websockify/$NO_VNC_CERT_FILE 
# Start noVNC
if [[ -f $NO_VNC_CERT_FILE_PATH ]]; then
  $NO_VNC_HOME/utils/launch.sh --vnc localhost:$VNC_PORT --listen $NO_VNC_PORT --ssl-only --cert $NO_VNC_CERT_FILE_PATH &> ~/no_vnc_startup.log &
else
  $NO_VNC_HOME/utils/launch.sh --vnc localhost:$VNC_PORT --listen $NO_VNC_PORT &> ~/no_vnc_startup.log &
fi
