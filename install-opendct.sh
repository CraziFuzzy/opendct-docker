#!/usr/bin/env bash

# install opendct
wget https://dl.bintray.com/opendct/Beta/releases/0.5.12/opendct_0.5.12-1_amd64.deb
dpkg -i opendct_0.5.12-1_amd64.deb
rm opendct_0.5.12-1_amd64.deb
echo "OpenDCT Install Complete"
