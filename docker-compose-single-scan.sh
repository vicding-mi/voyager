#!/usr/bin/env bash

nc_container="nc_janpieterk"
get_users() {
  users=$(docker exec -u www-data ${nc_container} php occ user:list)
  oldIfs=IFS
  IFS="-"
  for user in ${users[@]}; do
    user_id=$(expr "$user" : '.*\ \([^_]*\):.*')
    if [ -n "$user_id" ]; then
      echo "$user_id"
    fi
  done
  IFS=oldIfs
}

create_folder() {
  echo "creating folder /var/www/html/data/${user}/files/models"
  docker exec -u root ${nc_container} mkdir -p /var/www/html/data/${user}/files/models
  docker exec -u root ${nc_container} chown -R www-data:root /var/www/html/data/${user}/files/models
}

printf "getting users from nc container $nc_container"
users=$(get_users)

printf "Make sure file permission is well set..."
for user in ${users[@]}; do
  echo "checking permission for user: [${user}]"
  docker exec -u root ${nc_container} chown -R www-data:root /var/www/html/data/${user}/files/models
    if [ $? -eq "1" ];
    then
      create_folder
    fi
done

printf "Scanning for new files...."
docker exec -u www-data ${nc_container} php occ files:scan --all

echo "Ready"