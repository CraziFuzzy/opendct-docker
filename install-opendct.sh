#!/usr/bin/env bash

VERSION=${VERSION:-latest}
OPENDCT_CUR_INSTALL_FILE=".OPENDCT_CUR_INSTALL"
GITHUB_REPO="enternoescape/opendct"
OPENDCT_LOCAL_DEB=opendct_amd64.deb

# Attempt to find download URL of requested OpenDCT version...
OPENDCT_URL="null"
if [ "${VERSION}" = "latest" ] ; then
    echo "Finding latest stable version..."
    OPENDCT_URL=`curl -s https://api.github.com/repos/${GITHUB_REPO}/releases | \
  jq -r '[[.[] |
    select(.draft != true) |
    select(.prerelease != true)][0] |
    .assets |
    .[] |
    select(.name | endswith(".deb")) |
    .browser_download_url][0]'`

elif [ "${VERSION}" = "beta" ] ; then
    echo "Finding latest version (including beta)..."
    OPENDCT_URL=`curl -s https://api.github.com/repos/${GITHUB_REPO}/releases | \
  jq -r '[[.[] |
    select(.draft != true)][0] |
    .assets |
    .[] |
    select(.name | endswith(".deb")) |
    .browser_download_url][0]'`

else
    echo "Finding version ${VERSION}..."
    OPENDCT_URL=`curl -s https://api.github.com/repos/${GITHUB_REPO}/releases | \
  jq --arg ver "opendct_${VERSION}-1" -r '[[.[] |
    select(.draft != true)][0] |
    .assets |
    .[] |
    select(.name | endswith(".deb")) |
    select(.name | contains($ver)) |
    .browser_download_url][0]'`

fi

if [ "${OPENDCT_URL}" = "null" ] ; then
    OPENDCT_URL = ""
fi

# Check what we (supposedly) currently have installed, if anything...
OPENDCT_CUR_INSTALL=""
if [ -e ${OPENDCT_CUR_INSTALL_FILE} ] ; then
    OPENDCT_CUR_INSTALL=`cat ${OPENDCT_CUR_INSTALL_FILE}`
fi

# Install Opendct
if [ "${OPENDCT_CUR_INSTALL}" = "" ] && [ "${OPENDCT_URL}" = "" ] ; then
    echo "Unable to find suitable OpenDCT version on github repo ${GITHUB_REPO}"
elif [ "${OPENDCT_CUR_INSTALL}" = "${OPENDCT_URL}" ] ; then
    echo "Installed version of OpenDCT matches preferred version on github repo ${GITHUB_REPO}"
else
    echo "Installing OpenDCT from ${OPENDCT_URL}..."

    wget -O ${OPENDCT_LOCAL_DEB} ${OPENDCT_URL}
    dpkg -i ${OPENDCT_LOCAL_DEB}
    rm -f ${OPENDCT_LOCAL_DEB}

    # Set up some permissions
    chown -Rv sagetv:sagetv /opt/opendct
    chown -Rv 99:sagetv /etc/opendct
    chown -Rv 99:sagetv /var/log/opendct
    chown -v root:sagetv /var/run
    mkdir /var/run
    mkdir /var/run/opendct
    chmod 775 /var/run/
    chmod 775 /run/

    # Set to use media server consumer, so we don't have to have access to recording location.
    echo -e "\nconsumer.dynamic.default=opendct.consumer.MediaServerConsumerImpl\n" >> /etc/opendct/conf/opendct.properties

    # Record the installed version to prevent reinstallation every time the container starts
    echo "${OPENDCT_URL}" > ${OPENDCT_CUR_INSTALL_FILE}

    echo "OpenDCT Install Complete :-)"
fi

echo "Launching OpenDCT"
/opt/opendct/console-only
