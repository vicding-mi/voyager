#!/usr/bin/env sh

echo "Starting ..."
docker-compose -f docker-compose-multiple1.yml up -d

echo "Scanning for new files..."
docker exec -u www-data nc_${USERNAME} php occ files:scan admin

echo "Ready"
