sed -i  '/;error_log = php_errors.log/ c\error_log = /var/www/logs/php_errors.log' /etc/php.ini
