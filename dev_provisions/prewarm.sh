#!/bin/bash

# Collective Intelligence Telemetry Integration
# Auto-generated on 2025-06-18 01:23:53 UTC

# Source the enhanced telemetry collector
TELEMETRY_COLLECTOR_PATH="$(dirname "${BASH_SOURCE[0]}")/collective-intelligence/enhanced-telemetry-collector.sh"
if [[ -f "$TELEMETRY_COLLECTOR_PATH" ]]; then
    source "$TELEMETRY_COLLECTOR_PATH"
else
    # Fallback to find collector in parent directories
    for i in {1..5}; do
        TELEMETRY_COLLECTOR_PATH="$(dirname "${BASH_SOURCE[0]}")$(printf '/..'%.0s {1..$i})/collective-intelligence/enhanced-telemetry-collector.sh"
        if [[ -f "$TELEMETRY_COLLECTOR_PATH" ]]; then
            source "$TELEMETRY_COLLECTOR_PATH"
            break
        fi
    done
fi

# Set script name for telemetry
export COLLECTIVE_SCRIPT_NAME="prewarm.sh"

# Original script content below
# ============================================

echo "## Warming up the server..."
count=0
until [ "$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' http://localhost:3000)" -ne 000 ];
do
    sleep 5;
    if [ "$( docker container inspect -f '{{.State.Running}}' ebwiki )" == "true" ] && [ $count -lt 360 ];
    then
        echo -n ".";
        count=$((count+1))
        sleep 1;
    else
        echo
        echo "## Ending warm up because the server took too long or stopped unexpectedly."
        echo ""
        echo "## To debug, start the server with the following commands and open an issue with the output:"
        echo "docker run --volume \"$(pwd)\":/usr/src/ebwiki --publish 3000:3000 --name ebwiki ebwiki/ebwiki"
        echo ""
        echo "## You can also use these commands to build the server image from scratch and then run it:"
        echo "docker container rm ebwiki"
        echo "docker image rm ebwiki/ebwiki:latest"
        echo "docker build --tag ebwiki/ebwiki ."
        echo "docker run --volume \"$(pwd)\":/usr/src/ebwiki --publish 3000:3000 --name ebwiki ebwiki/ebwiki"
        exit $count
    fi
done
echo
echo "## Warm up is complete after ${count} seconds!"
echo "## Start browsing here: http://localhost:3000"
