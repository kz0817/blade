FROM ubuntu:18.04
ARG USER
ARG UID
ARG GID
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    expect \
    gcc \
    gdb \
    make \
    less \
    net-tools \
    screen \
    sudo \
    vim \
    git \
    firefox \
    vnc4server \
    language-pack-ja \
    language-pack-ja-base \
    ibus-mozc \
    xfonts-intl-japanese \
    fonts-noto-cjk \
    gtk2-engines-pixbuf \
    xfce4 \
    xfce4-terminal \
  && apt-get clean

RUN groupadd -g $GID $USER \
  && useradd -u $UID -g $USER -G sudo -m -s /bin/bash $USER \
  && echo "$USER ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER

USER $USER
ENV DISPLAY=:0
ENV RESOLUTION=1280x800
ARG HOME="/home/$USER"
COPY run.sh /start.sh
COPY vncpasswd.txt $HOME/
CMD ["/start.sh"]
