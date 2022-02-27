#!/usr/bin/env sh

docker-compose -f docker-compose-multiple0.yml up -d

while [ $(curl -L --write-out '%{http_code}' --silent --output /dev/null http://localhost:8080) != "200" ]; do
  echo "waiting for NC to populate...check again in 5 seconds"
  sleep 5
done
echo "NC populated"

echo "Installing NC..."
docker exec -u www-data nc php occ maintenance:install --admin-user admin --admin-pass ba222ded25d957b900c03bef914333cd

echo "Stopping building script"
docker-compose -f docker-compose-multiple0.yml down
sleep 2

echo "Starting running script"
docker-compose -f docker-compose-multiple1.yml up -d

echo "Make sure file permission is well set"
docker exec -u root nc chown -R www-data:root /var/www/html/

echo "Scanning for newly added files..."
docker exec -u www-data nc php occ files:scan admin

echo "Ready"
