#!/bin/sh
# @Author: gicque_p
# @Date:   2015-07-06 21:13:24
# @Last Modified by:   gicque_p
# @Last Modified time: 2015-07-06 21:53:26

if [ -z "$1" ]
  then
    echo "[USAGE] ./create_project.sh: <project_folder>"
    exit 1
fi

symfony new $1
php $1/app/check.php
php $1/app/console generate:bundle --namespace=$1/Bundle/CoreBundle --bundle-name=$1CoreBundle --dir=$1/src/ --format=yml --structure --no-interaction

rm -rf $1/app/cache/*
rm -rf $1/app/logs/*

chmod -R 777 $1/app/cache/
chmod -R 777 $1/app/logs/

echo "\n$1_core_index:\n    path:     /\n    defaults: { _controller: $1CoreBundle:Default:index, name: World }" >> $1/src/$1/Bundle/CoreBundle/Resources/config/routing.yml