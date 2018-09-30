#!/bin/bash

source ./dbinfo.conf

echo "Dumping remote database"
ssh deployer@${remote_host} -i ~/.ssh/id_rsa_o2web_deployer mysqldump -h 127.0.0.1 -u ${remote_db_username} -p${remote_db_password} ${remote_db_name} \> ${remote_db_name}.sql

echo "Gzip remote dump"
ssh deployer@${remote_host} -i ~/.ssh/id_rsa_o2web_deployer gzip ${remote_db_name}.sql

echo "Starting Rsync"
rsync -avz0 -e "ssh -i ~/.ssh/id_rsa_o2web_deployer" deployer@${remote_host}:/home/deployer/${remote_db_name}.sql.gz ./../data/

echo "Ungzip local dump"
gzip -d ./../data/${remote_db_name}.sql.gz

echo "Importing database in docker"
docker exec -i ${local_host} mysql -u${db_username} -p${db_password} ${db_name} < ./../data/${remote_db_name}.sql

echo "Importing data dev"
docker exec -it -uwww-data ${container_namer}-phpfpm /usr/bin/php bin/magento config:data:import app/etc/store dev

echo "Delete remote dump"
ssh deployer@${remote_host} -i ~/.ssh/id_rsa_o2web_deployer rm ${remote_db_name}.sql.gz


echo "DONE"
