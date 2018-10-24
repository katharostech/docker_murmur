#!/bin/bash

# Trap SIGTERM and SIGINT
trap '/stop-container.sh; exit $?' TERM INT

# Configure TLS
bash /configure-tls.sh

# Start Mumble
bash /start-container.sh

# Wait for signal
while true; do sleep 1; done
