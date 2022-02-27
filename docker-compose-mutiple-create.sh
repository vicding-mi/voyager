#!/usr/bin/env sh

docker-compose -f docker-compose-multiple0.yml up -d
sleep 5
docker exec -u www-data nc php occ maintenance:install --admin-user admin --admin-pass ba222ded25d957b900c03bef914333cd
sleep 5
docker-compose -f docker-compose-multiple0.yml down
docker-compose -f docker-compose-multiple1.yml up -d
docker exec -u root nc chown -R www-data:root /var/www/html/
docker exec -u www-data nc php occ files:scan admin


