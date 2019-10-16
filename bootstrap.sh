# centos/7 bootstrap.sh
# Installs The Following Packages:
# - apache2
# - mariadb
# - php
# - vim
# - wget
# - zip
# - unzip
# Note: It is recomended that you run the postFirstVUpRunner.sh script
#       immediatly after logging in via vagrant ssh after initial vargrant up.

# Perform initial updates | update is safer than upgrade with yum
# @see https://unix.stackexchange.com/questions/55777/in-centos-what-is-the-difference-between-yum-update-and-yum-upgrade
yum update -y

# Php7.3 | Guide @see https://tecadmin.net/install-php7-on-centos7/
#  Enable Remi and EPEL yum repositories on your system.
yum install epel-release -y
# Install Remi repositoryinstall Remi repository.
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
# Install PHP 7.3.
yum --enablerepo=remi-php73 install php -y
# Install desired php modules using remi repo.
yum --enablerepo=remi-php73 install php-xml php-soap php-xmlrpc php-mbstring php-json php-gd php-mcrypt php-bcmath php-zip php-mysql php-pdo -y

# Install Apache.
yum install httpd -y
# start Apache
systemctl start httpd.service
# enable Apache to start on boot
systemctl enable httpd.service

# Install MariaDB.
### DONT FORGET TO RUN THE mariaDBPostVup.sh script ON INITIAL SSH LOG IN  TO FINISH CONFIGURATION OF mariaDB ###
yum install mariadb-server mariadb -y
# start MariaDB
systemctl start mariadb

# Hacks
# Centos7 has an issue with apache forbidding access to /var/www/html and sub dirs/files | The only solution
# I could find is at https://serverfault.com/questions/374883/centos-apache-httpd-configuration-403-forbidden
# which advises the following command be run, so I am placing it here so it is run for all instances of this box.
# Note: You may need to run this command manually occasionally even though it is run here.
#       You will know you need to run this command if apache only shows the welcome page
#       when accessing the ip address specified in the Vagrantfile.
setenforce 0

# Install tools.
yum install vim -y
yum install wget -y
yum install zip -y
yum install unzip -y

# Perform final updates
yum update -y
