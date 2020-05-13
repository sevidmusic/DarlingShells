#!/bin/bash

set -o posix

[[ ! -d /var/www/html/.dcmsJsonData ]] && exit

cd /var/www/html/.dcmsJsonData

[[ -d ./dcmsdev ]] && rm -R ./dcmsdev && printf "\n\nRemoved dcmsdev\n\n"  && sleep 1

cd /var/www/html/Apps/dcmsDev

/usr/bin/php ./Components.php

clear

/usr/bin/curl dcms.dev

printf "\n\n"
