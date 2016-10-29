#!/bin/bash 

# Create folders if not present
if test ! -e /etc/opendct/conf; then
        mkdir -p /etc/opendct/conf
fi
if test ! -e /var/run/opendct; then
        mkdir -p /var/run/opendct
fi

# Set up some permissions
chown -Rv sagetv:sagetv /opt/opendct
chown -Rv 99:sagetv /etc/opendct
chown -Rv 99:sagetv /var/log/opendct
chown -v root:sagetv /var/run
chmod 775 /var/run/
chmod 775 /run/

# Set to use media server consumer, so we don't have to have access to recording location.
echo -e "\nconsumer.dynamic.default=opendct.consumer.MediaServerConsumerImpl\n" >> /etc/opendct/conf/opendct.properties

# keep shell open
sleep infinite

