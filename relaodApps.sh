#!/bin/bash
set -o posix

clear

[[ -d /var/www/html/.dcmsJsonData ]] && rm -r /var/www/html/.dcmsJsonData

cd /var/www/html/Apps/dcmsDev && /usr/bin/php ./Components.php

clear

[[ ! -d /var/www/html/.dcmsJsonData/dcmsdev ]] && printf "\n\nFailed to install components\n\n"

sleep 2

/usr/bin/w3m -dump dcms.dev

# to use phpunit:
#/var/www/html/vendor/phpunit/phpunit/phpunit -c /var/www/html/php.xml && sleep 3 && clear
