#!/bin/sh
# @Author: gicque_p
# @Date:   2015-07-06 23:04:37
# @Last Modified by:   gicque_p
# @Last Modified time: 2015-07-08 15:10:51

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

if [ -d "$1/src/$1/UserBundle" ]
    then
    echo "UserBundle already exists"
    exit 1
fi

PROJECT=$(echo $1 | sed s'/[\/]*$//')
NAME=$(echo "$PROJECT" | rev | cut -d'/' -f 1 | rev)

cd "$PROJECT"
sudo php composer.phar require friendsofsymfony/user-bundle
sudo php composer.phar update
sed -i '/CoreBundle(),/anew FOS\\UserBundle\\FOSUserBundle(),' app/AppKernel.php
cd -

sudo rm -rf "$PROJECT"/app/cache/*
sudo rm -rf "$PROJECT"/app/logs/*

php "$PROJECT"/app/console cache:clear --env=dev --no-warmup
php "$PROJECT"/app/console cache:clear --env=prod --no-warmup

sudo chmod -R 777 "$PROJECT"/app/cache/
sudo chmod -R 777 "$PROJECT"/app/logs/

echo "
#FOSUser Configuration
fos_user:
    db_driver:     orm
    firewall_name: main
    user_class:    "$NAME"\UserBundle\Entity\User" >> "$PROJECT"/app/config/config.yml

echo "
fos_user_security:
    resource: \"@FOSUserBundle/Resources/config/routing/security.xml\"

fos_user_profile:
    resource: \"@FOSUserBundle/Resources/config/routing/profile.xml\"
    prefix: /profile

fos_user_register:
    resource: \"@FOSUserBundle/Resources/config/routing/registration.xml\"
    prefix: /register

fos_user_resetting:
    resource: \"@FOSUserBundle/Resources/config/routing/resetting.xml\"
    prefix: /resetting

fos_user_change_password:
    resource: \"@FOSUserBundle/Resources/config/routing/change_password.xml\"
    prefix: /profile" >> "$PROJECT"/app/config/routing.yml

echo "security:
    encoders:
        "$NAME"\UserBundle\Entity\User: sha512

    providers:
        main:
            id: fos_user.user_provider.username

    firewalls:
        main:
            pattern:        ^/
            anonymous:      true
            provider:       main
            form_login:
                login_path: fos_user_security_login
                check_path: fos_user_security_check
            logout:
                path:       fos_user_security_logout
                target:     /
            remember_me:
                key:        %secret%" > "$PROJECT"/app/config/security.yml

php "$PROJECT"/app/console generate:bundle --namespace="$NAME"/UserBundle --bundle-name="$NAME"UserBundle --dir="$PROJECT"/src/ --format=yml --structure --no-interaction

echo "<?php
namespace "$NAME"\UserBundle;

use Symfony\Component\HttpKernel\Bundle\Bundle;

class "$NAME"UserBundle extends Bundle
{
  public function getParent()
  {
    return 'FOSUserBundle';
  }
}" > "$PROJECT"/src/"$NAME"/UserBundle/"$NAME"UserBundle.php

sudo rm -rf "$PROJECT"/app/cache/*
sudo rm -rf "$PROJECT"/app/logs/*

php "$PROJECT"/app/console cache:clear --env=dev --no-warmup
php "$PROJECT"/app/console cache:clear --env=prod --no-warmup

sudo chmod -R 777 "$PROJECT"/app/cache/
sudo chmod -R 777 "$PROJECT"/app/logs/

php "$PROJECT"/app/console doctrine:generate:entity --entity="$NAME"UserBundle:User --format=annotation --with-repository --no-interaction
sed -i '/as ORM;/ause FOS\\UserBundle\\Entity\\User as BaseUser;' "$PROJECT"/src/"$NAME"/UserBundle/Entity/User.php
sed -i "s/class User/class User extends BaseUser/g" "$PROJECT"/src/"$NAME"/UserBundle/Entity/User.php
sed -i "s/private \$id;/protected \$id;/g" "$PROJECT"/src/"$NAME"/UserBundle/Entity/User.php

sudo rm -rf "$PROJECT"/app/cache/*
sudo rm -rf "$PROJECT"/app/logs/*

php "$PROJECT"/app/console cache:clear --env=dev --no-warmup
php "$PROJECT"/app/console cache:clear --env=prod --no-warmup

sudo chmod -R 777 "$PROJECT"/app/cache/
sudo chmod -R 777 "$PROJECT"/app/logs/

php "$PROJECT"/app/console doctrine:schema:update --dump-sql
php "$PROJECT"/app/console doctrine:schema:update --force

sudo rm -rf "$PROJECT"/app/cache/*
sudo rm -rf "$PROJECT"/app/logs/*

php "$PROJECT"/app/console cache:clear --env=dev
php "$PROJECT"/app/console cache:clear --env=prod --no-warmup

sudo chmod -R 777 "$PROJECT"/app/cache/
sudo chmod -R 777 "$PROJECT"/app/logs/
