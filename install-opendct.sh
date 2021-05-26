#!/usr/bin/env bash
VERSION=${VERSION:-latest}

# OpenDCT Version
GITHUB_REPO="enternoescape/opendct"
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

# install opendct
if [ "${OPENDCT_URL}" = "null" ] ; then
    echo "Unable to find suitable OpenDCT version on github repo ${GITHUB_REPO}"
    exit 1
fi

echo "Installing OpenDCT from ${OPENDCT_URL}..."

OPENDCT_DEB=opendct_amd64.deb

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
