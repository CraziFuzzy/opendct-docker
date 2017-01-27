#!/usr/bin/env bash

VERSION=${VERSION:-latest}

# OpenDCT Version
OPENDCT_VERSION=""
if [ "${VERSION}" = "latest" ] ; then
    OPENDCT_VERSION=`curl -L https://bintray.com/opendct/Beta/OpenDCT/_latestVersion | egrep -o '\/opendct\/Beta\/OpenDCT\/[0-9]*\.[0-9]*\.[0-9]*' | tail -1 | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/'`
else
    OPENDCT_VERSION=${VERSION}
fi

# install opendct
OPENDCT_URL=https://dl.bintray.com/opendct/Beta/releases/${OPENDCT_VERSION}/opendct_${OPENDCT_VERSION}-1_amd64.deb
OPENDCT_DEB=opendct_${OPENDCT_VERSION}-1_amd64.deb

echo "Installing OpenDCT ${OPENDCT_VERSION}..."

wget -O ${OPENDCT_DEB} ${OPENDCT_URL}
dpkg -i ${OPENDCT_DEB}
rm -f ${OPENDCT_DEB}

echo "OpenDCT Install Complete"
