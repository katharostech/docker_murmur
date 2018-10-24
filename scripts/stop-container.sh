#!/bin/bash

# Stop Cron
echo "Stopping Cron..."
kill -TERM `cat /run/crond.pid`

# Stop Mumble
echo "Stopping Mumble..."
kill -TERM `ps -C murmurd --format pid=`
# Wait for Mumble to exit ( for some reason kill exits immediately )
sleep 2
