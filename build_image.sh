#!/usr/bin/env sh

set -euo pipefail

export GOPATH='/tmp/go'

apk upgrade -U
apk add build-base upx git go bash
mkdir -p ${GOPATH}/src/github.com/elastic
git clone https://github.com/elastic/apm-server.git ${GOPATH}/src/github.com/elastic/apm-server
cd ${GOPATH}/src/github.com/elastic/apm-server
make
mv apm-server /usr/local/bin/

### Create APM-SERVER user
addgroup -g 1000 ${APM_USER}
adduser -u 1000 -G ${APM_GROUP} -D -H -h ${APM_HOME} ${APM_USER}

### Setup APM_HOME 
mkdir -p -m 750 ${APM_HOME}
mkdir -p -m 770 ${APM_HOME}/data ${APM_HOME}/logs
chown -R root:${APM_GROUP} ${APM_HOME}

cp $(dirname $0)/*.yml ${APM_HOME}/ || true
cp $(dirname $0)/apm-server.yml.example ${APM_HOME}/apm-server.yml
cp $(dirname $0)/entrypoint.sh /

## CLEANUP
apk del --purge build-base upx git go bash
rm -rf /tmp/* /var/cache/apk/*

# Remove the suid bit everywhere it is set to mitigate against stackclash
find / -xdev -perm -4000 -exec chmod u-s {} +