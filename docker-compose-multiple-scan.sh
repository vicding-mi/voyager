#!/usr/bin/env bash

echo "Make sure file permission is well set"
docker exec -u root nc_${USERNAME} chown -R www-data:root /var/www/html/data/admin/files/Documents/models

echo "Scanning for new files..."
docker exec -u www-data nc_${USERNAME} php occ files:scan admin
echo "Ready"
