#!/bin/sh
# @Author: gicque_p
# @Date:   2015-07-06 22:00:29
# @Last Modified by:   gicque_p
# @Last Modified time: 2015-07-06 22:09:08

if [ -z "$1" ]
  then
    echo "[USAGE] $0: <project_folder>"
    exit 1
fi

if [ ! -d "$1" ]
	then
	echo "Folder not a directory"
	exit 1
fi

sudo rm -rf $1/app/cache/*
sudo rm -rf $1/app/logs/*

php $1/app/console cache:clear --env=prod

chmod -R 777 $1/app/cache/
chmod -R 777 $1/app/logs/
