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
export COLLECTIVE_SCRIPT_NAME="environment.sh"

# Original script content below
# ============================================

export EBWIKI_SITEMAP_URL='http://bow-sitemaps.s3.amazonaws.com/sitemaps/sitemap.xml.gz'
export DEBIAN_FRONTEND='noninteractive'
export BLACKOPS_DATABASE_PASSWORD='ebwiki'
export DATABASE_DUMP_FILE='latest.dump'
export SEARCHBOX_URL='http://127.0.0.1:9200/'
export JAVA_HOME='/usr/lib/jvm/java-8-openjdk-amd64/jre'
export MAILCHIMP_API_KEY=''
export MAILCHIMP_LINK=''
export MAILCHIMP_LIST_ID=''
export CODECLIMATE_REPO_TOKEN=''
export AUTOBUS_SNAPSHOT_URL=''

# AWS Credentials for FakeS3.  Please don't change!
export AWS_ACCESS_KEY_ID='accessKey1'
export AWS_SECRET_KEY_ID='verySecretKey1'
export FAKE_S3_KEY='1908855126'
export FAKE_S3_PORT='4567'
export FAKE_S3_HOME='/tmp/fakes3'
