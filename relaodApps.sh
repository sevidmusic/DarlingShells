#!/bin/bash
set -o posix
clear
[[ ! -d /var/www/html/.dcmsJsonData/dcmsdev ]] && printf "\n\n dcmsdev App is not installed\n\n" && sleep 3 && clear && exit
[[ ! -d /var/www/html/Apps/dcmsDev ]] && printf "\n\ndcmsDev app does not exist\n\n" && sleep 3 && clear && exit
/var/www/html/vendor/phpunit/phpunit/phpunit -c /var/www/html/php.xml && sleep 3 && clear
printf "\n\nRe-installing dcmsdev components\n\n" && sleep 3 && cd /var/www/html/Apps/dcmsDev && /usr/bin/php ./Components.php && clear
[[ ! -d /var/www/html/.dcmsJsonData/dcmsdev ]] && printf "\n\nFailed to install components\n\n" && sleep 3 && clear && exit
/usr/bin/curl dcms.dev
cd /var/www/html
