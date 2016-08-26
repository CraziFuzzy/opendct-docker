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

#set up some permissions

chown -Rv sagetv:sagetv /opt/opendct
chown -Rv nobody:users /etc/opendct
chown -v root:sagetv /var/run
chown -v root:sagetv /var/run
chmod 775 /var/run/
chmod 775 /run/

mkdir /var/run/opendct
/opt/opendct/console-only

