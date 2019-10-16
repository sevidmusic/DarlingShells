# Hacks
# Centos7 has an issue with apache forbidding access to /var/www/html and sub dirs/files | The only solution
# I could find is at https://serverfault.com/questions/374883/centos-apache-httpd-configuration-403-forbidden
# which advises the following command be run, so I am placing it here so it is run for all instances of this box.
setenforce 0