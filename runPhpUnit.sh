#!/bin/bash

set -o posix

clear

source /home/vagrant/Code/DarlingShells/.bash_functions

showLoadingBar "PhpUnit will run all tests shortly..."

sl -Fl

clear

showLoadingBar "One more moment, waiting in case other test suites are running..."

sleep 2

# Run PhpUnit normally
cd /var/www/html && /var/www/html/vendor/phpunit/phpunit/phpunit -c /var/www/html/php.xml

# Run PhpUnit with verbose output
#cd /var/www/html && /var/www/html/vendor/phpunit/phpunit/phpunit -c /var/www/html/php.xml --verbose --debug | grep -En '^[A-Z]|::|^Test|started|interfaces|classes|abstractions' --color

#sleep 15

#clear
