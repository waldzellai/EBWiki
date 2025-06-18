#!/bin/bash -e

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
export COLLECTIVE_SCRIPT_NAME="run_tests.sh"

# Original script content below
# ============================================

echo "## Running tests for seed cases..."

pass=0
fail=0
count=0

for i in sven-svensson janez-novak max-mustermann janina-kowalska chichiko-bendeliani mario-rossi;
do
    curl --fail --max-time 60 -sLk -o /dev/null \
        -w "%{time_total} %{num_redirects} %{http_code} %{url_effective}\n" \
        "http://localhost:3000/cases/${i}" \
        && pass=$((pass+1)) || fail=$((fail+1));
    count=$((count+1))
done

echo "## Tests for seed cases complete!"
echo "Pass: $pass / $count"
echo "Fail: $fail / $count"

if [ $fail -gt 0 ];
then
    exit $fail;
fi
