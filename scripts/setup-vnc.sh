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
sleep 2
x11vnc -display :0 -bg -listen 0.0.0.0 -rfbauth $PASSWD_PATH -forever -shared 2>/dev/null
sleep 2
DISPLAY=:0 icewm-session 2>/dev/null &
sleep 2

# Start noVNC (noVNC v1.4.0+: use utils/novnc_proxy instead of utils/launch.sh)
NO_VNC_CERT_FILE_PATH="$NO_VNC_HOME/utils/websockify/$NO_VNC_CERT_FILE"
if [[ -f "$NO_VNC_CERT_FILE_PATH" ]]; then
  # SSL enabled
  "$NO_VNC_HOME/utils/novnc_proxy" --vnc "localhost:$VNC_PORT" --listen "$NO_VNC_PORT" --ssl-only --cert "$NO_VNC_CERT_FILE_PATH" &> ~/no_vnc_startup.log &
else
  # HTTP only
  "$NO_VNC_HOME/utils/novnc_proxy" --vnc "localhost:$VNC_PORT" --listen "$NO_VNC_PORT" &> ~/no_vnc_startup.log &
fi
