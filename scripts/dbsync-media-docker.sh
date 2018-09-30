#!/bin/bash

source ./dbinfo.conf

echo "Starting Rsync Media"
rsync -avz0 -e "ssh -i ~/.ssh/id_rsa_o2web_deployer" --exclude 'cache' deployer@${remote_host}:${remote_media}/* ${local_media}/

echo "DONE"
