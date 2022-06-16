#!/usr/bin/env bash

source .env

echo "Starting ..."
docker-compose -f docker-compose-single1.yml up -d

echo "Make sure file permission is well set"
docker exec -u root nc chown -R www-data:root /var/www/html/

echo "Scanning for new files..."
docker exec -u www-data nc php occ files:scan --all

echo "### Please use the following link to access nextcloud and voyager ###"
echo "For nextcloud: https://nc.${HOSTNAME}"
echo "For voyager: https://voyager.${HOSTNAME}/voyager-story-dev.html?root=models/<your folder name>/&document=<your json file>.json"

echo "Ready"
