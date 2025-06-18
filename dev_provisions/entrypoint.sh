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
export COLLECTIVE_SCRIPT_NAME="entrypoint.sh"

# Original script content below
# ============================================

source ./dev_provisions/environment.sh

chown postgres ./db/structure.sql
cp -v ./dev_provisions/database.yml ./config

for i in postgresql redis-server elasticsearch;
do
    echo "## Starting $i"
    service $i start
done


echo -n "## Waiting for elasticsearch..."
until [ $(curl -o /dev/null --silent --head --write-out '%{http_code}\n' http://127.0.0.1:9200) -eq 200 ];
do
    echo -n ".";
    sleep 1;
done
echo

echo "## Create DB user"
runuser -l postgres -c "psql -c \"CREATE USER blackops WITH PASSWORD '${BLACKOPS_DATABASE_PASSWORD}';\""
runuser -l postgres -c "psql -c \"ALTER USER blackops WITH SUPERUSER;\""

for i in create structure:load seed migrate;
do
    echo "## Running rake db:${i}"
    rake db:${i}
done

echo "## Starting fakes3"
fakes3 --root ${FAKE_S3_HOME} --port ${FAKE_S3_PORT} --license ${FAKE_S3_KEY} &
sleep 2

echo '#########################################################'
echo '##  Environment Summary'
echo '#########################################################'
echo "rails   = $(rails -v)"
echo "ruby    = $(ruby -v)"
echo "node    = $(node --version)"
echo "npm     = $(npm -v)"
echo "java    = $(java -version 2>&1 | grep version)"
echo "psql    = $(psql --version)"
echo "redis   = $(redis-server --version | awk '{print $3}')"
echo "elastic = $(curl -sX GET 'http://localhost:9200')"
echo '#########################################################'

echo "## Starting the server..."
bundle exec rails server -b 0.0.0.0 -e development
