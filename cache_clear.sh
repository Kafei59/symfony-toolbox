#!/bin/sh
# @Author: gicque_p
# @Date:   2015-07-06 22:00:29
# @Last Modified by:   gicque_p
# @Last Modified time: 2015-07-08 14:02:36

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

PROJECT=$(echo $1 | sed s'/[\/]*$//')

sudo rm -rf "$PROJECT"/app/cache/*
sudo rm -rf "$PROJECT"/app/logs/*

php "$PROJECT"/app/console cache:clear --env=dev
php "$PROJECT"/app/console cache:clear --env=prod

sudo chmod -R 777 "$PROJECT"/app/cache/
sudo chmod -R 777 "$PROJECT"/app/logs/
