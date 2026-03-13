FROM ubuntu:24.04
LABEL maintainer="Masashi Umezawa <ume@softumeya.com>"

ENV DEBIAN_FRONTEND=noninteractive

# --------------------
# Install packages
# --------------------
# - software-properties-common: add-apt-repository support
# - supervisor: process manager
# - vim-tiny: minimal editor
# - xvfb: virtual X server
# - x11vnc: VNC server
# - icewm: lightweight window manager
# - wget: download noVNC/websockify
# - net-tools: network utilities (netstat etc.)
# - locales: locale support
RUN apt-get update && apt-get install -y --no-install-recommends \
  software-properties-common \
  supervisor \
  vim-tiny \
  xvfb \
  x11vnc \
  icewm \
  xterm \
  wget \
  net-tools \
  locales \
  python3 \
  python3-numpy \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# --------------------
# VNC / noVNC
# --------------------
ENV VNC_PORT=5900 \
  NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT

ENV VNC_PW=vncpassword \
  NO_VNC_HOME=/headless/noVNC \
  DESKTOP_BACKGROUND_COLOR=yellow

RUN mkdir -p $NO_VNC_HOME/utils/websockify && \
  wget -qO- https://github.com/novnc/noVNC/archive/v1.4.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME && \
  wget -qO- https://github.com/novnc/websockify/archive/v0.11.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME/utils/websockify && \
  ln -s $NO_VNC_HOME/vnc_lite.html $NO_VNC_HOME/index.html

# add self.pem file if you force ssl only access
COPY ./cert/*.pem $NO_VNC_HOME/utils/websockify/
ENV NO_VNC_CERT_FILE=self.pem

# --------------------
# Setup scripts
# --------------------
COPY ./scripts/setup-wm.sh /usr/local/bin/
COPY ./scripts/setup-vnc.sh /usr/local/bin/
COPY ./scripts/setup-envs-all.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup-*.sh

# --------------------
# Locale / Timezone
# --------------------
ENV LANG=C.UTF-8 \
  LC_ALL=C.UTF-8 \
  TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# --------------------
# Workspace
# --------------------
COPY images /root/images

VOLUME "/root/data"

CMD ["/bin/bash", "-l", "-c", "/usr/local/bin/setup-envs-all.sh && /usr/bin/supervisord -n"]
