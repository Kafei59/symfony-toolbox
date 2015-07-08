#!/bin/sh
# @Author: gicque_p
# @Date:   2015-07-06 22:31:33
# @Last Modified by:   gicque_p
# @Last Modified time: 2015-07-08 13:28:12

if [ -z "$1" ] || [ -z "$2" ]
  then
    echo "[USAGE] $0: <project_folder> <bundle_name>"
    exit 1
fi

if [ ! -d "$1" ]
	then
	echo "Folder does not exists"
	exit 1
fi

if [ -d "$1/src/$1/$2Bundle" ]
	then
	echo "Bundle already exists"
	exit 1
fi

PROJECT=$(echo $1 | sed s'/[\/]*$//')

php "$PROJECT"/app/console generate:bundle --namespace="$PROJECT"/$2Bundle --bundle-name="$PROJECT"$2Bundle --dir="$PROJECT"/src/ --format=yml --structure --no-interaction
