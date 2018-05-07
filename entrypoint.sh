#!/bin/bash

touch /data/system.properties

sed -i -e '/^db\.mongo\.local/d' /data/system.properties
sed -i -e '/^db\.mongo\.uri/d' /data/system.properties
sed -i -e '/^statdb\.mongo\.uri/d' /data/system.properties
sed -i -e '/^unifi\.db\.name/d' /data/system.properties

echo "db.mongo.local=false" >> /data/system.properties
echo "db.mongo.uri=mongodb://${MONGODB_HOST}:${MONGODB_PORT}/${MONGODB_NAME}" >> /data/system.properties
echo "statdb.mongo.uri=mongodb://${MONGODB_HOST}:${MONGODB_PORT}/${MONGODB_NAME}_stat" >> /data/system.properties
echo "unifi.db.name=${MONGODB_NAME}" >> /data/system.properties

exec java -jar lib/ace.jar start
