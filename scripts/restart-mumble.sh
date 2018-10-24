#!/bin/bash

# If Mumble is running
if [ ! "`ps -C murmurd --format pid=`" = "" ]; then
    # Stop Mumble server
    kill -TERM $(ps -C murmurd --format pid=)
    # Wait for Mumble to exit
    sleep 2

    # Start Mumble server
    murmurd
fi
