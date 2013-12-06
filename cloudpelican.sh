#!/bin/bash
# Author: Robin Verlangen
# Very simple logging method for bash
# Requires: perl, wget, hostname

# Config
API_TOKEN='PUT_YOUR_API_TOKEN_HERE'
TIMEOUT=3

# Log method
log() {
        # Endpoint for api calls
        ENDPOINT='https://api.cloudpelican.com/api/push/pixel'

        # Message (all parameters are used in one long string)
        MSG=$@
        MSG_ENC="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$MSG")"

        # Hostname
        HOSTNAME=`hostname`
        HOSTNAME_ENC="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$HOSTNAME")"

        # Full uri
        FULL_URL="$ENDPOINT?t=$API_TOKEN&f[msg]=$MSG_ENC&f[host]=$HOSTNAME_ENC"

        # Post data
        wget -o /dev/null -nv --timeout=$TIMEOUT --dns-timeout=$TIMEOUT --connect-timeout=$TIMEOUT --read-timeout=$TIMEOUT $FULL_URL &
        WGET_PID=$!

        # Kill long running wget if there's is a network issue for example
        COUNTER=0
        while [[ -n $(ps -e | grep "$WGET_PID") && "$COUNTER" -lt "$TIMEOUT" ]]
        do
            sleep 1
            COUNTER=$(($COUNTER+1))
        done
        if [[ -n $(ps -e | grep "$WGET_PID") ]]; then
            kill -s SIGKILL "$WGET_PID"
        fi
}

# Test command
log "Hello CloudPelican from bash"
