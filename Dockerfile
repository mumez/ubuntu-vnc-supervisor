FROM ubuntu:bionic
LABEL maintainer="Masashi Umezawa <ume@sorabito.com>"

ENV DEBIAN_FRONTEND=noninteractive

## Install prerequisites and utilities
RUN apt-get update && apt-get install -y \
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
RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    icewm \
    wget \
    net-tools \
    locales \
    bzip2 \
    python-numpy \
  && rm -rf /var/lib/apt/lists/*

ENV VNC_PORT=5900 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT

### Envrionment config
ENV STARTUPDIR=/usr/local/bin \
    INST_SCRIPTS=/headless/install \
    VNC_COL_DEPTH=24 \
    VNC_PW=vncpassword \
    NO_VNC_HOME=/headless/noVNC \
    BACKGROUND_COLOR=green \
    DEBIAN_FRONTEND=noninteractive

# use older version of websockify to prevent hanging connections on offline containers, see https://github.com/ConSol/docker-headless-vnc-container/issues/50
RUN mkdir -p $NO_VNC_HOME/utils/websockify && \
  wget -qO- https://github.com/novnc/noVNC/archive/v1.0.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME && \
  wget -qO- https://github.com/novnc/websockify/archive/v0.6.1.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME/utils/websockify && \
  chmod +x -v $NO_VNC_HOME/utils/*.sh && \
  ln -s $NO_VNC_HOME/vnc_lite.html $NO_VNC_HOME/index.html

# add site.pem file if you force ssl only access 
COPY ./cert/*.pem $NO_VNC_HOME/utils/websockify
ENV NO_VNC_CERT_FILE=site.pem

# --------------------
# Setup
# --------------------
COPY ./scripts/setup-wm.sh /usr/local/bin/
COPY ./scripts/setup-vnc.sh /usr/local/bin/
COPY ./scripts/setup-envs-all.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup-*.sh

# --------------------
# Locale
# --------------------
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# --------------------
# Workspace
# --------------------

COPY images /root/images

VOLUME [ "/root/data" ]

CMD [ "/bin/bash", "-l", "-c", "/usr/local/bin/setup-envs-all.sh && /usr/bin/supervisord -n" ]
