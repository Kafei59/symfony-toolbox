#!/bin/sh
# @Author: gicque_p
# @Date:   2015-07-06 21:13:24
# @Last Modified by:   gicque_p
# @Last Modified time: 2015-07-06 22:22:10

if [ -z "$1" ]
  then
    echo "[USAGE] $0: <project_folder>"
    exit 1
fi

if [ -d "$1" ]
	then
	echo "Folder already exists"
	exit 1
fi

if [ ! -f "symfony" ];
	then
	echo "Symfony file missing, try launching install_symfony.sh to create one"
	exit 1
fi

symfony new $1
php $1/app/check.php
php $1/app/console generate:bundle --namespace=$1/Bundle/CoreBundle --bundle-name=$1CoreBundle --dir=$1/src/ --format=yml --structure --no-interaction

echo "\n$1_core_index:\n    path:     /\n    defaults: { _controller: $1CoreBundle:Default:index, name: World }" >> $1/src/$1/Bundle/CoreBundle/Resources/config/routing.yml

cd $1
sudo composer update
cd ..

sudo rm -rf $1/app/cache/*
sudo rm -rf $1/app/logs/*

php $1/app/console cache:clear --env=prod

chmod -R 777 $1/app/cache/
chmod -R 777 $1/app/logs/
