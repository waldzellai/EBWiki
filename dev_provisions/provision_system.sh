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
export COLLECTIVE_SCRIPT_NAME="provision_system.sh"

# Original script content below
# ============================================

source /vagrant/dev_provisions/environment.sh
export DEBIAN_FRONTEND=noninteractive
echo '##  Updating the apt cache'
apt-get install -qq aptitude
aptitude update 2>&1

echo '## Allow default user to install in /usr/local'
setfacl --modify='u:vagrant:rwx' --recursive /usr/local/

echo '##  Installing dependencies'
aptitude install --assume-yes \
    apt-transport-https \
    autoconf \
    automake \
    bison \
    build-essential \
    curl \
    g++ \
    gcc \
    git \
    git-core \
    gnupg2 \
    libcurl4-openssl-dev \
    libffi-dev \
    libgdbm-dev \
    libgdbm5 \
    libncurses5-dev \
    libpq-dev \
    libreadline6-dev \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libxml2-dev \
    libxslt-dev \
    libyaml-dev \
    make \
    nginx \
    nodejs \
    npm \
    openjdk-8-jre \
    postgresql \
    redis-server \
    ruby \
    ruby-dev \
    sqlite3 \
    zlib1g-dev 2>&1

echo '##  Installing Node.js'
wget -qO- "https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh" | bash 2>&1 >> ${INSTALL_LOG}
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 2>&1 >> ${INSTALL_LOG}
nvm install --lts 2>&1 >> ${INSTALL_LOG}

echo '##  Install Elasticsearch'
cp /vagrant/dev_provisions/elastic-6.x.list /etc/apt/sources.list.d
wget -q https://artifacts.elastic.co/GPG-KEY-elasticsearch -O /tmp/GPG-KEY-elasticsearch
(apt-key add /tmp/GPG-KEY-elasticsearch) 2>&1
aptitude update 2>&1
aptitude install --assume-yes --quiet elasticsearch 2>&1
systemctl enable elasticsearch 2>&1

echo '##  Installing NGINX'
cp /vagrant/dev_provisions/nginx.conf /etc/nginx/sites-available/default
systemctl enable nginx 2>&1

echo '##  Installing PostgreSQL'
systemctl enable postgresql 2>&1

(
echo '#########################################################'
echo '##  Installation complete!'
echo "##  End time: $(date)"
echo '#########################################################'
echo '##  Environment Summary'
echo '#########################################################'
echo "node    = $(nodejs --version)"
echo "npm     = $(npm -v)"
echo "java    = $(java -version 2>&1 | grep version)"
echo "psql    = $(psql --version)"
echo "nginx   = $(nginx -v 2>&1)"
echo "redis   = $(redis-server --version | awk '{print $3}')"
echo "elastic = $(curl -sX GET 'http://localhost:9200')"
echo '#########################################################'
) > /tmp/system_provision.txt
chown postgres /vagrant/db/structure.sql

su - postgres -c \
psql <<__END__
CREATE USER blackops WITH PASSWORD '${BLACKOPS_DATABASE_PASSWORD}';
ALTER USER blackops WITH SUPERUSER;
__END__

/etc/init.d/elasticsearch start
until [ $(curl -o /dev/null --silent --head --write-out '%{http_code}\n' http://127.0.0.1:9200) -eq 200 ]; do sleep 1; done

