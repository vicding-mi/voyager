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

printf "getting users from nc container $nc_container"
users=$(get_users)

printf "Make sure file permission is well set..."
for user in ${users[@]}; do
  echo "checking permission for user: [${user}]"
  docker exec -u root ${nc_container} chown -R www-data:root /var/www/html/data/${user}/files/Documents/models
done

printf "Scanning for new files...."
docker exec -u www-data ${nc_container} php occ files:scan --all

echo "Ready"
