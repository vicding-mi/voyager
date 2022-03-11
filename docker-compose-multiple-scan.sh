#!/usr/bin/env bash

echo "Scanning for new files..."
docker exec -u www-data nc_${USERNAME} php occ files:scan admin
echo "Ready"
