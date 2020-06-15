#!/bin/bash
set -o posix

cd /var/www/html # && /var/www/html/vendor/phpunit/phpunit/phpunit -c /var/www/html/php.xml

clear

[[ -d /var/www/html/.dcmsJsonData ]] && rm -r /var/www/html/.dcmsJsonData

cd /var/www/html/Apps/dcmsDev && /usr/bin/php ./Components.php
cd /var/www/html/Apps/blackballotpowercontest && /usr/bin/php ./Components.php
cd /var/www/html/Apps/WorkingDemo && /usr/bin/php ./Components.php

clear

[[ ! -d /var/www/html/.dcmsJsonData/dcmsdev ]] && printf "\n\nFailed to install dcmsdev components\n\n"
[[ ! -d /var/www/html/.dcmsJsonData/blackballotpowercontestlocal ]] && printf "\n\nFailed to install blackballotpowercontest components\n\n"
[[ ! -d /var/www/html/.dcmsJsonData/1921683310 ]] && printf "\n\nFailed to install Working Demo components\n\n"

sleep 2
clear

/usr/bin/w3m -dump dcms.dev

sleep 3
clear

/usr/bin/w3m -dump blackballotpowercontest.local

sleep 3
clear

/usr/bin/w3m -dump 192.168.33.10

sleep 3
clear
