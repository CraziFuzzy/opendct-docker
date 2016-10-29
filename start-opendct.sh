#!/bin/bash 

# trap SIGTERM and relay to the child process
_term() { 
  echo "Caught SIGTERM signal!" 
  kill -TERM "$child" 2>/dev/null
}

trap _term SIGTERM

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

# Launch the opendct JVM and remember PID
echo "Launching opendct JVM...";
/usr/bin/java -Dopendct_log_root=/var/log/opendct -Dconfig_dir=/etc/opendct/conf -Ddaemon_mode=true -XX:ErrorFile=/var/log/opendct/hs_err_pid%p.log -verbose:gc -XX:+UseG1GC -Xms128m -Xmx768m -Djava.library.path=/opt/opendct/jsw/lib:/opt/opendct/lib -classpath '.:/opt/opendct/jsw/lib/*' opendct.Main
child=$! 

# Keep shell open - will break if trapped signal is received and run _term above
wait "$child"
