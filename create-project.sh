#!/bin/sh

current="$(pwd)"
oldname="myproject"

/bin/echo -n "name project ? :"
read name_project
if [ "$name_project" ==   '' ]
then
    echo "name project need to be define"
    exit 1
fi

/bin/echo -n "path workspace directory ? absolute path only: [$HOME/workspace]"
read path_workspace
echo $path_workspace
if [ "$path_workspace" ==   '' ]
then
    path_workspace="$HOME/workspace"
fi

/bin/echo -n "code project ? only alphanumeric allowed  : [$name_project]"
read code_project
if [ "$code_project" ==   '' ]
then
    code_project="$name_project"
fi

if [ ! -f ~/.bash_aliases ]; then
   echo 'create .bash_aliases'
   touch ~/.bash_aliases
fi

if [ ! -f ~/.bashrc ]; then
   echo 'create .bashrc'
   touch ~/.bashrc
fi

if [ ! -f ~/.bash_profile ]; then
   echo 'create .bash_profile'
   touch ~/.bash_profile
   echo "if [ -f ~/.bashrc ]; then" >> ~/.bash_profile
   echo "    source ~/.bashrc" >> ~/.bash_profile
   echo "fi" >> ~/.bash_profile
   echo "if [ -f ~/.bash_aliases ]; then" >> ~/.bash_profile
   echo "    source ~/.bash_aliases" >> ~/.bash_profile
   echo "fi" >> ~/.bash_profile
fi

echo 'change directory for : '$path_workspace
cd $path_workspace

if [ ! -d $name_project ]
then
    echo 'create project directory' $path_workspace'/'$name_project
    mkdir $name_project
    mkdir $name_project/config
    mkdir $name_project/config/vm
    mkdir $name_project/data
    mkdir $name_project/scripts
    mkdir $name_project/src

    echo 'copy architecture in ' $path_workspace'/'$name_project
    cp -R $current/config/vm/* $name_project/config/vm/
    cp -R $current/scripts/* $name_project/scripts/
    cp -R $current/scripts/dbinfo.conf.sample $name_project/scripts/dbinfo.conf

    echo 'Transform variables'
    sed -i '' "s/$oldname/$code_project/g" $name_project/config/vm/docker-compose.yml
    sed -i '' "s/$oldname/$code_project/g" $name_project/config/vm/docker-compose-dev.yml
    sed -i '' "s/$oldname/$code_project/g" $name_project/config/vm/docker-sync.yml
    sed -i '' "s/$oldname/$code_project/g" $name_project/config/vm/nginx/conf/default.conf
    sed -i '' "s/$oldname/$code_project/g" $name_project/config/vm/php-fpm56/Dockerfile
    sed -i '' "s/$oldname/$code_project/g" $name_project/config/vm/php-fpm70/Dockerfile
    sed -i '' "s/$oldname/$code_project/g" $name_project/config/vm/php-fpm71/Dockerfile
    sed -i '' "s/$oldname/$code_project/g" $name_project/scripts/dbinfo.conf
    sed -i '' "s/$oldname/$code_project/g" $name_project/scripts/post-checkout
    sed -i '' "s/$oldname/$code_project/g" $name_project/scripts/docker-help.sh

    echo 'Insert alias'
    echo "### Alias $code_project ##" >> ~/.bash_aliases
    echo "alias "$code_project"_rebuild=\"cd $path_workspace/$name_project/config/vm && docker-compose -f docker-compose.yml -f docker-compose-dev.yml build\"" >> ~/.bash_aliases
    echo "alias "$code_project"_start=\"cd $path_workspace/$name_project/config/vm && docker-sync start && docker-compose -f docker-compose.yml -f docker-compose-dev.yml up --remove-orphans\"" >> ~/.bash_aliases
    echo "alias "$code_project"_stop=\"cd $path_workspace/$name_project/config/vm && docker-sync stop && docker-compose stop\"" >> ~/.bash_aliases
    echo "alias "$code_project"_logs=\"cd $path_workspace/$name_project/config/vm && docker-sync logs -f\"" >> ~/.bash_aliases
    echo "alias "$code_project"_phpfpm=\"docker exec -it -u www-data $code_project-phpfpm /bin/bash\"" >> ~/.bash_aliases
    echo "alias "$code_project"_nginx=\"docker exec -it -u root $code_project-nginx /bin/bash\"" >> ~/.bash_aliases
    echo "alias "$code_project"_db=\"docker exec -it -u root $code_project-db /bin/bash\"" >> ~/.bash_aliases
    echo "" >> ~/.bash_aliases

    echo 'To Start the project:'
    echo "cd $HOME/$path_workspace/$name_project/config/vm"
    echo 'docker-sync start'
    echo 'docker-compose -f docker-compose.yml -f docker-compose-dev.yml up'
    echo ''
    echo 'To connect a container'
    echo "docker exec -it -uwww-data $code_project-phpfpm /bin/bash"
    echo ''
    echo 'List containers'
    echo "- $code_project-phpfpm"
    echo "- $code_project-db"
    echo "- $code_project-elasticsearch"
    echo "- $code_project-nginx"
    echo ''
    echo 'List users'
    echo "- www-data"
    echo "- root"
fi
