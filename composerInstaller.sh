# Install Composer.
EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', '/usr/local/bin/composer-setup.php');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', '/usr/local/bin/composer-setup.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'COMPOSER INSTALL ERROR: Invalid installer signature'
    rm /usr/local/bin/composer-setup.php
    exit 1
fi

php /usr/local/bin/composer-setup.php --install-dir=/usr/local/bin --filename=composer
RESULT=$?
rm /usr/local/bin/composer-setup.php
exit $RESULT