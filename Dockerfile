# BUILDING
# docker build -t crazifuzzy/opendct .

FROM ubuntu:16.04

MAINTAINER Christopher Piper <fuzzy@weirdness.com>

ENV APP_NAME="OpenDCT Network Encoder"

ENV DEBIAN_FRONTEND=noninteractive

# add sagetv user and group
RUN useradd -u 911 -U -d /opt/opendct -s /bin/bash -G video sagetv

 Speed up APT
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup \
  && echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache

RUN set -x \
  && apt-get update \
  && apt-get install -y wget default-jre-headless

ADD install-opendct.sh /usr/bin/
RUN chmod 755 /usr/bin/install-opendct.sh

VOLUME ["/etc/opendct"]
VOLUME ["/opt/opendct"]

# Network Encoder and Discovery
EXPOSE 9000 8271

CMD install-opendct.sh
