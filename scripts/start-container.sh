#!/bin/bash

# Configure Mumble

# Write out mumble config defaults
cat /mumble-server_mumble.ini > /etc/mumble-server.ini

# Append mumble configs from environment variables
configs=${!MUMBLE_*}
for var in $configs; do
    config_name=${var#*_}
    echo "${config_name}=${!var}" >> /etc/mumble-server.ini
done

# Add ACME config
if [ -n "$ACME_ENABLED" ]; then
  echo "sslCert=/var/lib/mumble-server/cert.pem" >> /etc/mumble-server.ini
  echo "sslKey=/var/lib/mumble-server/key.pem" >> /etc/mumble-server.ini
fi

# Append default ICE config
cat /mumble-server_ice.ini >> /etc/mumble-server.ini

# Append ICE configs from environment variables
configs=${!ICE_*}
for var in $configs; do
    config_name=${var#*_}
    echo "${config_name}=${!var}" >> /etc/mumble-server.ini
done

# Start cron
echo "Starting Cron"
cron

# Start Mumble server
echo "Starting Mumble"
murmurd

# Tail logs
logfile=/var/log/mumble-server/mumble-server.log
while [ ! -f $logfile ]; do sleep 1; done
tail -f $logfile &

