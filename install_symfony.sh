#!/bin/sh
# @Author: gicque_p
# @Date:   2015-07-06 21:18:26
# @Last Modified by:   gicque_p
# @Last Modified time: 2015-07-08 15:01:47

sudo curl -LsS http://symfony.com/installer -o /usr/local/bin/symfony
sudo chmod a+x /usr/local/bin/symfony

php -r "readfile('http://symfony.com/installer');" > symfony
php -r "eval('?>'.file_get_contents('http://getcomposer.org/installer'));"

symfony self-update
composer self-update
