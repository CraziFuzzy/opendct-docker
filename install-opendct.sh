#!/usr/bin/env bash

dpkg -s opendct
if [ $? -eq 1 ]
then
	wget https://dl.bintray.com/opendct/Beta/releases/0.5.11/opendct_0.5.11-1_amd64.deb
	dpkg -i opendct_0.5.11-1_amd64.deb
	rm opendct_0.5.11-1_amd64.deb
	echo "OpenDCT Install Complete"

	# Set to use media server consumer, so we don't have to have access to recording location.
	echo "consumer.dynamic.default=opendct.consumer.MediaServerConsumerImpl" >> /etc/opendct/conf/opendct.properties
fi

#set up some permissions

chown -Rv sagetv:sagetv /opt/opendct
chown -Rv 99:sagetv /etc/opendct
chown -Rv sagetv:sagetv /var/log/opendct
chown -v root:sagetv /var/run
chown -v root:sagetv /var/run
chmod 775 /var/run/
chmod 775 /run/

# /opt/opendct/console-only

if test ! -e /var/log/opendct; then
	mkdir -p /var/log/opendct
fi

if test ! -e /var/run/opendct; then
	mkdir -p /var/run/opendct
fi

chown opendct:opendct /var/log/opendct
chown opendct:opendct /var/run/opendct

cd /opt/opendct/jsw/bin
./sh.script.in "start"

tail -q -F --retry /var/log/opendct/opendct.log
