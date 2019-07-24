#!/bin/bash

DATE=$(date --iso-8601=seconds)

touch /data/system.properties
cp /data/system.properties /data/system.properties.$DATE

sed -i -e '/^db\.mongo\.local/d' /data/system.properties
sed -i -e '/^db\.mongo\.uri/d' /data/system.properties
sed -i -e '/^statdb\.mongo\.uri/d' /data/system.properties
sed -i -e '/^unifi\.db\.name/d' /data/system.properties

echo "db.mongo.local=false" >> /data/system.properties
echo "db.mongo.uri=mongodb://${MONGODB_HOSTS}/${MONGODB_NAME}" >> /data/system.properties
echo "statdb.mongo.uri=mongodb://${MONGODB_HOSTS}/${MONGODB_NAME}_stat" >> /data/system.properties
echo "unifi.db.name=${MONGODB_NAME}" >> /data/system.properties

if [ -e /data/keystore ]
then
  cp /data/keystore /data/keystore.backup.$DATE
fi

openssl pkcs12 -export -inkey /certs/tls.key -in /certs/tls.crt -out /tmp/tls.p12 -name unifi -password pass:unifi

keytool -importkeystore -deststorepass aircontrolenterprise -destkeypass aircontrolenterprise -destkeystore /data/keystore -srckeystore /tmp/tls.p12 -srcstoretype PKCS12 -srcstorepass unifi -alias unifi -noprompt

exec java -jar lib/ace.jar start
