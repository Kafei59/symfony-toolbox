#!/bin/sh
# @Author: gicque_p
# @Date:   2015-07-06 23:04:37
# @Last Modified by:   gicque_p
# @Last Modified time: 2015-07-06 23:34:08

if [ -z "$1" ]
  then
    echo "[USAGE] $0: <project_folder>"
    exit 1
fi

if [ ! -d "$1" ]
	then
	echo "Folder does not exists"
	exit 1
fi

cd $1
sudo php ../composer.phar require friendsofsymfony/user-bundle
sudo php ../composer.phar update
sudo sed -i '/CoreBundle(),/anew FOS\\UserBundle\\FOSUserBundle(),' app/AppKernel.php
cd ..

sudo rm -rf $1/app/cache/*
sudo rm -rf $1/app/logs/*

php $1/app/console cache:clear --env=prod

chmod -R 777 $1/app/cache/
chmod -R 777 $1/app/logs/
