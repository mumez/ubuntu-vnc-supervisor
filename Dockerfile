FROM ubuntu:22.04
LABEL maintainer="Masashi Umezawa <ume@softumeya.com>"

ENV DEBIAN_FRONTEND=noninteractive

## Install prerequisites and utilities
RUN apt update && apt install -y \
  software-properties-common \
  python3-software-properties \
  libssl-dev \
  libgit2-dev \
  libssh2-1 \
  supervisor \
  vim-tiny \
  && rm -rf /var/lib/apt/lists/*

# --------------------
# VNC
# --------------------
RUN apt update && apt install -y \
  xvfb \
  x11vnc \
  icewm \
  wget \
  net-tools \
  locales \
  bzip2 \
  python3-numpy \
  && rm -rf /var/lib/apt/lists/*

ENV VNC_PORT=5900 \
  NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT

### Envrionment config
ENV VNC_PW=vncpassword \
  NO_VNC_HOME=/headless/noVNC \
  DESKTOP_BACKGROUND_COLOR=yellow \
  DEBIAN_FRONTEND=noninteractive

RUN mkdir -p $NO_VNC_HOME/utils/websockify && \
  wget -qO- https://github.com/novnc/noVNC/archive/v1.1.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME && \
  wget -qO- https://github.com/novnc/websockify/archive/v0.10.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME/utils/websockify && \
  chmod +x -v $NO_VNC_HOME/utils/*.sh && \
  ln -s $NO_VNC_HOME/vnc_lite.html $NO_VNC_HOME/index.html

# add self.pem file if you force ssl only access 
COPY ./cert/*.pem $NO_VNC_HOME/utils/websockify/
ENV NO_VNC_CERT_FILE=self.pem

# --------------------
# Setup
# --------------------
COPY ./scripts/setup-wm.sh /usr/local/bin/
COPY ./scripts/setup-vnc.sh /usr/local/bin/
COPY ./scripts/setup-envs-all.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup-*.sh
RUN ln -s /usr/bin/python2 /usr/bin/python

# --------------------
# Locale
# --------------------
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# --------------------
# Workspace
# --------------------

COPY images /root/images

VOLUME "/root/data"

CMD ["/bin/bash", "-l", "-c", "/usr/local/bin/setup-envs-all.sh && /usr/bin/supervisord -n"]
