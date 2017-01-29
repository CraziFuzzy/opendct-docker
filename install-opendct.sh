#!/usr/bin/env bash

VERSION=${VERSION:-latest}

# OpenDCT Version
OPENDCT_VERSION=""
if [ "${VERSION}" = "latest" ] ; then
    OPENDCT_VERSION=`curl -L https://bintray.com/opendct/Releases/OpenDCT/_latestVersion | egrep -o '\/opendct\/Releases\/OpenDCT\/[0-9]*\.[0-9]*\.[0-9]*' | tail -1 | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/'`
    OPENDCT_URL=https://dl.bintray.com/opendct/Releases/releases/${OPENDCT_VERSION}/opendct_${OPENDCT_VERSION}-1_amd64.deb
    OPENDCT_DEB=opendct_${OPENDCT_VERSION}-1_amd64.deb
elif [ "${VERSION}" = "beta" ] ; then
    OPENDCT_VERSION=`curl -L https://bintray.com/opendct/Beta/OpenDCT/_latestVersion | egrep -o '\/opendct\/Beta\/OpenDCT\/[0-9]*\.[0-9]*\.[0-9]*' | tail -1 | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/'`
    OPENDCT_URL=https://dl.bintray.com/opendct/Beta/releases/${OPENDCT_VERSION}/opendct_${OPENDCT_VERSION}-1_amd64.deb
    OPENDCT_DEB=opendct_${OPENDCT_VERSION}-1_amd64.deb
else
    OPENDCT_VERSION=${VERSION}
    OPENDCT_URL=https://dl.bintray.com/opendct/Beta/releases/${OPENDCT_VERSION}/opendct_${OPENDCT_VERSION}-1_amd64.deb
    OPENDCT_DEB=opendct_${OPENDCT_VERSION}-1_amd64.deb
fi

# install opendct
echo "Installing OpenDCT ${OPENDCT_VERSION}..."

wget -O ${OPENDCT_DEB} ${OPENDCT_URL}
dpkg -i ${OPENDCT_DEB}
rm -f ${OPENDCT_DEB}

# Set up some permissions
chown -Rv sagetv:sagetv /opt/opendct
chown -Rv 99:sagetv /etc/opendct
chown -Rv 99:sagetv /var/log/opendct
chown -v root:sagetv /var/run
mkdir /var/run
mkdir /var/run/opendct
chmod 775 /var/run/
chmod 775 /run/

echo "OpenDCT Install Complete :-)"

# Set to use media server consumer, so we don't have to have access to recording location.
echo -e "\nconsumer.dynamic.default=opendct.consumer.MediaServerConsumerImpl\n" >> /etc/opendct/conf/opendct.properties

echo "Launching OpenDCT"
/opt/opendct/console-only
