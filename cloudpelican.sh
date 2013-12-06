#!/bin/bash
# Author: Robin Verlangen
# Very simple logging method for bash
# Requires: perl, wget, hostname

# Config
API_TOKEN='PUT_YOUR_API_TOKEN_HERE'

# Log method
log() {
        # Endpoint for api calls
        ENDPOINT='https://api.cloudpelican.com/api/push/pixel'

        # Message
        MSG=$1
        MSG_ENC="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$MSG")"

        # Hostname
        HOSTNAME=`hostname`
        HOSTNAME_ENC="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$HOSTNAME")"

        # Full uri
        FULL_URL="$ENDPOINT?t=$API_TOKEN&f[msg]=$MSG_ENC&f[host]=$HOSTNAME_ENC"
        echo $FULL_URL

        # Post data
        wget -o /dev/null -nv --timeout=3 $FULL_URL
}

# Test command
log "Hello CloudPelican from bash"
