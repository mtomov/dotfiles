## Postgres backup & restore
pg_dump -F c -v -U postgres -h localhost <db-name> -f ./db/production.dump.psql
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d <db-name> ./db/production.dump.psql


## Apt: Backup package list
=============================
NAME_BACKUP_DIR=/media/martin/Storage/Backup/packages

dpkg --get-selections > ${NAME_BACKUP_DIR}/Package.list
sudo cp -R /etc/apt/sources.list* ${NAME_BACKUP_DIR}/all
sudo apt-key exportall > ${NAME_BACKUP_DIR}/Repo.keys

rsync --progress /home/`whoami` /path/to/user/profile/backup/here

## Apt: Reinstall package now list
====================================
rsync --progress /path/to/user/profile/backup/here /home/`whoami`
sudo apt-key add ~/Repo.keys
sudo cp -R ~/sources.list* /etc/apt/
sudo apt-get update
sudo apt-get install dselect
sudo dpkg --set-selections < ~/Package.list
sudo dselect
