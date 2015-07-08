#!/bin/sh
# @Author: gicque_p
# @Date:   2015-07-06 21:13:24
# @Last Modified by:   gicque_p
# @Last Modified time: 2015-07-08 14:24:16

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

if [ ! -f "composer.phar" ];
	then
	echo "Composer.phar file missing, try launching install_symfony.sh to create one"
	exit 1
fi

PROJECT=$(echo $1 | sed s'/[\/]*$//')

symfony new "$PROJECT"
php "$PROJECT"/app/check.php
php "$PROJECT"/app/console generate:bundle --namespace="$PROJECT"/CoreBundle --bundle-name="$PROJECT"CoreBundle --dir="$PROJECT"/src/ --format=yml --structure --no-interaction

echo "\n"$PROJECT"_core_index:\n    path:     /\n    defaults: { _controller: "$PROJECT"CoreBundle:Default:index, name: World }" >> "$PROJECT"/src/"$PROJECT"/CoreBundle/Resources/config/routing.yml

cd "$PROJECT"
sudo php ../composer.phar require doctrine/doctrine-fixtures-bundle
sudo php ../composer.phar update
sed -i '/SensioGeneratorBundle();/a$bundles[] = new Doctrine\\Bundle\\FixturesBundle\\DoctrineFixturesBundle();' app/AppKernel.php
cd ..

sed -i "s/symfony/"$PROJECT"/g" "$PROJECT"/app/config/parameters.yml
sed -i "s/symfony/"$PROJECT"/g" "$PROJECT"/app/config/parameters.yml.dist

sudo rm -rf "$PROJECT"/app/cache/*
sudo rm -rf "$PROJECT"/app/logs/*

php "$PROJECT"/app/console cache:clear --env=dev --no-warmup
php "$PROJECT"/app/console cache:clear --env=prod --no-warmup

sudo chmod -R 777 "$PROJECT"/app/cache/
sudo chmod -R 777 "$PROJECT"/app/logs/

php "$PROJECT"/app/console doctrine:database:create --if-not-exists
php "$PROJECT"/app/console doctrine:ensure-production-settings --env=dev
php "$PROJECT"/app/console doctrine:ensure-production-settings --env=prod

sudo rm -rf "$PROJECT"/app/cache/*
sudo rm -rf "$PROJECT"/app/logs/*

php "$PROJECT"/app/console cache:clear --env=dev
php "$PROJECT"/app/console cache:clear --env=prod

sudo chmod -R 777 "$PROJECT"/app/cache/
sudo chmod -R 777 "$PROJECT"/app/logs/
