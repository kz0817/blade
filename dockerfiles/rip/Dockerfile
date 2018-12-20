FROM ubuntu:18.04
ARG version="1.14.2"
RUN apt-get update && apt-get install -y \
    curl \
    less \
    make \
    build-essential pkg-config libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev libqt4-dev zlib1g-dev \
  && apt-get clean \
  && curl http://www.makemkv.com/download/makemkv-bin-$version.tar.gz | tar xzvf - \
  && cd makemkv-bin-$version \
  && mkdir tmp; echo accepted > tmp/eula_accepted \
  && make install \
  && curl http://www.makemkv.com/download/makemkv-oss-$version.tar.gz | tar xzvf - \
  && cd makemkv-oss-$version \
  && ./configure --prefix=/usr \
  && make install
