#!/usr/bin/env bash

dpkg -s opendct
if [ $? -eq 1 ]
then
	wget https://dl.bintray.com/opendct/Beta/releases/0.5.8/opendct_0.5.8-1_amd64.deb
	dpkg -i opendct_0.5.8-1_amd64.deb
	rm opendct_0.5.8-1_amd64.deb
	echo "OpenDCT Install Complete"

	echo consumer.dynamic.default=opendct.consumer.MediaServerConsumerImpl >> /etc/opendct/etc/opendct.properties
fi

/opt/opendct/console-only

