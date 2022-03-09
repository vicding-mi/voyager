#!/usr/bin/env bash

source .env

echo "Starting ..."
docker-compose -f docker-compose-multiple1.yml up -d

echo "Make sure file permission is well set"
docker exec -u root nc_${USERNAME} chown -R www-data:root /var/www/html/

echo "Scanning for new files..."
docker exec -u www-data nc_${USERNAME} php occ files:scan admin

echo "### Please use the following link to access nextcloud and voyager ###"
echo "For nextcloud: https://nc_${USERNAME}.${HOSTNAME} with username admin"
echo "For voyager: https://voyager_${USERNAME}.${HOSTNAME}/voyager-story-dev.html?root=models/<your folder name>/&document=<your json file>.json"

echo "Ready"
