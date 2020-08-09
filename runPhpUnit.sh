#!/bin/bash

set -o posix

clear

source /home/vagrant/Code/DarlingShells/.bash_functions

# showLoadingBar "Running PhpUnit Tests"

# Run PhpUnit normally
cd /var/www/html

[[ -z $1 ]] && /var/www/html/vendor/phpunit/phpunit/phpunit -c /var/www/html/php.xml || /var/www/html/vendor/phpunit/phpunit/phpunit -c /var/www/html/php.xml --testsuite $1

