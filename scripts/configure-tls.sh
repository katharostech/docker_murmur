#!/bin/bash

if [ "$ACME_ENABLED" = "true" ]; then
    echo "ACME Enabled: TLS certificates will be automatically generated and renewed."
    if [ "$ACME_TEST_MODE" = "true" ]; then test_mode="--test"; fi
    /acme.sh/acme.sh --issue --dns $ACME_DOMAIN_PROVIDER -d $ACME_DOMAIN $test_mode
    
    # Install Certificates
    mkdir -p /run/mumble-server/
    /acme.sh/acme.sh --install-cert -d $ACME_DOMAIN \
        --fullchain-file /var/lib/mumble-server/cert.pem \
        --key-file /var/lib/mumble-server/key.pem \
        --reloadcmd "bash /restart-mumble.sh"
    chown -R mumble-server:mumble-server /run/mumble-server
fi
