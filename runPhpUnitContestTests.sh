#!/bin/bash

set -o posix

source /home/vagrant/Code/DarlingShells/.bash_functions

clear

showLoadingBar "PhpUnit will run the \"Darling Cms Redesign | Contest Extension Tests\" test suite shortly..."

sl -Fl

clear

sleep 2

showLoadingBar "Moving into DarlingCms root directory"

cd /var/www/html

showLoadingBar "Removing .dcmsJsonData"

[[ -d /var/www/html/.dcmsJsonData ]] && rm -r /var/www/html/.dcmsJsonData

/var/www/html/vendor/phpunit/phpunit/phpunit -c /var/www/html/php.xml --testsuite "Darling Cms Redesign | Contest Extension Tests"

sleep 15

clear
