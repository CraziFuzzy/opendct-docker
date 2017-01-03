#!/usr/bin/env bash

# install opendct
wget https://dl.bintray.com/opendct/Beta/releases/0.5.19/opendct_0.5.19-1_amd64.deb
dpkg -i opendct_0.5.19-1_amd64.deb
rm opendct_0.5.19-1_amd64.deb
echo "OpenDCT Install Complete"
