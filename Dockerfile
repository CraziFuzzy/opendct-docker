# BUILDING
# docker build -t crazifuzzy/opendct .

FROM ubuntu:16.04

MAINTAINER Christopher Piper <fuzzy@weirdness.com>

ENV APP_NAME="OpenDCT Network Encoder"

ENV DEBIAN_FRONTEND=noninteractive

# add sagetv user and group
RUN useradd -u 911 -U -d /opt/opendct -s /bin/bash -G video sagetv

# Speed up APT
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup \
  && echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache

RUN set -x \
  && apt-get update \
  && apt-get install -y wget default-jre-headless

RUN apt-get install -y supervisor

VOLUME ["/etc/opendct"]
VOLUME ["/var/log/opendct"]

ADD install-opendct.sh /usr/bin/
ADD prep-opendct.sh /usr/bin/
RUN chmod 755 /usr/bin/install-opendct.sh
RUN chmod 755 /usr/bin/prep-opendct.sh

# Install opendct
RUN install-opendct.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# launch supervisord which will launch opendct
ENTRYPOINT ["/usr/bin/supervisord"]
