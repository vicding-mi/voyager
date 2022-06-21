#!/usr/bin/env bash

nc_container="nc"
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
  IFS=$oldIfs
}

create_folder() {
  printf "creating folder /var/www/html/data/%s/files/backup\n" "${user}"
  docker exec -u root ${nc_container} mkdir -p /var/www/html/data/"${user}"/files/backup
}

printf "getting users from nc container %s\n" "$nc_container"
users=$(get_users)

printf "Backup user data...\n"
day=$(date +%F_%H:%M)
for user in ${users[@]}; do
  printf "Backup for user: [%s]\n" "${user}"
  docker exec -u root ${nc_container} chown -R www-data:root /var/www/html/data/"${user}"/files/backup
  if [ $? -eq "1" ]; then
    create_folder
  fi
  docker exec -u root ${nc_container} mkdir /var/www/html/data/"${user}"/files/backup/${user}_${day}
  docker exec -u root ${nc_container} rsync -a /var/www/html/data/"${user}"/files/models/ /var/www/html/data/"${user}"/files/backup/${user}_${day}
  docker exec -u root ${nc_container} chown -R www-data:root /var/www/html/data/"${user}"/files/backup
done

printf "Scanning for new files...."
docker exec -u www-data ${nc_container} php occ files:scan --all

echo "Ready"
