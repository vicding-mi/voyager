#!/usr/bin/env sh
if [ -f nc/html/index.html ]; then
  echo "Please use start script, creation should run only once"
  exit
fi
echo "Creating new stack, please wait..."

docker-compose -f docker-compose-multiple0.yml up -d

while [ $(curl -L --write-out '%{http_code}' --silent --output /dev/null http://localhost:8080) != "200" ]; do
  echo "Populating NC, please wait...check again in 8 seconds"
  sleep 8
done
echo "NC populated"

echo "Installing NC..."
docker exec -u www-data nc php occ maintenance:install --admin-user admin --admin-pass ba222ded25d957b900c03bef914333cd

echo "Installing text editor..."
docker exec nc curl -L -o /tmp/files_texteditor.tar.gz https://github.com/nextcloud-releases/files_texteditor/releases/download/v2.14.0/files_texteditor.tar.gz
docker exec nc tar -zxf /tmp/files_texteditor.tar.gz -C /var/www/html/apps/
rm -f /tmp/files_texteditor.tar.gz

echo "Stopping building script"
docker-compose -f docker-compose-multiple0.yml down
sleep 2

echo "Starting running script"
docker-compose -f docker-compose-multiple1.yml up -d

echo "Make sure file permission is well set"
docker exec -u root nc chown -R www-data:root /var/www/html/

echo "Disable default plain text editor, firstrunwizard and dashboard"
docker exec -u www-data nc php occ app:disable text
docker exec -u www-data nc php occ app:disable firstrunwizard
docker exec -u www-data nc php occ app:disable dashboard

echo "Enable text editor"
docker exec -u www-data nc php occ app:enable files_texteditor

echo "Scanning for newly added files..."
docker exec -u www-data nc php occ files:scan admin

echo "Ready"
