#!/usr/bin/env bash

source .env
if [ -z ${USERNAME+x} ]; then
  echo "please specify both USERNAME and HOSTNAME in the env file"
  exit 1
else
  echo "USERNAME is set to ${USERNAME}"
  echo "HOSTNAME is set to ${HOSTNAME}"
fi

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
docker exec -u www-data nc_${USERNAME} php occ maintenance:install --admin-user admin --admin-pass ${PASSWORD}

echo "Installing text editor..."
docker exec nc_${USERNAME} curl -L -o /tmp/files_texteditor.tar.gz https://github.com/nextcloud-releases/files_texteditor/releases/download/v2.14.0/files_texteditor.tar.gz
docker exec nc_${USERNAME} tar -zxf /tmp/files_texteditor.tar.gz -C /var/www/html/apps/
rm -f /tmp/files_texteditor.tar.gz

echo "Stopping building script"
docker-compose -f docker-compose-multiple0.yml down
sleep 2

echo "Starting running script"
docker-compose -f docker-compose-multiple1.yml up -d

echo "Make sure file permission is well set"
docker exec -u root nc_${USERNAME} chown -R www-data:root /var/www/html/

echo "Disable default plain text editor, firstrunwizard and dashboard"
docker exec -u www-data nc_${USERNAME} php occ app:disable text
docker exec -u www-data nc_${USERNAME} php occ app:disable firstrunwizard
docker exec -u www-data nc_${USERNAME} php occ app:disable dashboard

echo "Enable text editor"
docker exec -u www-data nc_${USERNAME} php occ app:enable files_texteditor

echo "Scanning for newly added files..."
docker exec -u www-data nc_${USERNAME} php occ files:scan admin

echo "Adding trusted domain"
docker exec -u www-data nc_${USERNAME} php occ config:system:set trusted_domains 2 --value=nc_${USERNAME}.${HOSTNAME}

echo "Stopping stack after init run"
./docker-compose-multiple-stop.sh

echo "Ready! Run start script to start the stack"
