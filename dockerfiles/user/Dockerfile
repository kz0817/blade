FROM ubuntu:18.04
ARG USER
ARG UID
ARG GID
#ENV DEBIAN_FRONTEND=noninteractive
RUN groupadd -g $GID $USER \
  && useradd -u $UID -g $USER -G sudo -m -s /bin/bash $USER

USER $USER
CMD ["/bin/bash"]
